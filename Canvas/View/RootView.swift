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
                    ArchiveListView()
                }
                .tabItem {
                    VStack {
                        Image(systemName: "video")
                        Text("アーカイブ")
                    }
                }.tag(2)

                NavigationView {
                    ThumbnailListView()
                }
                .tabItem {
                    VStack {
                        Image(systemName: "square.grid.2x2")
                        Text("サムネ")
                    }
                }.tag(3)
            }
        }
        .onAppear {
            authenticator.login()
        }
    }
}
