import SwiftUI

struct MapGenerator: View {
    private static let OBJECT_CAP = 500
    private static let OBJECT_WIDTH: CGFloat = 1.0
    private static let FRAME_RATE: CGFloat = 0.05
    private static let CANVAS_SIZE = CGSize(width: 300, height: 300)
    
    @ObservedObject var recorder = Recorder(work: Work.mapGenerator)
        
    @State private var objects: [Object] = []
    @State private var timer: Timer? = nil
        
    var body: some View {
        GeometryReader { _ in
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    ZStack {
                        ForEach(objects) { object in
                            Path { path in
                                path.addLines(object.points)
                            }
                            .stroke(object.color, lineWidth: MapGenerator.OBJECT_WIDTH)
                            .frame(width: MapGenerator.CANVAS_SIZE.width, height: MapGenerator.CANVAS_SIZE.height)
                            .clipped()
                        }
                    }
                    .background(Color.black)
                    Spacer()
                }
                Spacer()
            }
            .frame(
                minWidth: 0,
                maxWidth: .infinity,
                minHeight: 0,
                maxHeight: .infinity,
                alignment: .topLeading
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
                        reset()
                    }) {
                        Image(systemName: "arrow.counterclockwise")
                    }
                }
            )
            .onAppear {
                let hue = Double.random(in: 1 ... 360) / 360.0
                let r = CGFloat.random(in: 0 ..< 1) * 360 * CGFloat.pi / 180
                objects.append(Object(point: CGPoint(x: MapGenerator.CANVAS_SIZE.width / 2, y: MapGenerator.CANVAS_SIZE.height / 2), r: r, hue: hue))
                    
                timer = Timer.scheduledTimer(withTimeInterval: MapGenerator.FRAME_RATE, repeats: true) { _ in
                    var branches: [Object] = []
                    for i in 0 ..< objects.count {
                        objects[i].update()
                        if let object = objects[i].branch(objects: objects) {
                            branches.append(object)
                        }
                    }
                    objects.append(contentsOf: branches)
                    
                    if objects.filter({ !$0.isDead }).count == 0 {
                        reset()
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
    
    private func reset() {
        objects.removeAll()
        let hue = Double.random(in: 1 ... 360) / 360.0
        let r = CGFloat.random(in: 0 ..< 1) * 360 * CGFloat.pi / 180
        objects.append(Object(point: CGPoint(x: MapGenerator.CANVAS_SIZE.width / 2, y: MapGenerator.CANVAS_SIZE.height / 2), r: r, hue: hue))
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
            self.angle = r + pow(CGFloat.random(in: 0 ..< 1), 30)
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
            
            if nextX <= 0 || nextX >= MapGenerator.CANVAS_SIZE.width || nextY <= 0 || nextY >= MapGenerator.CANVAS_SIZE.height {
                isDead = true
            }
            
            life -= 2
        }
        
        func branch(objects: [Object]) -> Object? {
            if !isDead && CGFloat.random(in: 0 ..< 1) > 0.9 && objects.count <= MapGenerator.OBJECT_CAP {
                return Object(point: endPoint, r: (CGFloat.random(in: 0 ... 1) > 0.5 ? 90 : -90) * CGFloat.pi / 180 + angle, hue: hue)
            }
            
            return nil
        }
    }
}
