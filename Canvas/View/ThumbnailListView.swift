import Combine
import SwiftUI

extension GraphQL.ThumbnailFragment: Identifiable {}

struct ThumbnailListView: View {
    @ObservedObject var thumbnailFetcher = ThumbnailFetcher()
    @State var isRefreshing = false

    static let thumbnailSize = UIScreen.main.bounds.size.width / 3
    private let gridItemLayout = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]

    var body: some View {
        ScrollView {
            RefreshControl(isRefreshing: $isRefreshing, coordinateSpaceName: RefreshControlKey, onRefresh: {
                isRefreshing = true
                thumbnailFetcher.initThumbnails {
                    self.isRefreshing = false
                }
            })

            LazyVGrid(columns: gridItemLayout, alignment: HorizontalAlignment.leading, spacing: 3) {
                ForEach(thumbnailFetcher.thumbnails) { item in
                    Button(action: {}) {
                        ThumbnailRow(data: item)
                    }
                }
            }

            bottom
        }
        .coordinateSpace(name: RefreshControlKey)
        .navigationBarTitle("", displayMode: .inline)
        .onAppear {
            thumbnailFetcher.initThumbnails {
                self.isRefreshing = false
            }
        }
    }

    private var bottom: some View {
        Group {
            if thumbnailFetcher.hasNext && !thumbnailFetcher.isFetching && thumbnailFetcher.thumbnails.count > 0 {
                Button(action: {
                    thumbnailFetcher.nextThumbnails {}
                }) {
                    HStack {
                        Spacer()
                        Text("次のページを表示する")
                        Spacer()
                    }
                }
                .frame(height: 60)
            }

            if thumbnailFetcher.hasNext && thumbnailFetcher.isFetching && thumbnailFetcher.thumbnails.count > 0 {
                HStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
                .frame(height: 60)
            }

            if !thumbnailFetcher.hasNext {
                HStack {}
                    .frame(height: 60)
            }
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
