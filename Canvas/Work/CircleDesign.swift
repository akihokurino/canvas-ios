import SwiftUI

struct CircleDesign: View {
    private static let START_POINT = centerPoint()
    private static let OBJECT_COLOR = Color(red: 34.0 / 255.0, green: 38.0 / 255.0, blue: 12.0 / 255.0)
    private static let OBJECT_WIDTH: CGFloat = 1.0
    private static let OBJECT_RADIUS: CGFloat = 100
    private static let OBJECT_CAP = 500
    private static let FRAME_RATE_1: CGFloat = 0.01
    private static let FRAME_RATE_2: CGFloat = 0.05
    private static let FRICTION: CGFloat = 0.8
    
    @ObservedObject var recorder = Recorder(work: Work.circleDesign)
    
    @State private var startPoint = centerPoint()
    @State private var objects: [Object] = []
    @State private var timer1: Timer? = nil
    @State private var timer2: Timer? = nil
    
    var body: some View {
        GeometryReader { _ in
            ZStack {
                ForEach(objects) { object in
                    Path { path in
                        path.addArc(center: object.point, radius: CircleDesign.OBJECT_RADIUS, startAngle: .degrees(0), endAngle: .degrees(360), clockwise: false)
                    }
                    .stroke(CircleDesign.OBJECT_COLOR.opacity(object.alpha), lineWidth: CircleDesign.OBJECT_WIDTH)
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
                        startPoint = centerPoint()
                        objects.append(Object(point: centerPoint(), vx: 0, vy: 0))
                    }) {
                        Image(systemName: "arrow.counterclockwise")
                    }
                }
            )
            .onAppear {
                objects.append(Object(point: centerPoint(), vx: 0, vy: 0))
        
                timer1 = Timer.scheduledTimer(withTimeInterval: CircleDesign.FRAME_RATE_1, repeats: true) { _ in
                    if let next = objects.last?.next(startPoint), objects.count <= CircleDesign.OBJECT_CAP {
                        objects.append(next)
                    }
                }
                
                timer2 = Timer.scheduledTimer(withTimeInterval: CircleDesign.FRAME_RATE_2, repeats: true) { _ in
                    for i in 0 ..< objects.count {
                        objects[i].update()
                    }
                    objects.removeAll(where: { $0.isDead })
                }
            }
            .onDisappear {
                timer1?.invalidate()
                timer2?.invalidate()
            }
            .drawingGroup()
        }
    }
    
    private struct Object: Identifiable {
        let id = UUID()
        let vx: CGFloat
        let vy: CGFloat
        let point: CGPoint
        
        var alpha: CGFloat = 1.0
        var isDead: Bool = false
        
        init(point: CGPoint, vx: CGFloat, vy: CGFloat) {
            self.point = point
            self.vx = vx
            self.vy = vy
        }
        
        mutating func update() {
            guard !isDead else {
                return
            }
            
            alpha += (0 - alpha) * 0.05
            if abs(0 - alpha) < 0.01 {
                alpha = 0.0
                isDead = true
            }
        }
        
        func next(_ next: CGPoint) -> Object {
            let ax = next.x - point.x
            let ay = next.y - point.y
            
            var _vx = vx + ax / 10.0
            var _vy = vy + ay / 10.0
            
            _vx *= CircleDesign.FRICTION
            _vy *= CircleDesign.FRICTION
            
            return Object(point: CGPoint(x: point.x + _vx, y: point.y + _vy), vx: _vx, vy: _vy)
        }
    }
}
