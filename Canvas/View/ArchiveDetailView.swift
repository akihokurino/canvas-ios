import AVKit
import SwiftUI

class ArchiveDetailViewState: ObservableObject {
    @Published var selectedThumbnail: CanvasAPI.WorkFragment.Thumbnail?
    @Published var isPresentCreateNftView = false
    @Published var isPresentSellERC721View = false
    @Published var isPresentSellERC1155View = false
    @Published var isRefreshing = false

    func select(thumbnail: CanvasAPI.WorkFragment.Thumbnail) {
        self.selectedThumbnail = thumbnail
        self.isPresentCreateNftView = true
    }

    func sell(erc: NftType) {
        switch erc {
        case NftType.ERC721:
            self.isPresentSellERC721View = true
        case NftType.ERC1155:
            self.isPresentSellERC1155View = true
        }
    }
}

struct ArchiveDetailView: View {
    let data: CanvasAPI.WorkFragment

    @ObservedObject var nftIntractor = NftIntractor()
    @ObservedObject var viewState = ArchiveDetailViewState()

    private let thumbnailSize = UIScreen.main.bounds.size.width / 3
    private let gridItemLayout = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]

    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    ActionButton(text: "ERC721", background: !(nftIntractor.erc721?.tokenId.isEmpty ?? true) ? .primary : .disable) {
                        viewState.sell(erc: .ERC721)
                    }
                    Spacer()
                    ActionButton(text: "ERC1155", background: !(nftIntractor.erc1155?.tokenId.isEmpty ?? true) ? .primary : .disable) {
                        viewState.sell(erc: .ERC1155)
                    }
                }
                .padding(.top, 20)
                .padding(.horizontal, 20)

                ZStack(alignment: .center) {
                    VideoView(url: URL(string: data.videoUrl)!)
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
                    ForEach(data.thumbnails) { data in
                        Button(action: {
                            guard nftIntractor.isInitAsset else {
                                return
                            }

                            self.viewState.select(thumbnail: data)
                        }) {
                            RemoteImageView(url: data.imageUrl)
                                .scaledToFit()
                                .frame(width: thumbnailSize)
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $viewState.isPresentCreateNftView) {
            if let thumbnail = viewState.selectedThumbnail {
                CreateNftView(data: thumbnail, hasERC721: nftIntractor.erc721 != nil, hasERC1155: nftIntractor.erc1155 != nil) { nftType, amount in
                    self.viewState.isPresentCreateNftView = false

                    switch nftType {
                    case .ERC721:
                        nftIntractor.createERC721(workId: data.id, gsPath: thumbnail.imageGsPath)
                    case .ERC1155:
                        nftIntractor.createERC1155(workId: data.id, gsPath: thumbnail.imageGsPath, amount: amount!)
                    }
                }
            }
        }
        .sheet(isPresented: $viewState.isPresentSellERC721View) {
            SellNftView(nftType: .ERC721, asset: nftIntractor.erc721!, isOwn: nftIntractor.ownERC721, sell: { ether in
                self.viewState.isPresentSellERC721View = false
                nftIntractor.sellERC721(workId: data.id, ether: ether)
            }, transfer: { address in
                self.viewState.isPresentSellERC721View = false
                nftIntractor.transferERC721(workId: data.id, address: address)
            })
        }
        .sheet(isPresented: $viewState.isPresentSellERC1155View) {
            SellNftView(nftType: .ERC1155, asset: nftIntractor.erc1155!, isOwn: nftIntractor.ownERC1155, sell: { ether in
                self.viewState.isPresentSellERC1155View = false
                nftIntractor.sellERC1155(workId: data.id, ether: ether)
            }, transfer: { address in
                self.viewState.isPresentSellERC1155View = false
                nftIntractor.transferERC1155(workId: data.id, address: address)
            })
        }
        .overlay(
            Group {
                if nftIntractor.isLoading {
                    HUD(isLoading: $nftIntractor.isLoading)
                }
            }, alignment: .center
        )
        .onAppear {
            self.nftIntractor.getNft(workId: self.data.id)
        }
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarItems(
            trailing: HStack {
                Button(action: {
                    self.nftIntractor.getNft(workId: self.data.id)
                }) {
                    Image(systemName: "arrow.counterclockwise")
                }
            }
        )
    }
}
