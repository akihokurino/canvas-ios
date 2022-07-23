import AVKit
import ComposableArchitecture
import SwiftUI
import SwiftUIRefresh

struct ArchiveDetailView: View {
    let store: Store<ArchiveDetailVM.State, ArchiveDetailVM.Action>

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
                    HStack {
                        ActionButton(text: "ERC721", background: !(viewStore.state.erc721?.tokenId.isEmpty ?? true) ? .primary : .disable) {
                            viewStore.send(.presentNftView(.ERC721))
                        }
                        Spacer()
                        ActionButton(text: "ERC1155", background: !(viewStore.state.erc1155?.tokenId.isEmpty ?? true) ? .primary : .disable) {
                            viewStore.send(.presentNftView(.ERC1155))
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
                        ForEach(viewStore.state.archive.thumbnails) { data in
                            Button(action: {
                                viewStore.send(.presentMintNftView(data))
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
            }
            .navigationBarTitle("", displayMode: .inline)
            .sheet(isPresented: viewStore.binding(
                get: \.isPresentedMintNftView,
                send: ArchiveDetailVM.Action.isPresentedMintNftView
            )) {
                MintNftView(data: viewStore.state.selectThumbnail!, hasERC721: viewStore.state.erc721 != nil, hasERC1155: viewStore.state.erc1155 != nil) { nftType, amount in
                    viewStore.send(.isPresentedMintNftView(false))

                    switch nftType {
                    case .ERC721:
                        viewStore.send(.mintERC721(MintERC721Input()))
                    case .ERC1155:
                        viewStore.send(.mintERC1155(MintERC1155Input(amount: amount!)))
                    }
                }
            }
            .sheet(isPresented: viewStore.binding(
                get: \.isPresentedERC721NftView,
                send: ArchiveDetailVM.Action.isPresentedERC721NftView
            )) {
                NftView(nftType: .ERC721, asset: viewStore.state.erc721!, isOwn: viewStore.state.ownERC721, sell: { ether in
                    viewStore.send(.isPresentedERC721NftView(false))
                    viewStore.send(.sellERC721(SellInput(ether: ether)))
                }, transfer: { address in
                    viewStore.send(.isPresentedERC721NftView(false))
                    viewStore.send(.transferERC721(TransferInput(toAddress: address)))
                })
            }
            .sheet(isPresented: viewStore.binding(
                get: \.isPresentedERC1155NftView,
                send: ArchiveDetailVM.Action.isPresentedERC1155NftView
            )) {
                NftView(nftType: .ERC1155, asset: viewStore.state.erc1155!, isOwn: viewStore.state.ownERC1155, sell: { ether in
                    viewStore.send(.isPresentedERC1155NftView(false))
                    viewStore.send(.sellERC1155(SellInput(ether: ether)))
                }, transfer: { address in
                    viewStore.send(.isPresentedERC1155NftView(false))
                    viewStore.send(.transferERC1155(TransferInput(toAddress: address)))
                })
            }
        }
    }
}
