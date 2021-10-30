import SwiftUI

struct LineArt2: View {
    private static let FRAME_RATE: CGFloat = 0.05
    private static let OBJECT_WIDTH: CGFloat = 0.5
    private static let OBJECT_NUM = 430
    
    @ObservedObject var recorder = Recorder(work: Work.lineArt2)
    
    @State private var objects: [Object] = []
    @State private var timer: Timer? = nil
    @State private var globalCount: Int = 0
    @State private var hue: Double = 1
    
    private var layer1: some View {
        ForEach(objects) { object in
            Path { path in
                path.addLines(object.points)
            }
            .stroke(object.color, lineWidth: LineArt2.OBJECT_WIDTH)
            .frame(width: canvasWidth(), height: canvasHeight())
            .clipped()
        }
    }
    
    var body: some View {
        GeometryReader { _ in
            ZStack {
                layer1
            }
            .background(Color.black)
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarItems(
                trailing: HStack {
                    Button(action: {
                        recorder.toggle()
                    }) {
                        if recorder.isRecording {
                            Image(systemName: "record.circle.fill")
                        } else {
                            Image(systemName: "record.circle")
                        }
                    }
                    Spacer().frame(width: 20)
                    Button(action: {
                        hue = 0
                        globalCount = 0
                        objects.removeAll()
                        for _ in 0 ..< LineArt2.OBJECT_NUM {
                            objects.append(Object(hue: hue / 360.0))
                        }
                    }) {
                        Image(systemName: "arrow.counterclockwise")
                    }
                }
            )
            .onAppear {
                for _ in 0 ..< LineArt2.OBJECT_NUM {
                    objects.append(Object(hue: hue / 360.0))
                }
                
                timer = Timer.scheduledTimer(withTimeInterval: LineArt2.FRAME_RATE, repeats: true) { _ in
                    globalCount += 1
                    hue += 1
                    
                    for i in 0 ..< objects.count {
                        objects[i].update(hue: hue / 360.0, index: CGFloat(i), globalCount: CGFloat(globalCount))
                    }
                    
                    if hue > 360 {
                        hue = 0
                    }
                }
            }
            .onDisappear {
                timer?.invalidate()
                if recorder.isRecording {
                    recorder.stop(withUpload: false)
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
                if recorder.isRecording {
                    recorder.stop(withUpload: false)
                }
            }
            .drawingGroup()
        }
    }
    
    private struct Object: Identifiable {
        let id = UUID()
        
        var color: Color
        var startPoint: CGPoint
        var endPoint: CGPoint
        
        var points: [CGPoint] {
            return [startPoint, endPoint]
        }
        
        init(hue: Double) {
            self.color = Color(hue: hue, saturation: 1.0, brightness: 1.0, opacity: 1.0)
            
            let point = CGPoint(
                x: CGFloat.random(in: 0 ..< 1) * canvasWidth(),
                y: CGFloat.random(in: 0 ..< 1) * canvasHeight()
            )
            self.startPoint = point
            self.endPoint = point
        }
        
        mutating func update(hue: Double, index: CGFloat, globalCount: CGFloat) {
            color = Color(hue: hue, saturation: 1.0, brightness: 1.0, opacity: 1.0)
            startPoint = endPoint
            endPoint = CGPoint(
                x: index * sin(globalCount / 360.0 * 2 * CGFloat.pi * index) + canvasWidth() / 2,
                y: index * cos(globalCount / 360.0 * 2 * CGFloat.pi * index) + canvasHeight() / 2
            )
        }
    }
}
