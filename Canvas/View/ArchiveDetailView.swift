import AVKit
import SwiftUI

struct ArchiveDetailView: View {
    let data: GraphQL.WorkFragment

    @State var isPresentModal = false
    @State var selectThumbnail: GraphQL.WorkFragment.Thumbnail?

    private let thumbnailSize = UIScreen.main.bounds.size.width / 3
    private let gridItemLayout = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]

    var body: some View {
        ScrollView {
            VStack {
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
                            self.selectThumbnail = data
                            self.isPresentModal = true
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
            PhotoView(url: selectThumbnail?.imageUrl)
        }
    }
}
