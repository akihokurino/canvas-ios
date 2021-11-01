import SwiftUI

let RefreshControlKey = "RefreshControl"
let RefreshControlHeight: CGFloat = 60.0

struct RefreshControl: View {
    @Binding var isRefreshing: Bool
    var coordinateSpaceName: String
    var onRefresh: () -> Void
    private let pullDownHeight: CGFloat = 100

    var body: some View {
        GeometryReader { geometry in
            if geometry.frame(in: .named(coordinateSpaceName)).midY > pullDownHeight {
                Spacer().frame(width: 0, height: 0, alignment: .center)
                    .onAppear {
                        onRefresh()
                    }
            }

            if isRefreshing {
                HStack {
                    Spacer()
                    ProgressView()
                        .scaleEffect(x: 1.5, y: 1.5, anchor: .center)
                    Spacer()
                }
                .frame(height: RefreshControlHeight, alignment: .center)
            } else {
                HStack {}
                    .frame(height: RefreshControlHeight, alignment: .center)
            }
        }
        .padding(.top, isRefreshing ? 0.0 : -RefreshControlHeight)
        .frame(height: isRefreshing ? RefreshControlHeight : 0.0)
    }
}
