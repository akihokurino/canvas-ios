import Combine
import SwiftUI

struct ThumbnailListView: View {
    @ObservedObject var thumbnailListFetcher = ThumbnailListFetcher()
    @State var isRefreshing = false
    @State var isPresentModal = false
    @State var selectThumbnail: GraphQL.ThumbnailFragment?

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
                thumbnailListFetcher.initialize(isRefresh: true) {
                    self.isRefreshing = false
                }
            })

            LazyVGrid(columns: gridItemLayout, alignment: HorizontalAlignment.leading, spacing: 3) {
                ForEach(thumbnailListFetcher.thumbnails) { item in
                    Button(action: {
                        self.selectThumbnail = item
                        self.isPresentModal = true
                    }) {
                        ThumbnailRow(data: item)
                    }
                }
            }

            bottom
        }
        .coordinateSpace(name: RefreshControlKey)
        .navigationBarTitle("", displayMode: .inline)
        .fullScreenCover(isPresented: $isPresentModal) {
            CropView(thumbnail: selectThumbnail)
        }
        .onAppear {
            thumbnailListFetcher.initialize {
                self.isRefreshing = false
                // 原因は不明だが、nil以外の値でここで初期化しておかないと最初のStateへの代入が反映されない
                self.selectThumbnail = thumbnailListFetcher.thumbnails.first
            }
        }
    }

    private var bottom: some View {
        Group {
            if thumbnailListFetcher.hasNext && !thumbnailListFetcher.isFetching {
                Button(action: {
                    thumbnailListFetcher.next {}
                }) {
                    HStack {
                        Spacer()
                        Text("Next...")
                        Spacer()
                    }
                }
                .frame(height: 60)
            }

            if thumbnailListFetcher.hasNext && thumbnailListFetcher.isFetching {
                HStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
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
