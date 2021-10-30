import SwiftUI

struct Lightning: View {
    private static let OBJECT_NUM = 500
    private static let OBJECT_POINT_CAP = 10
    private static let OBJECT_WIDTH: CGFloat = 1.0
    private static let FRAME_RATE: CGFloat = 0.05
    private static let MAX_POWER: CGFloat = 100
    private static let DELTA: CGFloat = 10
    private static let FRICTION: CGFloat = 0.95
    
    @ObservedObject var recorder = Recorder(work: Work.lightning)
    
    @State private var startPoint = centerPoint()
    @State private var objects: [Object] = []
    @State private var timer: Timer? = nil
    @State private var hue: Double = 180
    
    private var layer1: some View {
        ForEach(objects) { object in
            if object.points.count == Lightning.OBJECT_POINT_CAP {
                Path { path in
                    path.addLines(Array(object.points[0 ... 3]))
                }
                .stroke(object.color.opacity(0.2), lineWidth: Lightning.OBJECT_WIDTH)
                .frame(width: canvasWidth(), height: canvasHeight())
                .clipped()
            }
        }
    }
    
    private var layer2: some View {
        ForEach(objects) { object in
            if object.points.count == Lightning.OBJECT_POINT_CAP {
                Path { path in
                    path.addLines(Array(object.points[3 ... 6]))
                }
                .stroke(object.color.opacity(0.4), lineWidth: Lightning.OBJECT_WIDTH)
                .frame(width: canvasWidth(), height: canvasHeight())
                .clipped()
            }
        }
    }
    
    private var layer3: some View {
        ForEach(objects) { object in
            if object.points.count >= 4 {
                Path { path in
                    path.addLines(Array(object.points[object.points.count - 4 ..< object.points.count]))
                }
                .stroke(object.color, lineWidth: Lightning.OBJECT_WIDTH)
                .frame(width: canvasWidth(), height: canvasHeight())
                .clipped()
            }
        }
    }
    
    var body: some View {
        GeometryReader { _ in
            ZStack {
                layer1
                layer2
                layer3
            }
            .contentShape(Rectangle())
            .onTapGesture {
                for i in 0 ..< objects.count {
                    objects[i].expand(point: startPoint)
                }
            }
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
                        hue = 180
                        startPoint = centerPoint()
                        for _ in 0 ..< Lightning.OBJECT_NUM {
                            objects.append(Object(hue: hue))
                        }
                    }) {
                        Image(systemName: "arrow.counterclockwise")
                    }
                }
            )
            .onAppear {
                for _ in 0 ..< Lightning.OBJECT_NUM {
                    objects.append(Object(hue: hue))
                }
                
                timer = Timer.scheduledTimer(withTimeInterval: Lightning.FRAME_RATE, repeats: true) { _ in
                    hue += 1
                    if hue == 330 {
                        hue = 180
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
        let velocity: CGFloat
        
        var color: Color
        var vx: CGFloat = 0
        var vy: CGFloat = 0
        var points: [CGPoint]
        
        init(hue: Double) {
            self.velocity = CGFloat.random(in: 1 ..< 10)
            self.color = Color(hue: hue / 360.0, saturation: 1.0, brightness: 0.6, opacity: 1.0)
            
            let x = CGFloat.random(in: 0 ... UIScreen.main.bounds.width)
            let y = CGFloat.random(in: 0 ... UIScreen.main.bounds.height - 80)
            self.points = [CGPoint(x: x, y: y)]
        }
    
        mutating func update(point: CGPoint, hue: Double) {
            let last = points.last!
            let angle = atan2(last.y - point.y, last.x - point.x)
            
            vx -= velocity * cos(angle)
            vy -= velocity * sin(angle)
            
            points.append(CGPoint(x: last.x + vx, y: last.y + vy))
            vx *= Lightning.FRICTION
            vy *= Lightning.FRICTION
            color = Color(hue: hue / 360.0, saturation: 1.0, brightness: 0.6, opacity: 1.0)
            
            if points.count > Lightning.OBJECT_POINT_CAP {
                points.removeFirst()
            }
        }
        
        mutating func expand(point: CGPoint) {
            let randAngle = randfloat(min: -Lightning.DELTA, max: Lightning.DELTA)
            let randPower = CGFloat.random(in: 0 ..< 1) * Lightning.MAX_POWER
            
            vx = randPower * cos(randAngle)
            vy = randPower * sin(randAngle)
        }
    }
}
