import SwiftUI

struct ParticleRotate3D: View {
    private static let CENTER_POINT = centerPoint()
    private static let OBJECT_POINT_CAP = 10
    private static let OBJECT_NUM = 300
    private static let OBJECT_WIDTH: CGFloat = 1.5
    private static let FRAME_RATE: CGFloat = 0.05
    
    @ObservedObject var recorder = Recorder(work: Work.particleRotate3D)
        
    @State private var dragPoint = CGPoint(x: 0, y: 0)
    @State private var objects: [Object] = []
    @State private var timer: Timer? = nil
        
    var body: some View {
        GeometryReader { _ in
            ZStack {
                ForEach(objects) { object in
                    if object.points.count == ParticleRotate3D.OBJECT_POINT_CAP {
                        Path { path in
                            path.addLines(Array(object.points2D[0 ... 3]))
                        }
                        .stroke(object.color.opacity(0.2), lineWidth: ParticleRotate3D.OBJECT_WIDTH)
                        .frame(width: canvasWidth(), height: canvasHeight())
                        .clipped()
                    }
                }
                
                ForEach(objects) { object in
                    if object.points.count == ParticleRotate3D.OBJECT_POINT_CAP {
                        Path { path in
                            path.addLines(Array(object.points2D[3 ... 6]))
                        }
                        .stroke(object.color.opacity(0.4), lineWidth: ParticleRotate3D.OBJECT_WIDTH)
                        .frame(width: canvasWidth(), height: canvasHeight())
                        .clipped()
                    }
                }
                
                ForEach(objects) { object in
                    if object.points.count >= 4 {
                        Path { path in
                            path.addLines(Array(object.points2D[object.points.count - 4 ..< object.points.count]))
                        }
                        .stroke(object.color, lineWidth: ParticleRotate3D.OBJECT_WIDTH)
                        .frame(width: canvasWidth(), height: canvasHeight())
                        .clipped()
                    }
                }
            }
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 0, coordinateSpace: .local)
                    .onChanged { value in
                        dragPoint = value.location
                    }
                    .onEnded { value in
                        dragPoint = value.location
                    }
            )
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
                        objects.removeAll()
                        dragPoint = CGPoint(x: 0, y: 0)
                        for _ in 0 ..< ParticleRotate3D.OBJECT_NUM {
                            objects.append(Object())
                        }
                    }) {
                        Image(systemName: "arrow.counterclockwise")
                    }
                }
            )
            .onAppear {
                for _ in 0 ..< ParticleRotate3D.OBJECT_NUM {
                    objects.append(Object())
                }
                    
                timer = Timer.scheduledTimer(withTimeInterval: ParticleRotate3D.FRAME_RATE, repeats: true) { _ in
                    for i in 0 ..< objects.count {
                        objects[i].update(point: dragPoint)
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
            let scale: CGFloat = 500.0 / (500.0 + z)
            return CGPoint(x: centerPoint().x + x * scale, y: centerPoint().y + y * scale)
        }
    }
    
    private struct Object: Identifiable {
        let id = UUID()
        let color: Color
        
        var points: [Point3D]
        var points2D: [CGPoint] {
            return points.map { $0.point2D }
        }
        
        init() {
            self.color = Color(hue: Double.random(in: 1 ... 360) / 360.0, saturation: 0.65, brightness: 0.65)
            self.points = [
                Point3D(
                    x: CGFloat.random(in: 0 ..< 1) * canvasWidth() - 50,
                    y: CGFloat.random(in: 0 ..< 1) * canvasWidth() - 50,
                    z: CGFloat.random(in: 0 ..< 1) * canvasWidth() - 50
                )
            ]
        }
            
        mutating func update(point: CGPoint) {
            let cp = ParticleRotate3D.CENTER_POINT
            let last = points.last!
            
            let angleX = (point.y - cp.y) * 0.0005
            let angleY = (point.x - cp.x) * 0.0005
            
            let cosX = cos(angleX)
            let sinX = sin(angleX)
            let cosY = cos(angleY)
            let sinY = sin(angleY)
            
            let y = last.y * cosX - last.z * sinX
            let tz = last.z * cosX + last.y * sinX
            let x = last.x * cosY - tz * sinY
            let z = tz * cosY + x * sinY
            
            points.append(Point3D(x: x, y: y, z: z))
            
            if points.count > ParticleRotate3D.OBJECT_POINT_CAP {
                points.removeFirst()
            }
        }
    }
}
