import ComposableArchitecture
import SwiftUI
import SwiftUIPager

struct ContractDetailView: View {
    let store: Store<ContractDetailVM.State, ContractDetailVM.Action>

    @State private var presentMenu = false

    private let thumbnailSize = UIScreen.main.bounds.size.width / 3
    private let gridItemLayout = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]

    var body: some View {
        WithViewStore(store) { viewStore in
            Picker("", selection: viewStore.binding(
                get: \.currentSelection,
                send: ContractDetailVM.Action.changePage
            )) {
                Text("通常").tag(0)
                Text("一括").tag(1)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(EdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 12))

            Pager(
                page: viewStore.currentPage,
                data: viewStore.pageIndexes,
                id: \.hashValue,
                content: { index in
                    if index == 0 {
                        IfLetStore(
                            store.scope(
                                state: { $0.tokenListView },
                                action: ContractDetailVM.Action.tokenListView
                            ),
                            then: TokenListView.init(store:)
                        )
                    } else {
                        IfLetStore(
                            store.scope(
                                state: { $0.multiTokenListView },
                                action: ContractDetailVM.Action.multiTokenListView
                            ),
                            then: MultiTokenListView.init(store:)
                        )
                    }
                }
            )
            .onPageChanged { index in
                viewStore.send(.changePage(index))
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
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                presentMenu = true
            }) {
                Image(systemName: "ellipsis")
            })
            .actionSheet(isPresented: $presentMenu) {
                ActionSheet(title: Text("メニュー"), buttons:
                    [
                        .default(Text("一括売り注文")) {
                            viewStore.send(.presentBulkSellNftView)
                        },
                        .cancel(),
                    ])
            }
            .sheet(isPresented: viewStore.binding(
                get: \.isPresentedBulkSellNftView,
                send: ContractDetailVM.Action.isPresentedBulkSellNftView
            )) {
                BulkSellNftView { ether in
                    viewStore.send(.isPresentedBulkSellNftView(false))
                    viewStore.send(.startSellAllTokens(SellAllTokensInput(ether: ether)))
                }
            }
            .sheet(isPresented: viewStore.binding(
                get: \.isPresentedSellNftView,
                send: ContractDetailVM.Action.isPresentedSellNftView
            )) {
                SellNftView(token: viewStore.state.selectToken!, sell: { ether in
                    switch viewStore.state.contract.schema {
                    case .erc721:
                        viewStore.send(.isPresentedSellNftView(false))
                        viewStore.send(.sellERC721(SellInput(ether: ether)))
                    case .erc1155:
                        viewStore.send(.isPresentedSellNftView(false))
                        viewStore.send(.sellERC1155(SellInput(ether: ether)))
                    default:
                        break
                    }
                }, transfer: { address in
                    switch viewStore.state.contract.schema {
                    case .erc721:
                        viewStore.send(.isPresentedSellNftView(false))
                        viewStore.send(.transferERC721(TransferInput(toAddress: address)))
                    case .erc1155:
                        viewStore.send(.isPresentedSellNftView(false))
                        viewStore.send(.transferERC1155(TransferInput(toAddress: address)))
                    default:
                        break
                    }
                })
            }
        }
    }
}
