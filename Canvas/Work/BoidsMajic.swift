import SwiftUI

struct BoidsMajic: View {
    private static let START_POINT = centerPoint()
    private static let OBJECT_NUM = 500
    private static let OBJECT_COLOR = Color(hue: 240.0 / 360.0, saturation: 0.77, brightness: 0.43, opacity: 1.0)
    private static let OBJECT_WIDTH: CGFloat = 1.5
    private static let OBJECT_MAX_RADIUS: CGFloat = 300
    private static let OBJECT_INIT_RADIUS: CGFloat = 10
    private static let FRAME_RATE: CGFloat = 0.05
    private static let DELTA: CGFloat = 10
    
    @ObservedObject var recorder = Recorder(work: Work.boidsMajic)
    
    @State private var objects: [Object] = []
    @State private var timer: Timer? = nil
    
    private var layer1: some View {
        ForEach(objects) { object in
            Path { path in
                drawEachDot(&path, object)
            }
            .stroke(BoidsMajic.OBJECT_COLOR, lineWidth: BoidsMajic.OBJECT_WIDTH)
            .frame(width: canvasWidth(), height: canvasHeight())
            .clipped()
        }
    }
    
    var body: some View {
        GeometryReader { _ in
            ZStack {
                layer1
            }
            .background(Color.white)
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
                        objects.removeAll()
                        for _ in 0 ..< BoidsMajic.OBJECT_NUM {
                            objects.append(Object())
                        }
                    }) {
                        Image(systemName: "arrow.counterclockwise")
                    }
                }
            )
            .onAppear {
                for _ in 0 ..< BoidsMajic.OBJECT_NUM {
                    objects.append(Object())
                }
                
                timer = Timer.scheduledTimer(withTimeInterval: BoidsMajic.FRAME_RATE, repeats: true) { _ in
                    for i in 0 ..< objects.count {
                        objects[i].update()
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
    
    private func drawEachDot(_ path: inout Path, _ object: Object) {
        path.addArc(center: object.point, radius: object.radius, startAngle: .degrees(0), endAngle: .degrees(360), clockwise: false)
    }
    
    private struct Object: Identifiable {
        let id = UUID()
    
        var step: CGFloat = randfloat(min: 1, max: 5)
        var radius: CGFloat = BoidsMajic.OBJECT_INIT_RADIUS
        var point: CGPoint = BoidsMajic.START_POINT
    
        mutating func update() {
            let vx = randfloat(min: -BoidsMajic.DELTA, max: BoidsMajic.DELTA)
            let vy = randfloat(min: -BoidsMajic.DELTA, max: BoidsMajic.DELTA)
            
            let nextX = point.x + vx
            let nextY = point.y + vy
            
            point = CGPoint(x: nextX, y: nextY)
            radius += step
            
            if radius >= BoidsMajic.OBJECT_MAX_RADIUS {
                radius = BoidsMajic.OBJECT_INIT_RADIUS
                step = randfloat(min: 1, max: 5)
                point = BoidsMajic.START_POINT
            }
        }
    }
}
