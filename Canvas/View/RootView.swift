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
                            .resizable()
                            .frame(width: 50, height: 50, alignment: .center)
                    }
                }.tag(1)

                NavigationView {
                    ArchiveListView()
                }
                .tabItem {
                    VStack {
                        Image(systemName: "archivebox")
                            .resizable()
                            .frame(width: 50, height: 50, alignment: .center)
                    }
                }.tag(2)

                NavigationView {
                    ThumbnailListView()
                }
                .tabItem {
                    VStack {
                        Image(systemName: "square.grid.2x2")
                            .resizable()
                            .frame(width: 50, height: 50, alignment: .center)
                    }
                }.tag(3)
            }
        }
        .onAppear {
            authenticator.login()
        }
    }
}
