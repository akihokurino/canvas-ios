import AVKit
import SwiftUI

class ArchiveDetailViewState: ObservableObject {
    @Published var selected: CanvasAPI.WorkFragment.Thumbnail?
    @Published var isPresentModal = false
    @Published var isRefreshing = false

    func select(thumbnail: CanvasAPI.WorkFragment.Thumbnail) {
        self.selected = thumbnail
        self.isPresentModal = true
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
                    ActionButton(text: "721 NFT", background: nftIntractor.nft721?.tokenId.isEmpty ?? true ? .disable : .primary) {
                        if let asset = nftIntractor.nft721 {
                            UIApplication.shared.open(URL(string: "https://testnets.opensea.io/assets/\(asset.address)/\(asset.tokenId)")!)
                        }
                    }
                    Spacer()
                    ActionButton(text: "1155 NFT", background: nftIntractor.nft1155?.tokenId.isEmpty ?? true ? .disable : .primary) {
                        if let asset = nftIntractor.nft1155 {
                            UIApplication.shared.open(URL(string: "https://testnets.opensea.io/assets/\(asset.address)/\(asset.tokenId)")!)
                        }
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
                            guard nftIntractor.hasNft721 != nil, nftIntractor.hasNft1155 != nil else {
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
        .sheet(isPresented: $viewState.isPresentModal) {
            if let thumbnail = viewState.selected {
                CreateNftView(data: thumbnail, hasNft721: nftIntractor.hasNft721!, hasNft1155: nftIntractor.hasNft1155!) { nftType, point, level, amount in
                    self.viewState.isPresentModal = false

                    switch nftType {
                    case .ERC721:
                        nftIntractor.create721(workId: data.id, gsPath: thumbnail.imageGsPath, level: level, point: point)
                    case .ERC1155:
                        nftIntractor.create1155(workId: data.id, gsPath: thumbnail.imageGsPath, level: level, point: point, amount: amount!)
                    }
                }
            }
        }
        .overlay(
            Group {
                if nftIntractor.isCreating {
                    HUD(isLoading: $nftIntractor.isCreating)
                }
            }, alignment: .center
        )
        .onAppear {
            nftIntractor.hasNft(workId: data.id)
        }
    }
}
