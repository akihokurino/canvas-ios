import SwiftUI

enum Work: String, CaseIterable, Identifiable {
    case lightning = "Lightning"
    case particleRotate3D = "ParticleRotate3D"
    case particleStream = "ParticleStream"
    case lorenz3D = "Lorenz3D"
    case circleDesign = "CircleDesign"
    case lineArt2 = "LineArt2"
    case streamDesign = "StreamDesign"
    case boidsDesign = "BoidsDesign"
    case spiderDesign = "SpiderDesign"
    case splashReturn = "SplashReturn"
    case bound = "Bound"
    case fish = "Fish"
    case colorRain = "ColorRain"
    case abstract = "Abstract"
    case mapGenerator = "MapGenerator"
    case splash = "Splash"
    case boidsMajic = "BoidsMajic"
    case lineArt = "LineArt"
    
    var id: String { rawValue }
    
    var canvas: some View {
        switch self {
        case .lightning:
            return AnyView(Lightning())
        case .particleRotate3D:
            return AnyView(ParticleRotate3D())
        case .particleStream:
            return AnyView(ParticleStream())
        case .lorenz3D:
            return AnyView(Lorenz3D())
        case .circleDesign:
            return AnyView(CircleDesign())
        case .lineArt2:
            return AnyView(LineArt2())
        case .streamDesign:
            return AnyView(StreamDesign())
        case .boidsDesign:
            return AnyView(BoidsDesign())
        case .spiderDesign:
            return AnyView(SpiderDesign())
        case .splashReturn:
            return AnyView(SplashReturn())
        case .bound:
            return AnyView(Bound())
        case .fish:
            return AnyView(Fish())
        case .colorRain:
            return AnyView(ColorRain())
        case .abstract:
            return AnyView(Abstract())
        case .mapGenerator:
            return AnyView(MapGenerator())
        case .splash:
            return AnyView(Splash())
        case .boidsMajic:
            return AnyView(BoidsMajic())
        case .lineArt:
            return AnyView(LineArt())
        }
    }
    
    var thumbnail: some View {
        return Thumbnail(name: self.rawValue)
    }
}

struct Thumbnail: View {
    let size = UIScreen.main.bounds.size.width / 2
    let name: String

    var body: some View {
        Image(name)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: size)
            .frame(height: size)
            .clipped()
    }
}
