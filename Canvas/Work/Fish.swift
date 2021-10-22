import SwiftUI

struct Fish: View {
    private static let OBJECT_NUM = 100
    private static let FRAME_RATE: CGFloat = 0.01
    private static let OBJECT_POINT_CAP = 3
    
    @ObservedObject var recorder = Recorder(work: Work.fish)
    
    @State private var objects: [Object] = []
    @State private var foods: [Food] = []
    @State private var timer: Timer? = nil
    
    var body: some View {
        GeometryReader { _ in
            ZStack {
                ForEach(objects) { object in
                    if object.points.count == Fish.OBJECT_POINT_CAP {
                        Path { path in
                            path.addArc(center: object.points[0], radius: object.radius, startAngle: .degrees(0), endAngle: .degrees(360), clockwise: false)
                        }
                        .fill(object.color.opacity(0.2))
                        .frame(width: canvasWidth(), height: canvasHeight())
                        .clipped()
                    }
                }
                ForEach(objects) { object in
                    if object.points.count == Fish.OBJECT_POINT_CAP {
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
                
                ForEach(foods) { food in
                    Path { path in
                        path.addArc(center: food.point, radius: food.radius, startAngle: .degrees(0), endAngle: .degrees(360), clockwise: false)
                    }
                    .fill(food.color)
                    .frame(width: canvasWidth(), height: canvasHeight())
                    .clipped()
                }
            }
            .frame(width: canvasWidth(), height: canvasHeight())
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 0, coordinateSpace: .local)
                    .onEnded { value in
                        foods.append(Food(point: value.location))
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
                        foods.removeAll()
                        for _ in 0 ..< Fish.OBJECT_NUM {
                            objects.append(Object())
                        }
                    }) {
                        Image(systemName: "arrow.counterclockwise")
                    }
                }
            )
            .onAppear {
                for _ in 0 ..< Fish.OBJECT_NUM {
                    objects.append(Object())
                }
                
                timer = Timer.scheduledTimer(withTimeInterval: Fish.FRAME_RATE, repeats: true) { _ in
                    for i in 0 ..< objects.count {
                        objects[i].update(foods: foods) { foodIds in
                            for j in 0 ..< foods.count {
                                if foodIds.contains(where: { $0 == foods[j].id }) {
                                    foods[j].eat()
                                }
                            }
                        }
                    }
                    
                    foods.removeAll(where: { $0.isFinish })
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
        let color = Color(red: 1.0, green: 29.0 / 255.0, blue: 0.0)
        let radius: CGFloat = 3.0
        
        var vx: CGFloat
        var vy: CGFloat
        var points: [CGPoint]
        
        init() {
            vx = floor(CGFloat.random(in: 0 ..< 1) * 20) - 10
            vy = floor(CGFloat.random(in: 0 ..< 1) * 10) - 5
            
            points = [CGPoint(
                x: floor(CGFloat.random(in: 0 ..< 1) * canvasWidth()),
                y: floor(CGFloat.random(in: 0 ..< 1) * canvasHeight())
            )]
        }
        
        mutating func update(foods: [Food], _ eat: ([UUID]) -> Void) {
            let last = points.last!
            var dist: CGFloat = 10000
            var dx: CGFloat = 0
            var dy: CGFloat = 0
            
            for food in foods {
                let _dx: CGFloat = food.point.x - last.x
                let _dy: CGFloat = food.point.y - last.y
                let _dist: CGFloat = sqrt(pow(_dx, 2) + pow(_dy, 2))
                if dist > _dist {
                    dist = _dist
                    dx = _dx
                    dy = _dy
                }
            }
            
            let accX = dx / 450
            let accY = dy / 450
            
            vx += accX
            vy += accY
            
            let nextX = last.x + vx
            let nextY = last.y + vy
            
            let speed = sqrt(pow(vx, 2) + pow(vy, 2))
            if speed > 15 {
                vx *= 15 / speed
                vy *= 15 / speed
            }
            
            points.append(CGPoint(x: nextX, y: nextY))
            
            var foodIds: [UUID] = []
            for food in foods {
                let dx: CGFloat = food.point.x - nextX
                let dy: CGFloat = food.point.y - nextY
                let dist: CGFloat = sqrt(pow(dx, 2) + pow(dy, 2))
                let minDist = radius + food.radius
                
                if dist < minDist {
                    vx *= -1
                    vy *= -1
                    foodIds.append(food.id)
                }
            }
            
            eat(foodIds)
            
            if points.count > Fish.OBJECT_POINT_CAP {
                points.removeFirst()
            }
        }
    }
    
    private struct Food: Identifiable {
        let id = UUID()
        let color = Color(red: 51.0 / 255.0, green: 51.0 / 255.0, blue: 51.0 / 255.0)
        let point: CGPoint
        
        var radius: CGFloat = floor(CGFloat.random(in: 0 ..< 1) * 100 + 10)
        var isFinish = false
        
        mutating func eat() {
            radius -= 0.1
            
            if radius < 10 {
                isFinish = true
            }
        }
    }
}
