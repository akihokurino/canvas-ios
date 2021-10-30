import SwiftUI

struct Lorenz3D: View {
    private static let OBJECT_NUM = 30
    private static let OBJECT_WIDTH: CGFloat = 1.5
    private static let FRAME_CAP = 300
    private static let FRAME_RATE: CGFloat = 0.05
    private static let P: CGFloat = 10
    private static let R: CGFloat = 28
    private static let B: CGFloat = 8 / 3
    private static let DT: CGFloat = 0.01
    
    @ObservedObject var recorder = Recorder(work: Work.lorenz3D)
    
    @State private var objects: [Object] = []
    @State private var canvasRect: CGRect = .zero
    @State private var timer: Timer? = nil
    @State private var archive: UIImage? = nil
    @State private var frameCount: Int = 0
    
    private var layer1: some View {
        ForEach(objects) { object in
            Path { path in
                path.addLines(object.points.map { $0.point2D })
            }
            .stroke(object.color, lineWidth: Lorenz3D.OBJECT_WIDTH)
            .frame(width: canvasWidth(), height: canvasHeight())
            .clipped()
        }
    }
    
    var body: some View {
        GeometryReader { _ in
            ZStack {
                if archive != nil {
                    Image(uiImage: archive!)
                        .frame(width: canvasWidth(), height: canvasHeight())
                }
                
                layer1
            }
            .background(Color.black)
            .background(RectangleGetter(rect: $canvasRect))
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
                        archive = nil
                        objects.removeAll()
                        for i in 0 ..< Lorenz3D.OBJECT_NUM {
                            objects.append(Object(x: CGFloat(i), y: CGFloat(i), z: CGFloat(i)))
                        }
                    }) {
                        Image(systemName: "arrow.counterclockwise")
                    }
                }
            )
            .onAppear {
                for i in 0 ..< Lorenz3D.OBJECT_NUM {
                    objects.append(Object(x: CGFloat(i), y: CGFloat(i), z: CGFloat(i)))
                }
                
                timer = Timer.scheduledTimer(withTimeInterval: Lorenz3D.FRAME_RATE, repeats: true) { _ in
                    guard frameCount <= Lorenz3D.FRAME_CAP else {
                        return
                    }
                    
                    for i in 0 ..< objects.count {
                        objects[i].update()
                    }
                    
                    frameCount += 1
                    
                    if frameCount > Lorenz3D.FRAME_CAP {
                        archive = screenshot(rect: self.canvasRect)
                        for i in 0 ..< objects.count {
                            objects[i].clear()
                        }
                        frameCount = 0
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

    private struct Point3D {
        let x: CGFloat
        let y: CGFloat
        let z: CGFloat
            
        var point2D: CGPoint {
            let width = canvasWidth() / 2
            let height = canvasHeight() / 2
            return CGPoint(x: x * 12 + width, y: y * 8 + height)
        }
    }
    
    private struct Object: Identifiable {
        let id = UUID()
        let color: Color
        
        var points: [Point3D]
       
        init(x: CGFloat, y: CGFloat, z: CGFloat) {
            self.color = Color(hue: Double.random(in: 1 ... 360) / 360.0, saturation: 1.0, brightness: 1.0, opacity: 1.0)
            self.points = [Point3D(x: x, y: y, z: z)]
        }
    
        mutating func update() {
            let last = points.last!
            
            var dx = -Lorenz3D.P * last.x + Lorenz3D.P * last.y
            var dy = -last.x * last.z + Lorenz3D.R * last.x - last.y
            var dz = last.x * last.y - Lorenz3D.B * last.z
            
            dx *= Lorenz3D.DT
            dy *= Lorenz3D.DT
            dz *= Lorenz3D.DT
            
            points.append(Point3D(x: last.x + dx, y: last.y + dy, z: last.z + dz))
        }
        
        mutating func clear() {
            points = [points.last!]
        }
    }
}
