import SwiftUI

struct BoidsDesign: View {
    private static let OBJECT_NUM = 100
    private static let OBJECT_VELOCITY: CGFloat = 3
    private static let OBJECT_RADIUS: CGFloat = 15
    private static let OBJECT_BORDER_COLOR = Color.black.opacity(0.8)
    private static let OBJECT_BORDER_WIDTH: CGFloat = 0.5
    private static let FRAME_CAP = 100
    private static let FRAME_RATE: CGFloat = 0.05
    
    @ObservedObject var recorder = Recorder(work: Work.boidsDesign)
    
    @State private var objects: [Object] = []
    @State private var canvasRect: CGRect = .zero
    @State private var archive: UIImage? = nil
    @State private var timer: Timer? = nil
    @State private var frameCount: Int = 0
    
    private var layer1: some View {
        ForEach(objects) { object in
            Path { path in
                drawEachDot(&path, object)
            }
            .fillAndStroke(
                object.color,
                strokeContent: BoidsDesign.OBJECT_BORDER_COLOR,
                strokeStyle: StrokeStyle(lineWidth: BoidsDesign.OBJECT_BORDER_WIDTH)
            )
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
            .background(Color.white)
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
                        for _ in 0 ..< BoidsDesign.OBJECT_NUM {
                            objects.append(Object())
                        }
                    }) {
                        Image(systemName: "arrow.counterclockwise")
                    }
                }
            )
            .onAppear {
                for _ in 0 ..< BoidsDesign.OBJECT_NUM {
                    objects.append(Object())
                }
                
                timer = Timer.scheduledTimer(withTimeInterval: BoidsDesign.FRAME_RATE, repeats: true) { _ in
                    guard frameCount <= BoidsDesign.FRAME_CAP else {
                        return
                    }
                    
                    for i in 0 ..< objects.count {
                        objects[i].update(objects: objects)
                    }
                    
                    frameCount += 1
                    
                    if frameCount > BoidsDesign.FRAME_CAP {
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
    
    private func drawEachDot(_ path: inout Path, _ object: Object) {
        object.points.forEach { point in
            path.addEllipse(in: CGRect(
                x: point.x + BoidsDesign.OBJECT_RADIUS / 2,
                y: point.y + BoidsDesign.OBJECT_RADIUS / 2,
                width: BoidsDesign.OBJECT_RADIUS,
                height: BoidsDesign.OBJECT_RADIUS
            ))
        }
    }
    
    private struct Object: Identifiable {
        let id = UUID()
        let color: Color
        
        var vx: CGFloat
        var vy: CGFloat
        var points: [CGPoint]
    
        init() {
            self.color = Color(hue: Double.random(in: 0 ... 1), saturation: 1.0, brightness: 0.8, opacity: 0.8)
            let x = CGFloat.random(in: 0 ... UIScreen.main.bounds.width)
            let y = CGFloat.random(in: 0 ... UIScreen.main.bounds.height - 80)
            
            let dire = CGFloat.random(in: 0 ... 1) * 2.0 * CGFloat.pi
            self.vx = CGFloat(cos(dire) * BoidsDesign.OBJECT_VELOCITY)
            self.vy = CGFloat(sin(dire) * BoidsDesign.OBJECT_VELOCITY)
            
            self.points = [CGPoint(x: x, y: y)]
        }
        
        mutating func update(objects: [Object]) {
            let last = points.last!
            var nextX = last.x + vx
            var nextY = last.y + vy
            
            if nextX < -10 {
                nextX = UIScreen.main.bounds.width
            }
            
            if nextX > UIScreen.main.bounds.width {
                nextX = -10
            }
            
            if nextY < -10 {
                nextY = UIScreen.main.bounds.height - 80 - 10
            }
            
            if nextY > UIScreen.main.bounds.height - 80 - 10 {
                nextY = -10
            }
            
            points.append(CGPoint(x: nextX, y: nextY))
            
            for i in 0 ..< objects.count {
                if objects[i].id == id {
                    continue
                }
                
                let other = objects[i]
                
                let diffX1 = nextX - other.points.last!.x
                let diffY1 = nextY - other.points.last!.y
                let dist = sqrt(pow(diffX1, 2) + pow(diffY1, 2))
                
                let diffX2 = other.points.last!.x - nextX
                let diffY2 = other.points.last!.y - nextY
                let dire = atan2(diffY2, diffX2)
                
                if dist > 200, dist < 300 {
                    vx += cos(dire) * 0.2
                    vy += sin(dire) * 0.2
                }
                
                if dist > 100, dist < 200 {
                    vx += other.vx * 0.1
                    vy += other.vy * 0.1
                }
                
                if dist < 100 {
                    vx += cos(dire + CGFloat.pi) * 0.4
                    vy += sin(dire + CGFloat.pi) * 0.4
                }
            }
            
            let dd = sqrt(pow(vx, 2) + pow(vy, 2))
            vx = vx / dd * BoidsDesign.OBJECT_VELOCITY
            vy = vy / dd * BoidsDesign.OBJECT_VELOCITY
        }
        
        mutating func clear() {
            points = [points.last!]
        }
    }
}
