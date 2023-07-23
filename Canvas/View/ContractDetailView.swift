import ComposableArchitecture
import SwiftUI
import SwiftUIPager

struct ContractDetailView: View {
    let store: Store<ContractDetailVM.State, ContractDetailVM.Action>

    private let thumbnailSize = UIScreen.main.bounds.size.width / 3
    private let gridItemLayout = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]

    var body: some View {
        WithViewStore(store) { viewStore in
            ScrollView {
                LazyVGrid(columns: gridItemLayout, alignment: HorizontalAlignment.leading, spacing: 3) {
                    ForEach(viewStore.state.tokens) { data in
                        Button(action: {
                            viewStore.send(.presentSellNftView(data))
                        }) {
                            RemoteImageView(url: data.imageUrl)
                                .scaledToFit()
                                .frame(width: thumbnailSize)
                        }
                    }
                }

                if viewStore.state.initialized {
                    if viewStore.state.hasNext {
                        HStack {
                            Spacer()
                            ProgressView()
                            Spacer()
                        }
                        .frame(height: 60)
                        .onTapGesture {
                            // TODO: onAppearでInfinityScroll実現できない
                            // ロード時に全てのCellがonAppearしてしまう
                            viewStore.send(.startNext)
                        }
                    } else {
                        Spacer().frame(height: 60)
                    }
                }
            }
            .overlay(
                Group {
                    if viewStore.state.shouldShowHUD {
                        HUD(isLoading: viewStore.binding(
                            get: \.shouldShowHUD,
                            send: ContractDetailVM.Action.shouldShowHUD
                        ))
                    }
                }, alignment: .center
            )
            .refreshable {
                await viewStore.send(.startRefresh, while: \.shouldPullToRefresh)
            }
            .navigationBarTitle(viewStore.state.contract.name, displayMode: .inline)
            .onAppear {
                viewStore.send(.startInitialize)
            }
            .sheet(isPresented: viewStore.binding(
                get: \.isPresentedSellNftView,
                send: ContractDetailVM.Action.isPresentedSellNftView
            )) {
                SellNftView(token: viewStore.state.selectToken!, sell: { ether in
                    viewStore.send(.isPresentedSellNftView(false))
                    viewStore.send(.sell(SellInput(ether: ether)))
                }, transfer: { address in
                    viewStore.send(.isPresentedSellNftView(false))
                    viewStore.send(.transfer(TransferInput(toAddress: address)))
                })
            }
            .alert(
                viewStore.error?.alert.title ?? "",
                isPresented: viewStore.binding(
                    get: { $0.isPresentedErrorAlert },
                    send: ContractDetailVM.Action.isPresentedErrorAlert
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
