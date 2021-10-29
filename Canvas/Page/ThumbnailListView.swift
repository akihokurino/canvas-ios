import Combine
import SwiftUI

extension GraphQL.ThumbnailFragment: Identifiable {}

struct ThumbnailListView: View {
    @ObservedObject var thumbnailFetcher = ThumbnailFetcher()

    static let thumbnailSize = UIScreen.main.bounds.size.width / 3
    private let gridItemLayout = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: gridItemLayout, alignment: HorizontalAlignment.leading, spacing: 3) {
                ForEach(thumbnailFetcher.thumbnailProvider) { item in
                    Button(action: {}) {
                        ThumbnailRow(data: item)
                    }
                }
            }
        }
        .navigationBarTitle("", displayMode: .inline)
        .onAppear {
            thumbnailFetcher.initThumbnails()
        }
    }
}

struct ThumbnailRow: View {
    let data: GraphQL.ThumbnailFragment

    private let size = CGSize(width: ThumbnailListView.thumbnailSize, height: ThumbnailListView.thumbnailSize * 2)

    var body: some View {
        RemoteImageView(url: data.imageUrl)
            .frame(width: size.width, height: size.height)
    }
}
