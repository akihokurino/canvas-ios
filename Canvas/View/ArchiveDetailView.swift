import AVKit
import SwiftUI

class SelectThumbnailState: ObservableObject {
    @Published var thumbnail: CanvasAPI.ThumbnailFragment?
    @Published var isPresentModal = false

    func select(thumbnail: CanvasAPI.ThumbnailFragment) {
        self.thumbnail = thumbnail
        self.isPresentModal = true
    }
}

struct ArchiveDetailView: View {
    let data: CanvasAPI.WorkFragment

    @ObservedObject var nftIntractor = NftIntractor()
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
                if nftIntractor.hasNft != nil, nftIntractor.hasNft! {
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
                            if nftIntractor.hasNft != nil, !nftIntractor.hasNft! {
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

                    nftIntractor.create(workId: data.id, thumbnailUrl: thumbnail.imageGsPath, level: level, point: point)
                }
            }
        }
        .overlay(
            Group {
                if nftIntractor.isRequesting {
                    HUD(isLoading: $nftIntractor.isRequesting)
                }
            }, alignment: .center
        )
        .onAppear {
            nftIntractor.hasNft(workId: data.id)
        }
    }
}
