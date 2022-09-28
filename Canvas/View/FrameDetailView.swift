import SwiftUI

struct FrameDetailView: View {
    let url: String?

    @State private var scaleValue: CGFloat = 1.0
    @State private var lastValue: CGFloat = 1.0

    var body: some View {
        let magnificationGesture = MagnificationGesture()
            .onChanged { value in
                self.scaleValue = value
            }
            .onEnded { _ in
                self.lastValue *= self.scaleValue
                self.scaleValue = 1
            }
        
        RemoteImageView(url: url)
            .scaledToFit()
            .scaleEffect(lastValue * scaleValue)
            .frame(maxWidth: .infinity)
            .frame(maxHeight: .infinity)
            .clipped()
            .gesture(magnificationGesture)
    }
}
