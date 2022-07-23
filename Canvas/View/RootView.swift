import ComposableArchitecture
import SwiftUI

struct RootView: View {
    let store: Store<RootVM.State, RootVM.Action>

    var body: some View {
        WithViewStore(store) { viewStore in
            Group {
                TabView {
                    NavigationView {
                        IfLetStore(
                            store.scope(
                                state: { $0.workListView },
                                action: RootVM.Action.workListView
                            ),
                            then: WorkListView.init(store:)
                        )
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
                        IfLetStore(
                            store.scope(
                                state: { $0.thumbnailListView },
                                action: RootVM.Action.thumbnailListView
                            ),
                            then: ThumbnailListView.init(store:)
                        )
                    }
                    .tabItem {
                        VStack {
                            Image(systemName: "square.grid.2x2")
                                .resizable()
                                .frame(width: 50, height: 50, alignment: .center)
                        }
                    }.tag(3)

                    NavigationView {
                        IfLetStore(
                            store.scope(
                                state: { $0.walletView },
                                action: RootVM.Action.walletView
                            ),
                            then: WalletView.init(store:)
                        )
                    }
                    .tabItem {
                        VStack {
                            Image(systemName: "wallet.pass")
                                .resizable()
                                .frame(width: 50, height: 50, alignment: .center)
                        }
                    }.tag(4)
                }
            }
            .overlay(
                Group {
                    if viewStore.state.shouldShowHUD {
                        HUD(isLoading: viewStore.binding(
                            get: \.shouldShowHUD,
                            send: RootVM.Action.shouldShowHUD
                        ))
                    }
                }, alignment: .center
            )
            .onAppear {
                viewStore.send(.startInitialize)
            }
        }
    }
}
