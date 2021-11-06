import Combine
import SwiftUI

struct ThumbnailListView: View {
    @ObservedObject var thumbnailListFetcher = ThumbnailListFetcher()
    @State var isRefreshing = false
    @State var isPresentModal = false
    @State var selectThumbnail: GraphQL.ThumbnailFragment?

    private let thumbnailSize = UIScreen.main.bounds.size.width / 3
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
                ForEach(thumbnailListFetcher.thumbnails) { data in
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

            bottom
        }
        .coordinateSpace(name: RefreshControlKey)
        .navigationBarTitle("", displayMode: .inline)
        .sheet(isPresented: $isPresentModal) {
            PhotoView(url: selectThumbnail?.imageUrl)
        }
        .onAppear {
            thumbnailListFetcher.initialize {
                self.isRefreshing = false
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
