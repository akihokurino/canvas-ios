import AVKit
import SwiftUI

struct ArchiveDetailView: View {
    let data: CanvasAPI.WorkFragment

    @ObservedObject var nftConnector = NftConnector()
    @State var isPresentModal = false
    @State var selectThumbnail: CanvasAPI.WorkFragment.Thumbnail?

    private let thumbnailSize = UIScreen.main.bounds.size.width / 3
    private let gridItemLayout = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]

    var body: some View {
        ScrollView {
            VStack {
                if nftConnector.hasNft != nil, nftConnector.hasNft! {
                    Text("NFT already exist")
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                }

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
                            if nftConnector.hasNft != nil, !nftConnector.hasNft! {
                                self.selectThumbnail = data
                                self.isPresentModal = true
                            }
                        }) {
                            RemoteImageView(url: data.imageUrl)
                                .scaledToFit()
                                .frame(width: thumbnailSize)
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $isPresentModal) {
            if let thumbnail = selectThumbnail {
                CreateNftView(data: thumbnail) { point, level in
                    self.isPresentModal = false

                    nftConnector.create(workId: data.id, thumbnailUrl: thumbnail.imageGsPath, level: level, point: point)
                }
            }
        }
        .overlay(
            Group {
                if nftConnector.isRequesting {
                    HUD(isLoading: $nftConnector.isRequesting)
                }
            }, alignment: .center
        )
        .onAppear {
            nftConnector.hasNft(workId: data.id)
        }
    }
}
