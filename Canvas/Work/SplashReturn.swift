import SwiftUI

struct SplashReturn: View {
    private static let OBJECT_CAP = 500
    private static let OBJECT_NUM_IN_FRAME = 20
    private static let OBJECT_POINT_CAP = 3
    private static let CIRCLE_RADIUS: CGFloat = 100
    private static let HOLE_RADIUS: CGFloat = 30
    private static let FRAME_RATE: CGFloat = 0.05
    
    @ObservedObject var recorder = Recorder(work: Work.splashReturn)
    
    @State private var objects: [Object] = []
    @State private var timer: Timer? = nil
    @State private var isTapped: Bool = false
    
    var body: some View {
        GeometryReader { _ in
            ZStack {
                ForEach(objects) { object in
                    if object.points.count == SplashReturn.OBJECT_POINT_CAP {
                        Path { path in
                            path.addArc(center: object.points[0], radius: object.radius, startAngle: .degrees(0), endAngle: .degrees(360), clockwise: false)
                        }
                        .fill(object.color.opacity(0.2))
                        .frame(width: canvasWidth(), height: canvasHeight())
                        .clipped()
                    }
                }
                ForEach(objects) { object in
                    if object.points.count == SplashReturn.OBJECT_POINT_CAP {
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
            .contentShape(Rectangle())
            .onTapGesture {
                isTapped = !isTapped
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
                        isTapped = false
                        objects.removeAll()
                    }) {
                        Image(systemName: "arrow.counterclockwise")
                    }
                }
            )
            .onAppear {
                timer = Timer.scheduledTimer(withTimeInterval: SplashReturn.FRAME_RATE, repeats: true) { _ in
                    for _ in 0 ..< SplashReturn.OBJECT_NUM_IN_FRAME {
                        if objects.count <= SplashReturn.OBJECT_CAP {
                            objects.append(Object(isTapped: isTapped))
                        }
                    }
                    
                    for i in 0 ..< objects.count {
                        objects[i].update(isTapped: isTapped)
                    }
                    
                    objects.removeAll(where: { $0.isDead })
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
        let angle: CGFloat
        let color: Color
        let accX: CGFloat
        let accY: CGFloat
        let isReversed: Bool
        
        var vx: CGFloat = 0
        var vy: CGFloat = 0
        var points: [CGPoint]
        var radius: CGFloat
        var isDead = false
        
        init(isTapped: Bool) {
            self.angle = CGFloat.random(in: 0 ..< 1) * 2 * CGFloat.pi
            
            let center = centerPoint()
            
            self.color = Color(red: Double.random(in: 0 ... 1), green: Double.random(in: 0 ... 1), blue: Double.random(in: 0 ... 1))
            
            let v = CGFloat.random(in: 5 ..< 20)
            self.vx = v * cos(angle)
            self.vy = v * sin(angle)
            
            if isTapped {
                self.points = [CGPoint(
                    x: center.x + 30 * cos(angle),
                    y: center.y + 30 * sin(angle)
                )]
                self.radius = CGFloat.random(in: 3.0 ... 6.0)
                self.accX = -cos(angle)
                self.accY = -sin(angle)
            } else {
                self.points = [CGPoint(
                    x: center.x + SplashReturn.CIRCLE_RADIUS * cos(angle),
                    y: center.y + SplashReturn.CIRCLE_RADIUS * sin(angle)
                )]
                self.radius = CGFloat.random(in: 1.0 ... 6.0)
                self.accX = 10
                self.accY = 10
            }
            
            self.isReversed = isTapped
        }
    
        mutating func update(isTapped: Bool) {
            guard !isDead else {
                return
            }
            
            let last = points.last!
            let center = centerPoint()
            
            let nextX = last.x + vx
            let nextY = last.y + vy
            points.append(CGPoint(x: nextX, y: nextY))
            
            if isReversed && isTapped {
                vx += accX
                vy += accY
            }
            
            if nextX > UIScreen.main.bounds.width + 10 ||
                nextX < -10 ||
                nextY > UIScreen.main.bounds.height ||
                nextY < -10
            {
                isDead = true
            }
            
            if isTapped {
                let distance = ((center.x - nextX) * (center.x - nextX)) + ((center.y - nextY) * (center.y - nextY) * 20)
                if distance < SplashReturn.HOLE_RADIUS * SplashReturn.HOLE_RADIUS {
                    isDead = true
                }
            }
            
            if points.count > SplashReturn.OBJECT_POINT_CAP {
                points.removeFirst()
            }
        }
    }
}
