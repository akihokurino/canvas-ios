import UIKit

func randfloat(min: CGFloat, max: CGFloat) -> CGFloat {
    let random = CGFloat.random(in: 0 ..< 1)
    return floor(random * (max - min + 1)) + min
}

func randfloat(_ num: CGFloat) -> CGFloat {
    let random = CGFloat.random(in: 0 ..< 1)
    return random * num - num * 0.5
}

func centerPoint() -> CGPoint {
    return CGPoint(x: canvasWidth() / 2, y: canvasHeight() / 2)
}

func canvasWidth() -> CGFloat {
    return UIScreen.main.bounds.width
}

func canvasHeight() -> CGFloat {
    return UIScreen.main.bounds.height - 80 - 100
}

func screenshot(rect: CGRect) -> UIImage {
    let scene = UIApplication.shared.connectedScenes.first as! UIWindowScene
    return scene.keyWindow!.rootViewController!.view!.getImage(rect: rect)
}
