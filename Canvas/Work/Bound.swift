import SwiftUI

struct Bound: View {
    private static let OBJECT_MAX_RADIUS: CGFloat = 120
    private static let OBJECT_MIN_RADIUS: CGFloat = 50
    private static let BOUNCE: CGFloat = -0.9
    private static let GRAVITY: CGFloat = 4
    private static let FRICTION: CGFloat = 1
    private static let FRAME_RATE: CGFloat = 0.01
    private static let OBJECT_POINT_CAP = 3
    
    @ObservedObject var recorder = Recorder(work: Work.bound)
    
    @State private var objects: [Object] = []
    @State private var timer: Timer? = nil
    @State private var canvasRect: CGRect = .zero
    @State private var archive: UIImage? = nil
    
    var body: some View {
        GeometryReader { _ in
            ZStack {
                if archive != nil {
                    Image(uiImage: archive!)
                        .frame(width: canvasWidth(), height: canvasHeight())
                }
                
                ForEach(objects) { object in
                    if object.points.count == Bound.OBJECT_POINT_CAP {
                        Path { path in
                            path.addArc(center: object.points[0], radius: object.radius, startAngle: .degrees(0), endAngle: .degrees(360), clockwise: false)
                        }
                        .fill(object.color.opacity(0.2))
                        .frame(width: canvasWidth(), height: canvasHeight())
                        .clipped()
                    }
                }
                ForEach(objects) { object in
                    if object.points.count == Bound.OBJECT_POINT_CAP {
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
            .frame(width: canvasWidth(), height: canvasHeight())
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 0, coordinateSpace: .local)
                    .onEnded { value in
                        objects.append(Object(point: value.location))
                    }
            )
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
                        objects.removeAll()
                    }) {
                        Image(systemName: "arrow.counterclockwise")
                    }
                }
            )
            .onAppear {
                timer = Timer.scheduledTimer(withTimeInterval: Bound.FRAME_RATE, repeats: true) { _ in
                    for i in 0 ..< objects.count {
                        objects[i].update()
                    }
                    
                    if objects.filter({ !$0.isDead }).count == 0 {
                        archive = UIApplication.shared.windows[0].rootViewController!.view!.getImage(rect: self.canvasRect)
                        objects.removeAll()
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
        let color: Color
        let width: CGFloat
        let height: CGFloat
        let radius: CGFloat
        
        var vx: CGFloat = 50
        var vy = CGFloat.random(in: 0 ..< 1) * 6 - 3
        var points: [CGPoint]
        var isDead: Bool = false
        
        init(point: CGPoint) {
            let diameter = floor(CGFloat.random(in: 0 ..< 1) * (Bound.OBJECT_MAX_RADIUS - Bound.OBJECT_MIN_RADIUS + 1)) + Bound.OBJECT_MIN_RADIUS
            
            self.width = diameter
            self.height = diameter
            self.radius = diameter * 0.5
            self.points = [point]
            self.color = Color(hue: Double.random(in: 1 ... 360) / 360.0, saturation: 1.0, brightness: 1.0, opacity: 1.0)
        }
        
        mutating func update() {
            guard !isDead else {
                return
            }
            
            let last = points.last!
            
            vx *= Bound.FRICTION
            vy *= Bound.FRICTION
            vy += Bound.GRAVITY
            
            var nextX = last.x + vx
            var nextY = last.y + vy
            
            if nextX + radius >= canvasWidth() {
                nextX = canvasWidth() - radius
                vx *= Bound.BOUNCE
            }
            
            if nextX - radius <= 0 {
                nextX = radius
                vx *= Bound.BOUNCE
            }
            
            if nextY + radius >= canvasHeight() - 20 {
                nextY = canvasHeight() - 20 - radius
                vy *= Bound.BOUNCE
                vx *= 0.7
            }
            
            if last.x == nextX, last.y == nextY {
                isDead = true
            }
            
            points.append(CGPoint(x: nextX, y: nextY))
            
            if points.count > Bound.OBJECT_POINT_CAP {
                points.removeFirst()
            }
        }
    }
}
