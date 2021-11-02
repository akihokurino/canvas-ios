import AVKit
import SwiftUI

struct VideoView: UIViewRepresentable {
    let url: URL

    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<VideoView>) {}

    func makeUIView(context: Context) -> UIView {
        let player = AVPlayer(url: url)
        return VideoUIView(player: player)
    }
}

class VideoUIView: UIView {
    private let playerLayer = AVPlayerLayer()

    init(player: AVPlayer) {
        super.init(frame: .zero)

        playerLayer.player = player
        layer.addSublayer(playerLayer)

        player.actionAtItemEnd = .none

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(playerItemDidReachEnd(notification:)),
            name: .AVPlayerItemDidPlayToEndTime,
            object: player.currentItem)

        player.play()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc
    func playerItemDidReachEnd(notification: Notification) {
        playerLayer.player?.seek(to: CMTime.zero)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer.frame = bounds
    }
}
