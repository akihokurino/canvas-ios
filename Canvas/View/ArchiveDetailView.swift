import AVKit
import ComposableArchitecture
import SwiftUI

struct ArchiveDetailView: View {
    let store: Store<ArchiveDetailVM.State, ArchiveDetailVM.Action>

    @State private var presentMenu = false

    private let gridItemSize = UIScreen.main.bounds.size.width / 3
    private let gridItemLayout = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]

    var body: some View {
        WithViewStore(store) { viewStore in
            ScrollView {
                VStack {
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

                    Group {
                        VStack(alignment: .leading) {
                            Text("NFT取引")
                                .font(.headline)
                                .frame(maxWidth: .infinity, alignment: .leading)

                            if viewStore.state.erc721 != nil {
                                Button(action: {
                                    viewStore.send(.presentSellNftView(.erc721))
                                }) {
                                    HStack {
                                        Text("ERC721").font(.subheadline)
                                        Spacer()
                                        Image(systemName: "chevron.forward")
                                            .resizable()
                                            .frame(width: 8, height: 15, alignment: .center)
                                    }
                                }
                                .foregroundColor(Color("Text"))
                                Divider()
                            }

                            if viewStore.state.erc1155 != nil {
                                Button(action: {
                                    viewStore.send(.presentSellNftView(.erc1155))
                                }) {
                                    HStack {
                                        Text("ERC1155").font(.subheadline)
                                        Spacer()
                                        Image(systemName: "chevron.forward")
                                            .resizable()
                                            .frame(width: 8, height: 15, alignment: .center)
                                    }
                                }
                                .foregroundColor(Color("Text"))
                                Divider()
                            }
                        }
                        .padding(.horizontal, 16)

                        Spacer().frame(height: 40)
                    }

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
            }
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
            .refreshable {
                await viewStore.send(.startRefresh, while: \.shouldPullToRefresh)
            }
            .onAppear {
                viewStore.send(.startInitialize)
                viewStore.send(.fetchFrames)
            }
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                presentMenu = true
            }) {
                Image(systemName: "ellipsis")
            })
            .actionSheet(isPresented: $presentMenu) {
                ActionSheet(title: Text("メニュー"), buttons:
                    [
                        .default(Text("一括発行")) {
                            viewStore.send(.presentBulkMintNftView)
                        },
                        .cancel(),
                    ])
            }
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
                get: \.isPresentedBulkMintNftView,
                send: ArchiveDetailVM.Action.isPresentedBulkMintNftView
            )) {
                BulkMintNftView { schema, amount, ether in
                    viewStore.send(.isPresentedBulkMintNftView(false))

                    switch schema {
                    case .erc721:
                        viewStore.send(.bulkMintERC721(BulkMintERC721Input(ether: ether)))
                    case .erc1155:
                        viewStore.send(.bulkMintERC1155(BulkMintERC1155Input(amount: amount!, ether: ether)))
                    default:
                        break
                    }
                }
            }
            .sheet(isPresented: viewStore.binding(
                get: \.isPresentedERC721SellNftView,
                send: ArchiveDetailVM.Action.isPresentedERC721SellNftView
            )) {
                SellNftView(token: viewStore.state.erc721!, sell: { ether in
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
                SellNftView(token: viewStore.state.erc1155!, sell: { ether in
                    viewStore.send(.isPresentedERC1155SellNftView(false))
                    viewStore.send(.sellERC1155(SellInput(ether: ether)))
                }, transfer: { address in
                    viewStore.send(.isPresentedERC1155SellNftView(false))
                    viewStore.send(.transferERC1155(TransferInput(toAddress: address)))
                })
            }
            .alert(
                viewStore.error?.alert.title ?? "",
                isPresented: viewStore.binding(
                    get: { $0.isPresentedErrorAlert },
                    send: ArchiveDetailVM.Action.isPresentedErrorAlert
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
