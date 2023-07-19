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
                            Text("サンプル")
                        }
                    }.tag(1)

                    NavigationView {
                        IfLetStore(
                            store.scope(
                                state: { $0.archivePageView },
                                action: RootVM.Action.archivePageView
                            ),
                            then: ArchivePageView.init(store:)
                        )
                    }
                    .tabItem {
                        VStack {
                            Image(systemName: "archivebox")
                                .resizable()
                                .frame(width: 50, height: 50, alignment: .center)
                            Text("アーカイブ")
                        }
                    }.tag(2)

                    NavigationView {
                        IfLetStore(
                            store.scope(
                                state: { $0.contractListView },
                                action: RootVM.Action.contractListView
                            ),
                            then: ContractListView.init(store:)
                        )
                    }
                    .tabItem {
                        VStack {
                            Image(systemName: "square.fill.on.square.fill")
                                .resizable()
                                .frame(width: 50, height: 50, alignment: .center)
                            Text("NFT")
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
                            Text("ウォレット")
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
            .alert(isPresented: viewStore.binding(
                get: \.isPresentedAlert,
                send: RootVM.Action.presentAlert
            )) {
                Alert(title: Text(viewStore.alertText))
            }
            .alert(
                viewStore.error?.alert.title ?? "",
                isPresented: viewStore.binding(
                    get: { $0.isPresentedErrorAlert },
                    send: RootVM.Action.isPresentedErrorAlert
                ),
                presenting: viewStore.error?.alert
            ) { _ in
                Button("OK") {
                    viewStore.send(.isPresentedErrorAlert(false))
                }
            } message: { entity in
                Text(entity.message)
            }
        }
    }
}
