import AVKit
import SwiftUI

class ArchiveDetailViewState: ObservableObject {
    @Published var selectedThumbnail: CanvasAPI.WorkFragment.Thumbnail?
    @Published var isPresentCreateNftView = false
    @Published var isPresentSellNft721View = false
    @Published var isPresentSellNft1155View = false
    @Published var isRefreshing = false

    func select(thumbnail: CanvasAPI.WorkFragment.Thumbnail) {
        self.selectedThumbnail = thumbnail
        self.isPresentCreateNftView = true
    }

    func sell(erc: NftType) {
        switch erc {
        case NftType.ERC721:
            self.isPresentSellNft721View = true
        case NftType.ERC1155:
            self.isPresentSellNft1155View = true
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
                    ActionButton(text: "NFT721", background: !(nftIntractor.nft721?.tokenId.isEmpty ?? true) ? .primary : .disable) {
                        viewState.sell(erc: .ERC721)
                    }
                    Spacer()
                    ActionButton(text: "NFT1155", background: !(nftIntractor.nft1155?.tokenId.isEmpty ?? true) ? .primary : .disable) {
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
                CreateNftView(data: thumbnail, hasNft721: nftIntractor.nft721 != nil, hasNft1155: nftIntractor.nft1155 != nil) { nftType, point, level, amount in
                    self.viewState.isPresentCreateNftView = false

                    switch nftType {
                    case .ERC721:
                        nftIntractor.create721(workId: data.id, gsPath: thumbnail.imageGsPath, level: level, point: point)
                    case .ERC1155:
                        nftIntractor.create1155(workId: data.id, gsPath: thumbnail.imageGsPath, level: level, point: point, amount: amount!)
                    }
                }
            }
        }
        .sheet(isPresented: $viewState.isPresentSellNft721View) {
            SellNftView(nftType: .ERC721, asset: nftIntractor.nft721!, isOwn: nftIntractor.ownNft721, sell: { ether in
                self.viewState.isPresentSellNft721View = false
                nftIntractor.sell721(workId: data.id, ether: ether)
            }, transfer: { address in
                self.viewState.isPresentSellNft721View = false
                nftIntractor.transfer721(workId: data.id, address: address)
            })
        }
        .sheet(isPresented: $viewState.isPresentSellNft1155View) {
            SellNftView(nftType: .ERC1155, asset: nftIntractor.nft1155!, isOwn: nftIntractor.ownNft1155, sell: { ether in
                self.viewState.isPresentSellNft1155View = false
                nftIntractor.sell1155(workId: data.id, ether: ether)
            }, transfer: { address in
                self.viewState.isPresentSellNft1155View = false
                nftIntractor.transfer1155(workId: data.id, address: address)
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
