import SwiftUI

struct ColorRain: View {
    private static let OBJECTS_1_CAP = 400
    private static let OBJECTS_2_CAP = 100
    private static let OBJECT_NUM_IN_FRAME = 1
    private static let OBJECT_WIDTH: CGFloat = 3
    private static let GRAVITY: CGFloat = 0.3
    private static let FRAME_RATE: CGFloat = 0.01
    
    @ObservedObject var recorder = Recorder(work: Work.colorRain)
        
    @State private var objects1: [Object] = []
    @State private var objects2: [Object] = []
    @State private var canvasRect: CGRect = .zero
    @State private var archive: UIImage? = nil
    @State private var timer1: Timer? = nil
    @State private var timer2: Timer? = nil
    
    var body: some View {
        GeometryReader { _ in
            ZStack {
                if archive != nil {
                    Image(uiImage: archive!)
                        .frame(width: canvasWidth(), height: canvasHeight())
                }
                                    
                ForEach(objects1) { object in
                    Path { path in
                        path.addLines(object.points)
                    }
                    .stroke(object.color, lineWidth: ColorRain.OBJECT_WIDTH)
                    .frame(width: canvasWidth(), height: canvasHeight())
                    .clipped()
                }
                
                ForEach(objects2) { object in
                    Path { path in
                        path.addLines(object.points)
                    }
                    .stroke(object.color, lineWidth: ColorRain.OBJECT_WIDTH)
                    .frame(width: canvasWidth(), height: canvasHeight())
                    .clipped()
                }
            }
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
                    }) {
                        Image(systemName: "arrow.counterclockwise")
                    }
                }
            )
            .onAppear {
                timer1 = Timer.scheduledTimer(withTimeInterval: ColorRain.FRAME_RATE, repeats: true) { _ in
                    for _ in 0 ..< ColorRain.OBJECT_NUM_IN_FRAME {
                        if objects1.count > ColorRain.OBJECTS_1_CAP {
                            continue
                        }
                        objects1.append(Object())
                    }
                                    
                    for i in 0 ..< objects1.count {
                        objects1[i].update()
                    }
                                    
                    if objects1.count > ColorRain.OBJECTS_1_CAP {
                        archive = UIApplication.shared.windows[0].rootViewController!.view!.getImage(rect: self.canvasRect)
                        objects1.removeAll(where: { $0.isDead })
                    }
                }
                                
                timer2 = Timer.scheduledTimer(withTimeInterval: ColorRain.FRAME_RATE, repeats: true) { _ in
                    for _ in 0 ..< ColorRain.OBJECT_NUM_IN_FRAME {
                        if objects2.count > ColorRain.OBJECTS_2_CAP {
                            continue
                        }
                        objects2.append(Object())
                    }
                                                        
                    for i in 0 ..< objects2.count {
                        objects2[i].update()
                    }
                                                        
                    if objects2.count > ColorRain.OBJECTS_2_CAP {
                        archive = UIApplication.shared.windows[0].rootViewController!.view!.getImage(rect: self.canvasRect)
                        objects2.removeAll(where: { $0.isDead })
                    }
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
        let color: Color
       
        var vx: CGFloat
        var vy: CGFloat
        var points: [CGPoint]
        var isDead: Bool = false
        
        init() {
            self.color = Color(red: Double.random(in: 0 ... 1), green: Double.random(in: 0 ... 1), blue: Double.random(in: 0 ... 1))
            self.vx = CGFloat.random(in: 0 ..< 1) * 8 - 4
            self.vy = CGFloat.random(in: 0 ..< 1) * -10 - 11
            self.points = [CGPoint(x: canvasWidth() / 2, y: canvasHeight())]
        }
            
        mutating func update() {
            guard !isDead else {
                return
            }
            
            let last = points.last!
            
            vy += ColorRain.GRAVITY
        
            let nextX = last.x + vx
            let nextY = last.y + vy
            
            points.append(CGPoint(x: nextX, y: nextY))
            
            if nextX <= 0 || nextX >= canvasWidth() || nextY <= 0 || nextY >= canvasHeight() {
                isDead = true
            }
        }
    }
}
