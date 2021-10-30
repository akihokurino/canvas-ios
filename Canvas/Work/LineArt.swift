import SwiftUI

struct LineArt: View {
    private static let OBJECTS_1_CAP = 400
    private static let OBJECTS_2_CAP = 100
    private static let OBJECT_NUM_IN_FRAME = 3
    private static let OBJECT_VELOCITY: CGFloat = 80
    private static let OBJECT_MIN_VELOCITY: CGFloat = 20
    private static let FRAME_RATE: CGFloat = 0.01
    private static let FRICTION: CGFloat = 0.98
    
    @ObservedObject var recorder = Recorder(work: Work.lineArt)
    
    @State private var startPoint = centerPoint()
    @State private var hue: Double = 1
    @State private var objects1: [Object] = []
    @State private var objects2: [Object] = []
    @State private var canvasRect: CGRect = .zero
    @State private var archive: UIImage? = nil
    @State private var timer1: Timer? = nil
    @State private var timer2: Timer? = nil
    @State private var timer3: Timer? = nil
    
    private var layer1: some View {
        ForEach(objects1) { object in
            Path { path in
                path.addLines(object.points)
            }
            .stroke(object.color, lineWidth: object.width)
            .frame(width: canvasWidth(), height: canvasHeight())
            .clipped()
        }
    }
    
    private var layer2: some View {
        ForEach(objects2) { object in
            Path { path in
                path.addLines(object.points)
            }
            .stroke(object.color, lineWidth: object.width)
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
                layer2
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
                        objects1.removeAll()
                        objects2.removeAll()
                        startPoint = centerPoint()
                    }) {
                        Image(systemName: "arrow.counterclockwise")
                    }
                }
            )
            .onAppear {
                timer1 = Timer.scheduledTimer(withTimeInterval: LineArt.FRAME_RATE, repeats: true) { _ in
                    for _ in 0 ..< LineArt.OBJECT_NUM_IN_FRAME {
                        if objects1.count > LineArt.OBJECTS_1_CAP {
                            continue
                        }
                        objects1.append(Object(hue: hue / 360, start: startPoint))
                    }
                                    
                    for i in 0 ..< objects1.count {
                        objects1[i].update()
                    }
                                    
                    if objects1.count > LineArt.OBJECTS_1_CAP {
                        archive = screenshot(rect: self.canvasRect)
                        objects1.removeAll(where: { $0.isDead })
                    }
                }
                                
                timer2 = Timer.scheduledTimer(withTimeInterval: LineArt.FRAME_RATE, repeats: true) { _ in
                    for _ in 0 ..< LineArt.OBJECT_NUM_IN_FRAME {
                        if objects2.count > LineArt.OBJECTS_2_CAP {
                            continue
                        }
                        objects2.append(Object(hue: hue / 360, start: startPoint))
                    }
                                                        
                    for i in 0 ..< objects2.count {
                        objects2[i].update()
                    }
                                                        
                    if objects2.count > LineArt.OBJECTS_2_CAP {
                        archive = screenshot(rect: self.canvasRect)
                        objects2.removeAll(where: { $0.isDead })
                    }
                }
                                
                timer3 = Timer.scheduledTimer(withTimeInterval: LineArt.FRAME_RATE, repeats: true) { _ in
                    hue += 1
                    if hue == 360 {
                        hue = 1
                    }
                }
            }
            .onDisappear {
                timer1?.invalidate()
                timer2?.invalidate()
                timer3?.invalidate()
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
        let startPoint: CGPoint

        var endPoint: CGPoint
        var vx: CGFloat
        var vy: CGFloat
        var isDead: Bool = false
        
        var points: [CGPoint] {
            return [startPoint, endPoint]
        }
        
        init(hue: Double, start: CGPoint) {
            self.color = Color(hue: hue, saturation: 1.0, brightness: 0.8, opacity: 0.7)
            self.vx = LineArt.OBJECT_VELOCITY * (CGFloat.random(in: 0 ... 1) - 0.5)
            self.vy = LineArt.OBJECT_VELOCITY * (CGFloat.random(in: 0 ... 1) - 0.5)
            self.width = CGFloat.random(in: 1 ... 3)
            self.startPoint = start
            self.endPoint = start
        }
        
        mutating func update() {
            guard !isDead else {
                return
            }
            
            let nextX = endPoint.x + vx
            let nextY = endPoint.y + vy
            
            endPoint = CGPoint(x: nextX, y: nextY)
            
            if vx > LineArt.OBJECT_MIN_VELOCITY {
                vx *= LineArt.FRICTION
            }
            if vy > LineArt.OBJECT_MIN_VELOCITY {
                vy *= LineArt.FRICTION
            }

            if nextX <= 0 || nextX >= canvasWidth() || nextY <= 0 || nextY >= canvasHeight() {
                isDead = true
            }
        }
    }
}
