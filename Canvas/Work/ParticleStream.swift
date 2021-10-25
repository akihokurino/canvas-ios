import SwiftUI

struct ParticleStream: View {
    private static let OBJECT_NUM = 700
    private static let OBJECT_VELOCITY: CGFloat = 500
    private static let OBJECT_POINT_CAP = 10
    private static let OBJECT_RADIUS: CGFloat = 2.0
    private static let FRAME_RATE: CGFloat = 0.05
    private static let FRICTION: CGFloat = 0.90
    
    @ObservedObject var recorder = Recorder(work: Work.particleStream)
    
    @State private var startPoint = centerPoint()
    @State private var objects: [Object] = []
    @State private var timer: Timer? = nil
    @State private var hue: Double = 1
    
    var body: some View {
        GeometryReader { _ in
            ZStack {
                ForEach(objects) { object in
                    if object.points.count == ParticleStream.OBJECT_POINT_CAP {
                        Path { path in
                            path.addArc(center: object.points[0], radius: ParticleStream.OBJECT_RADIUS, startAngle: .degrees(0), endAngle: .degrees(360), clockwise: false)
                        }
                        .fill(object.color.opacity(0.2))
                        .frame(width: canvasWidth(), height: canvasHeight())
                        .clipped()
                    }
                }
                ForEach(objects) { object in
                    if object.points.count == ParticleStream.OBJECT_POINT_CAP {
                        Path { path in
                            path.addArc(center: object.points[1], radius: ParticleStream.OBJECT_RADIUS, startAngle: .degrees(0), endAngle: .degrees(360), clockwise: false)
                        }
                        .fill(object.color.opacity(0.4))
                        .frame(width: canvasWidth(), height: canvasHeight())
                        .clipped()
                    }
                }
                ForEach(objects) { object in
                    Path { path in
                        path.addArc(center: object.points.last!, radius: ParticleStream.OBJECT_RADIUS, startAngle: .degrees(0), endAngle: .degrees(360), clockwise: false)
                    }
                    .fill(object.color)
                    .frame(width: canvasWidth(), height: canvasHeight())
                    .clipped()
                }
            }
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 0, coordinateSpace: .local)
                    .onChanged { value in
                        startPoint = value.location
                    }
                    .onEnded { value in
                        startPoint = value.location
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
                        hue = 1
                        startPoint = centerPoint()
                        for _ in 0 ..< ParticleStream.OBJECT_NUM {
                            objects.append(Object(hue: hue))
                        }
                    }) {
                        Image(systemName: "arrow.counterclockwise")
                    }
                }
            )
            .onAppear {
                for _ in 0 ..< ParticleStream.OBJECT_NUM {
                    objects.append(Object(hue: hue))
                }
                
                timer = Timer.scheduledTimer(withTimeInterval: ParticleStream.FRAME_RATE, repeats: true) { _ in
                    hue += 1
                    if hue == 360 {
                        hue = 1
                    }
                    
                    for i in 0 ..< objects.count {
                        objects[i].update(point: startPoint, hue: hue)
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
        var vx: CGFloat = 0
        var vy: CGFloat = 0
        var points: [CGPoint]
        
        init(hue: Double) {
            self.color = Color(hue: hue / 360.0, saturation: 1.0, brightness: 0.6, opacity: 1.0)
            
            let x = CGFloat.random(in: 0 ... UIScreen.main.bounds.width)
            let y = CGFloat.random(in: 0 ... UIScreen.main.bounds.height - 80)
            self.points = [CGPoint(x: x, y: y)]
        }
    
        mutating func update(point: CGPoint, hue: Double) {
            let last = points.last!
            let diffX = point.x - last.x
            let diffY = point.y - last.y
            let acc = ParticleStream.OBJECT_VELOCITY / (diffX * diffX + diffY * diffY)
            let accX = acc * diffX
            let accY = acc * diffY
            
            vx += accX
            vy += accY
            
            var nextX = last.x + vx
            var nextY = last.y + vy
            
            if nextX < 0 {
                nextX = UIScreen.main.bounds.width
            }

            if nextX > UIScreen.main.bounds.width {
                nextX = 0
            }

            if nextY < 0 {
                nextY = UIScreen.main.bounds.height - 80
            }

            if nextY > UIScreen.main.bounds.height - 80 {
                nextY = 0
            }
            
            points.append(CGPoint(x: nextX, y: nextY))
            vx *= ParticleStream.FRICTION
            vy *= ParticleStream.FRICTION
            color = Color(hue: hue / 360.0, saturation: 1.0, brightness: 0.6, opacity: 1.0)
            
            if points.count > ParticleStream.OBJECT_POINT_CAP {
                points.removeFirst()
            }
        }
    }
}
