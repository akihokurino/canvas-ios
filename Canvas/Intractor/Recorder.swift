import Combine
import ReplayKit
import SwiftUI

class Recorder: ObservableObject {
    struct Configuration {
        let codec: AVVideoCodecType = .h264
        let fileType: AVFileType = .mp4
        let videoSize = CGSize(width: UIScreen.main.bounds.size.width * UIScreen.main.scale, height: UIScreen.main.bounds.size.height * UIScreen.main.scale)
        let audioQuality = AVAudioQuality.medium
        let audioFormatID: AudioFormatID = kAudioFormatMPEG4AAC
        let numberOfChannels: UInt = 2
        let sampleRate: Double = 44100.0
        let bitrate: UInt = 16
    }

    private let recorder = RPScreenRecorder.shared()
    private let configuration = Configuration()
    private let work: Work
    private var assetWriter: AVAssetWriter?
    private var videoAssetWriterInput: AVAssetWriterInput?
    private var writerInputPixelBufferAdaptor: AVAssetWriterInputPixelBufferAdaptor?
    private var startTime: CMTime?
    private var cancellable: AnyCancellable?

    private var cacheDirectoryURL: URL? = {
        guard let path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first else {
            return nil
        }

        return URL(fileURLWithPath: path).appendingPathComponent("Recorder")
    }()

    private var cacheFileURL: URL? {
        guard let cacheDirectoryURL = cacheDirectoryURL else { return nil }

        return cacheDirectoryURL.appendingPathComponent("record.mp4")
    }

    init(work: Work) {
        self.work = work
    }

    @Published var isRecording = false
    @Published var errorProvider: AppError?

    func toggle() {
        if isRecording {
            stop()
        } else {
            start()
        }
    }

    func start() {
        guard recorder.isAvailable else {
            errorProvider = .plain("録画を利用できません")
            return
        }
        guard !recorder.isRecording else {
            errorProvider = .plain("すでに録画中です")
            return
        }

        startTime = nil

        do {
            try prepare()
        } catch {
            errorProvider = AppError.defaultError()
            return
        }

        assetWriter?.startWriting()
        assetWriter?.startSession(atSourceTime: CMTime.zero)

        recorder.startCapture(handler: { buffer, bufferType, error in
            guard error == nil else {
                return
            }

            if !self.isRecording {
                DispatchQueue.main.async {
                    self.isRecording = true
                }
            }

            if RPSampleBufferType.video == bufferType {
                self.appendVideo(buffer: buffer)
            }
        }, completionHandler: { _ in

        })
    }

    func stop(withUpload: Bool = true) {
        guard recorder.isAvailable else {
            errorProvider = .plain("録画を利用できません")
            return
        }
        guard recorder.isRecording else {
            errorProvider = .plain("すでに録画が終了しています")
            return
        }

        recorder.stopCapture { error in
            guard error == nil else {
                return
            }

            self.videoAssetWriterInput?.markAsFinished()
            self.assetWriter?.finishWriting {
                DispatchQueue.main.async {
                    self.isRecording = false
                    self.startTime = nil

                    guard withUpload else {
                        return
                    }
                    self.upload()
                }
            }
        }
    }

    private func upload() {
        guard let url = cacheFileURL else {
            return
        }

        let data: Data
        do {
            data = try Data(contentsOf: url)
        } catch {
            return
        }

        let path = "\(work.rawValue).mp4"

        cancellable?.cancel()
        cancellable = FirebaseStorageManager.shared.uploadVideo(data: data, path: path).sink(receiveCompletion: { completion in
            switch completion {
            case .finished:
                break
            case .failure(let error):
                self.errorProvider = error
            }
        }, receiveValue: { _ in
            print("Complete Upload Video")
        })
    }

    private func prepare() throws {
        try createCacheDirectoryIfNeeded()
        try removeOldCachedFile()

        guard let cacheURL = cacheFileURL else {
            throw AppError.defaultError()
        }

        let assetWriter = try AVAssetWriter(url: cacheURL, fileType: configuration.fileType)

        let videoSetting: [String: Any] = [
            AVVideoCodecKey: configuration.codec,
            AVVideoWidthKey: UInt(configuration.videoSize.width),
            AVVideoHeightKey: UInt(configuration.videoSize.height),
        ]
        let videoAssetWriterInput = AVAssetWriterInput(mediaType: .video, outputSettings: videoSetting)
        videoAssetWriterInput.expectsMediaDataInRealTime = true

        if assetWriter.canAdd(videoAssetWriterInput) {
            assetWriter.add(videoAssetWriterInput)
        }

        self.assetWriter = assetWriter
        self.videoAssetWriterInput = videoAssetWriterInput
        writerInputPixelBufferAdaptor = AVAssetWriterInputPixelBufferAdaptor(assetWriterInput: videoAssetWriterInput, sourcePixelBufferAttributes: [
            kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_32ARGB),
        ])
    }

    private func appendVideo(buffer: CMSampleBuffer) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(buffer) else { return }

        let firstTime: CMTime
        if let startTime = self.startTime {
            firstTime = startTime
        } else {
            firstTime = CMSampleBufferGetPresentationTimeStamp(buffer)
            startTime = firstTime
        }

        let currentTime: CMTime = CMSampleBufferGetPresentationTimeStamp(buffer)
        let diffTime: CMTime = CMTimeSubtract(currentTime, firstTime)

        if writerInputPixelBufferAdaptor?.assetWriterInput.isReadyForMoreMediaData ?? false {
            writerInputPixelBufferAdaptor?.append(pixelBuffer, withPresentationTime: diffTime)
        }
    }

    private func createCacheDirectoryIfNeeded() throws {
        guard let cacheDirectoryURL = cacheDirectoryURL else { return }

        let fileManager = FileManager.default
        guard !fileManager.fileExists(atPath: cacheDirectoryURL.path) else {
            return
        }

        try fileManager.createDirectory(at: cacheDirectoryURL, withIntermediateDirectories: true, attributes: nil)
    }

    private func removeOldCachedFile() throws {
        guard let cacheURL = cacheFileURL else { return }

        let fileManager = FileManager.default
        guard fileManager.fileExists(atPath: cacheURL.path) else { return }

        try fileManager.removeItem(at: cacheURL)
    }
}
