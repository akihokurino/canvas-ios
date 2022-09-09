import ComposableArchitecture
import SwiftUI

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
            List {
                VStack {
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
                }
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets())
                .buttonStyle(PlainButtonStyle())
            }
            .listStyle(PlainListStyle())
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
            .pullToRefresh(isShowing: viewStore.binding(
                get: \.shouldPullToRefresh,
                send: ContractDetailVM.Action.shouldPullToRefresh
            )) {
                viewStore.send(.startRefresh)
            }
            .navigationBarTitle("", displayMode: .inline)
            .onAppear {
                viewStore.send(.startInitialize)
            }
            .sheet(isPresented: viewStore.binding(
                get: \.isPresentedSellNftView,
                send: ContractDetailVM.Action.isPresentedSellNftView
            )) {
                SellNftView(schema: viewStore.state.contract.schema, token: viewStore.state.selectTokenSummary!, isOwn: true, sell: { ether in
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
