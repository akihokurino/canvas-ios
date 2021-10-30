import SwiftUI

struct RootView: View {
    @ObservedObject var authenticator = Authenticator()

    var body: some View {
        Group {
            TabView {
                NavigationView {
                    WorkListView()
                }
                .tabItem {
                    VStack {
                        Image(systemName: "scribble.variable")
                        Text("作品")
                    }
                }.tag(1)

                NavigationView {
                    ThumbnailListView()
                }
                .tabItem {
                    VStack {
                        Image(systemName: "square.grid.2x2")
                        Text("サムネ")
                    }
                }.tag(2)
            }
        }
        .onAppear {
            authenticator.login()
        }
    }
}
