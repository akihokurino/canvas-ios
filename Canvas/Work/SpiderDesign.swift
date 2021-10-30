import SwiftUI

struct SpiderDesign: View {
    private static let OBJECT_NUM = 30
    private static let OBJECT_CAP = 1000
    private static let OBJECT_WIDTH: CGFloat = 1.0
    private static let FRAME_RATE: CGFloat = 0.05
    
    @ObservedObject var recorder = Recorder(work: Work.spiderDesign)
        
    @State private var objects: [Object] = []
    @State private var canvasRect: CGRect = .zero
    @State private var archive: UIImage? = nil
    @State private var timer: Timer? = nil
    
    private var layer1: some View {
        ForEach(objects) { object in
            Path { path in
                path.addLines(object.points)
            }
            .stroke(object.color, lineWidth: SpiderDesign.OBJECT_WIDTH)
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
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 0, coordinateSpace: .local)
                    .onEnded { value in
                        archive = screenshot(rect: self.canvasRect)
                        objects.removeAll()
                        let hue = Double.random(in: 1 ... 360) / 360.0
                        for _ in 0 ..< SpiderDesign.OBJECT_NUM {
                            let r = CGFloat.random(in: 0 ..< 1) * 360 * CGFloat.pi / 180
                            objects.append(Object(point: value.location, r: r, hue: hue))
                        }
                    }
            )
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
                        let hue = Double.random(in: 1 ... 360) / 360.0
                        for _ in 0 ..< SpiderDesign.OBJECT_NUM {
                            let r = CGFloat.random(in: 0 ..< 1) * 360 * CGFloat.pi / 180
                            objects.append(Object(point: centerPoint(), r: r, hue: hue))
                        }
                    }) {
                        Image(systemName: "arrow.counterclockwise")
                    }
                }
            )
            .onAppear {
                let hue = Double.random(in: 1 ... 360) / 360.0
                for _ in 0 ..< SpiderDesign.OBJECT_NUM {
                    let r = CGFloat.random(in: 0 ..< 1) * 360 * CGFloat.pi / 180
                    objects.append(Object(point: centerPoint(), r: r, hue: hue))
                }
                    
                timer = Timer.scheduledTimer(withTimeInterval: SpiderDesign.FRAME_RATE, repeats: true) { _ in
                    var branches: [Object] = []
                    for i in 0 ..< objects.count {
                        objects[i].update()
                        if let object = objects[i].branch(objects: objects) {
                            branches.append(object)
                        }
                    }
                    objects.append(contentsOf: branches)
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
        let hue: CGFloat
        let color: Color
        let angle: CGFloat
        let vx: CGFloat
        let vy: CGFloat
        let startPoint: CGPoint
        
        var endPoint: CGPoint
        var life = CGFloat.random(in: 0 ..< 1) * 100 + 100
        var isDead = false
        
        var points: [CGPoint] {
            return [startPoint, endPoint]
        }
        
        init(point: CGPoint, r: CGFloat, hue: CGFloat) {
            self.hue = hue
            self.color = Color(hue: hue, saturation: 1.0, brightness: 1.0, opacity: 1.0)
            self.angle = r + pow(CGFloat.random(in: 0 ..< 1) * 10, 180)
            self.vx = cos(angle)
            self.vy = sin(angle)
            let point = CGPoint(x: point.x + randfloat(5), y: point.y + randfloat(5))
            self.startPoint = point
            self.endPoint = point
        }
            
        mutating func update() {
            guard !isDead else {
                return
            }
            
            let nextX = endPoint.x + vx * 5
            let nextY = endPoint.y + vy * 5
            endPoint = CGPoint(x: nextX, y: nextY)
            
            if life <= 0 {
                isDead = true
            }
            
            if nextX <= 0 || nextX >= canvasWidth() || nextY <= 0 || nextY >= canvasHeight() {
                isDead = true
            }
            
            life -= 3
        }
        
        func branch(objects: [Object]) -> Object? {
            if !isDead && CGFloat.random(in: 0 ..< 1) > 0.85 && objects.count <= SpiderDesign.OBJECT_CAP {
                return Object(point: endPoint, r: (CGFloat.random(in: 0 ... 1) > 0.5 ? 90 : -90) * CGFloat.pi / 180 + angle, hue: hue)
            }
            
            return nil
        }
    }
}
