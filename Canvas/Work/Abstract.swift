import SwiftUI

struct Abstract: View {
    private static let START_POINT = centerPoint()
    private static let OBJECT_NUM = 100
    private static let OBJECT_LIFESPAN: CGFloat = 1000
    private static let OBJECT_WIDTH: CGFloat = 3
    private static let OBJECT_COLOR = Color.black.opacity(0.4)
    private static let FRAME_RATE: CGFloat = 0.05
    private static let DELTA: CGFloat = 5

    @ObservedObject var recorder = Recorder(work: Work.abstract)

    @State private var objects: [Object] = []
    @State private var timer: Timer? = nil

    private var layer1: some View {
        ForEach(objects) { object in
            Path { path in
                path.addLines(object.points)
            }
            .stroke(Abstract.OBJECT_COLOR, lineWidth: Abstract.OBJECT_WIDTH)
            .frame(width: canvasWidth(), height: canvasHeight())
            .clipped()
        }
    }

    var body: some View {
        GeometryReader { _ in
            ZStack {
                layer1
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
                        objects.removeAll()
                        for _ in 0 ..< Abstract.OBJECT_NUM {
                            objects.append(Object())
                        }
                    }) {
                        Image(systemName: "arrow.counterclockwise")
                    }
                }
            )
            .onAppear {
                for _ in 0 ..< Abstract.OBJECT_NUM {
                    objects.append(Object())
                }

                timer = Timer.scheduledTimer(withTimeInterval: Abstract.FRAME_RATE, repeats: true) { _ in
                    var next: [Object] = []
                    for i in 0 ..< objects.count {
                        objects[i].update()
                        if let object = objects[i].rebirth() {
                            next.append(object)
                        }
                    }
                    objects.append(contentsOf: next)
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

        var life: CGFloat = randfloat(min: 0, max: Abstract.OBJECT_LIFESPAN / 2)
        var points: [CGPoint] = [
            Abstract.START_POINT
        ]
        var isDead: Bool = false

        mutating func update() {
            guard life <= Abstract.OBJECT_LIFESPAN else {
                return
            }

            let vx = randfloat(min: -Abstract.DELTA, max: Abstract.DELTA)
            let vy = randfloat(min: -Abstract.DELTA, max: Abstract.DELTA)
            let last = points.last!
            points.append(CGPoint(x: last.x + vx, y: last.y + vy))

            life += 1
        }

        mutating func rebirth() -> Object? {
            guard life > Abstract.OBJECT_LIFESPAN else {
                return nil
            }

            guard !isDead else {
                return nil
            }

            isDead = true

            return Object()
        }
    }
}
