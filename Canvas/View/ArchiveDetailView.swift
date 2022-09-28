import AVKit
import ComposableArchitecture
import SwiftUI
import SwiftUIRefresh

struct ArchiveDetailView: View {
    let store: Store<ArchiveDetailVM.State, ArchiveDetailVM.Action>

    private let gridItemSize = UIScreen.main.bounds.size.width / 3
    private let gridItemLayout = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]

    var body: some View {
        WithViewStore(store) { viewStore in
            List {
                VStack {
                    HStack {
                        ActionButton(text: "ERC721", background: !(viewStore.state.erc721?.tokenId.isEmpty ?? true) ? .primary : .disable) {
                            viewStore.send(.presentSellNftView(.erc721))
                        }
                        Spacer()
                        ActionButton(text: "ERC1155", background: !(viewStore.state.erc1155?.tokenId.isEmpty ?? true) ? .primary : .disable) {
                            viewStore.send(.presentSellNftView(.erc1155))
                        }
                    }
                    .padding(.top, 20)
                    .padding(.horizontal, 20)

                    ZStack(alignment: .center) {
                        VideoView(url: URL(string: viewStore.state.archive.videoUrl)!)
                            .frame(maxWidth: .infinity)
                            .frame(height: 600)
                    }
                    .overlay(Spacer()
                        .frame(maxWidth: .infinity)
                        .frame(height: 70)
                        .background(Color(UIColor.systemBackground)), alignment: .top)
                    .overlay(Spacer()
                        .frame(maxWidth: .infinity)
                        .frame(height: 70)
                        .background(Color(UIColor.systemBackground)), alignment: .bottom)

                    LazyVGrid(columns: gridItemLayout, alignment: HorizontalAlignment.leading, spacing: 3) {
                        ForEach(viewStore.state.frames) { data in
                            Button(action: {
                                viewStore.send(.presentMintNftView(data))
                            }) {
                                RemoteImageView(url: data.resizedImageUrl)
                                    .scaledToFit()
                                    .frame(width: gridItemSize)
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
                            send: ArchiveDetailVM.Action.shouldShowHUD
                        ))
                    }
                }, alignment: .center
            )
            .pullToRefresh(isShowing: viewStore.binding(
                get: \.shouldPullToRefresh,
                send: ArchiveDetailVM.Action.shouldPullToRefresh
            )) {
                viewStore.send(.startRefresh)
            }
            .onAppear {
                viewStore.send(.startInitialize)
                viewStore.send(.fetchFrames)
            }
            .navigationBarTitle("", displayMode: .inline)
            .sheet(isPresented: viewStore.binding(
                get: \.isPresentedMintNftView,
                send: ArchiveDetailVM.Action.isPresentedMintNftView
            )) {
                MintNftView(data: viewStore.state.selectFrame!, hasERC721: viewStore.state.erc721 != nil, hasERC1155: viewStore.state.erc1155 != nil) { schema, amount in
                    viewStore.send(.isPresentedMintNftView(false))

                    switch schema {
                    case .erc721:
                        viewStore.send(.mintERC721(MintERC721Input()))
                    case .erc1155:
                        viewStore.send(.mintERC1155(MintERC1155Input(amount: amount!)))
                    default:
                        break
                    }
                }
            }
            .sheet(isPresented: viewStore.binding(
                get: \.isPresentedERC721SellNftView,
                send: ArchiveDetailVM.Action.isPresentedERC721SellNftView
            )) {
                SellNftView(schema: .erc721, token: viewStore.state.erc721!, isOwn: viewStore.state.ownERC721, sell: { ether in
                    viewStore.send(.isPresentedERC721SellNftView(false))
                    viewStore.send(.sellERC721(SellInput(ether: ether)))
                }, transfer: { address in
                    viewStore.send(.isPresentedERC721SellNftView(false))
                    viewStore.send(.transferERC721(TransferInput(toAddress: address)))
                })
            }
            .sheet(isPresented: viewStore.binding(
                get: \.isPresentedERC1155SellNftView,
                send: ArchiveDetailVM.Action.isPresentedERC1155SellNftView
            )) {
                SellNftView(schema: .erc1155, token: viewStore.state.erc1155!, isOwn: viewStore.state.ownERC1155, sell: { ether in
                    viewStore.send(.isPresentedERC1155SellNftView(false))
                    viewStore.send(.sellERC1155(SellInput(ether: ether)))
                }, transfer: { address in
                    viewStore.send(.isPresentedERC1155SellNftView(false))
                    viewStore.send(.transferERC1155(TransferInput(toAddress: address)))
                })
            }
        }
    }
}
