import SwiftUI

struct StreamDesign: View {
    private static let OBJECT_NUM = 300
    private static let OBJECT_WIDTH: CGFloat = 3
    private static let OBJECT_RADIUS: CGFloat = 250
    private static let OBJECT_RADIUS_SCALE_MIN: CGFloat = 0.5
    private static let OBJECT_RADIUS_SCALE_MAX: CGFloat = 1.25
    private static let FRAME_CAP = 100
    private static let FRAME_RATE: CGFloat = 0.05
    
    @ObservedObject var recorder = Recorder(work: Work.streamDesign)
        
    @State private var startPoint = centerPoint()
    @State private var objects: [Object] = []
    @State private var canvasRect: CGRect = .zero
    @State private var archive: UIImage? = nil
    @State private var timer: Timer? = nil
    @State private var frameCount: Int = 0
    @State private var isDraging: Bool = false
        
    var body: some View {
        GeometryReader { _ in
            ZStack {
                if archive != nil {
                    Image(uiImage: archive!)
                        .frame(width: canvasWidth(), height: canvasHeight())
                }
                                    
                ForEach(objects) { object in
                    Path { path in
                        path.addLines(object.points)
                    }
                    .stroke(object.color, lineWidth: StreamDesign.OBJECT_WIDTH)
                    .frame(width: canvasWidth(), height: canvasHeight())
                    .clipped()
                }
            }
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 0, coordinateSpace: .local)
                    .onChanged { value in
                        startPoint = value.location
                        isDraging = true
                    }
                    .onEnded { value in
                        startPoint = value.location
                        isDraging = false
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
                        startPoint = centerPoint()
                        for _ in 0 ..< StreamDesign.OBJECT_NUM {
                            objects.append(Object(point: startPoint))
                        }
                    }) {
                        Image(systemName: "arrow.counterclockwise")
                    }
                }
            )
            .onAppear {
                for _ in 0 ..< StreamDesign.OBJECT_NUM {
                    objects.append(Object(point: startPoint))
                }
                    
                timer = Timer.scheduledTimer(withTimeInterval: StreamDesign.FRAME_RATE, repeats: true) { _ in
                    guard frameCount <= StreamDesign.FRAME_CAP else {
                        return
                    }
                        
                    for i in 0 ..< objects.count {
                        objects[i].update(index: i, point: startPoint, isDraging: isDraging)
                    }
                        
                    frameCount += 1
                        
                    if frameCount > StreamDesign.FRAME_CAP {
                        archive = UIApplication.shared.windows[0].rootViewController!.view!.getImage(rect: self.canvasRect)
                        for i in 0 ..< objects.count {
                            objects[i].clear()
                        }
                        frameCount = 0
                    }
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
        let velocity: CGFloat
        let orbit: CGFloat
            
        var vx: CGFloat
        var vy: CGFloat
        var shift: CGPoint
        var points: [CGPoint]
        var radiusScale: CGFloat
        
        init(point: CGPoint) {
            self.color = Color(red: Double.random(in: 0 ... 1), green: Double.random(in: 0 ... 1), blue: Double.random(in: 0 ... 1))
            self.velocity = CGFloat.random(in: 0 ..< 1) * 0.04 + 0.05
            self.orbit = StreamDesign.OBJECT_RADIUS * 0.5 + (StreamDesign.OBJECT_RADIUS * 0.5 * CGFloat.random(in: 0 ..< 1))
            self.vx = 0
            self.vy = 0
            self.shift = point
            self.points = []
            self.radiusScale = StreamDesign.OBJECT_RADIUS_SCALE_MIN
        }
            
        mutating func update(index: Int, point: CGPoint, isDraging: Bool) {
            vx += velocity
            vy += velocity
            
            if isDraging {
                radiusScale += (StreamDesign.OBJECT_RADIUS_SCALE_MAX - radiusScale) * 0.02
            } else {
                radiusScale -= (radiusScale - StreamDesign.OBJECT_RADIUS_SCALE_MIN) * 0.02
            }
            radiusScale = min(radiusScale, StreamDesign.OBJECT_RADIUS_SCALE_MAX)
            
            shift = CGPoint(x: shift.x + ((point.x - shift.x) * velocity), y: shift.y + ((point.y - shift.y) * velocity))
            
            var nextX = shift.x + cos(CGFloat(index) + vx) * (orbit * radiusScale)
            var nextY = shift.y + sin(CGFloat(index) + vy) * (orbit * radiusScale)
            
            nextX = max(min(nextX, canvasWidth()), 0)
            nextY = max(min(nextY, canvasHeight()), 0)
    
            points.append(CGPoint(x: nextX, y: nextY))
        }
            
        mutating func clear() {
            points = [points.last!]
        }
    }
}
