import ActivityIndicatorView
import SwiftUI

struct HUD: View {
    @Binding var isLoading: Bool

    var body: some View {
        ZStack {
            Group {
                ActivityIndicatorView(isVisible: $isLoading, type: .gradient([.white, .blue]))
                    .frame(width: 50, height: 50, alignment: .center)
            }
            .frame(width: 100, height: 100, alignment: .center)
            .background(Color.gray.opacity(0.8))
            .cornerRadius(5.0)
        }
        .frame(minWidth: 0,
               maxWidth: .infinity,
               minHeight: 0,
               maxHeight: .infinity,
               alignment: .center)
        .edgesIgnoringSafeArea(.all)
    }
}
