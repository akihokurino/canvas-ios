import SwiftUI

struct Splash: View {
    private static let OBJECT_CAP = 400
    private static let OBJECT_NUM_IN_FRAME = 10
    private static let OBJECT_POINT_CAP = 3
    private static let FRAME_RATE: CGFloat = 0.05
    
    @ObservedObject var recorder = Recorder(work: Work.splash)
    
    @State private var objects: [Object] = []
    @State private var timer: Timer? = nil
    
    var body: some View {
        GeometryReader { _ in
            ZStack {
                ForEach(objects) { object in
                    if object.points.count == Splash.OBJECT_POINT_CAP {
                        Path { path in
                            path.addArc(center: object.points[0], radius: object.radius, startAngle: .degrees(0), endAngle: .degrees(360), clockwise: false)
                        }
                        .fill(object.color.opacity(0.2))
                        .frame(width: canvasWidth(), height: canvasHeight())
                        .clipped()
                    }
                }
                ForEach(objects) { object in
                    if object.points.count == Splash.OBJECT_POINT_CAP {
                        Path { path in
                            path.addArc(center: object.points[1], radius: object.radius, startAngle: .degrees(0), endAngle: .degrees(360), clockwise: false)
                        }
                        .fill(object.color.opacity(0.4))
                        .frame(width: canvasWidth(), height: canvasHeight())
                        .clipped()
                    }
                }
                ForEach(objects) { object in
                    Path { path in
                        path.addArc(center: object.points.last!, radius: object.radius, startAngle: .degrees(0), endAngle: .degrees(360), clockwise: false)
                    }
                    .fill(object.color)
                    .frame(width: canvasWidth(), height: canvasHeight())
                    .clipped()
                }
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
                        objects.removeAll()
                    }) {
                        Image(systemName: "arrow.counterclockwise")
                    }
                }
            )
            .onAppear {
                timer = Timer.scheduledTimer(withTimeInterval: Splash.FRAME_RATE, repeats: true) { _ in
                    for _ in 0 ..< Splash.OBJECT_NUM_IN_FRAME {
                        if objects.count <= Splash.OBJECT_CAP {
                            objects.append(Object())
                        }
                    }
                    
                    for i in 0 ..< objects.count {
                        objects[i].update()
                    }
                    
                    objects.removeAll(where: { $0.isDead })
                }
            }
            .onDisappear {
                timer?.invalidate()
            }
            .drawingGroup()
        }
    }
    
    private struct Object: Identifiable {
        let id = UUID()
        let color: Color
        
        var vx: CGFloat = 0
        var vy: CGFloat = 0
        var points: [CGPoint]
        var radius: CGFloat
        var isDead = false
        
        init() {
            self.color = Color(hue: Double.random(in: 1 ... 360) / 360.0, saturation: 1.0, brightness: 1.0, opacity: 1.0)
            
            let r = CGFloat.random(in: 0 ..< 1) * CGFloat.pi * 2.0
            
            self.vx = (CGFloat.random(in: 0 ..< 1) * 5 + 5) * cos(r)
            self.vy = (CGFloat.random(in: 0 ..< 1) * 5 + 10) * sin(r)
            self.points = [centerPoint()]
            self.radius = CGFloat.random(in: 3.0 ... 5.0)
        }
    
        mutating func update() {
            guard !isDead else {
                return
            }
            
            let last = points.last!
            
            vy += 0.5
            let nextX = last.x + vx
            let nextY = last.y + vy
            points.append(CGPoint(x: nextX, y: nextY))
            
            radius -= 0.05
            
            if radius < 0 {
                radius = 0
                isDead = true
            }
            
            if nextX > UIScreen.main.bounds.width + 10 ||
                nextX < -10 ||
                nextY > UIScreen.main.bounds.height ||
                nextY < -10
            {
                isDead = true
            }
            
            if points.count > Splash.OBJECT_POINT_CAP {
                points.removeFirst()
            }
        }
    }
}
