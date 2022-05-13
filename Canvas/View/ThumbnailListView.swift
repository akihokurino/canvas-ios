import Combine
import SwiftUI

class ThumbnailListViewState: ObservableObject {
    @Published var selectedThumbnail: CanvasAPI.ThumbnailFragment?
    @Published var isPresentDetailView = false
    @Published var isRefreshing = false

    func select(thumbnail: CanvasAPI.ThumbnailFragment) {
        self.selectedThumbnail = thumbnail
        self.isPresentDetailView = true
    }
}

struct ThumbnailListView: View {
    @ObservedObject var thumbnailIntractor = ThumbnailIntractor()
    @ObservedObject var viewState = ThumbnailListViewState()

    private let thumbnailSize = UIScreen.main.bounds.size.width / 3
    private let gridItemLayout = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]

    var body: some View {
        ScrollView {
            RefreshControl(isRefreshing: $viewState.isRefreshing, coordinateSpaceName: RefreshControlKey, onRefresh: {
                viewState.isRefreshing = true
                thumbnailIntractor.initialize(isRefresh: true) {
                    self.viewState.isRefreshing = false
                }
            })

            LazyVGrid(columns: gridItemLayout, alignment: HorizontalAlignment.leading, spacing: 3) {
                ForEach(thumbnailIntractor.thumbnails) { data in
                    Button(action: {
                        viewState.select(thumbnail: data)
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
        .sheet(isPresented: $viewState.isPresentDetailView) {
            ThumbnailDetailView(url: viewState.selectedThumbnail?.imageUrl)
        }
        .overlay(
            Group {
                if thumbnailIntractor.isInitializing {
                    HUD(isLoading: $thumbnailIntractor.isInitializing)
                }
            }, alignment: .center
        )
        .onAppear {
            thumbnailIntractor.initialize {
                self.viewState.isRefreshing = false
            }
        }
    }

    private var bottom: some View {
        Group {
            if thumbnailIntractor.hasNext && !thumbnailIntractor.isFetching {
                Button(action: {
                    thumbnailIntractor.next {}
                }) {
                    HStack {
                        Spacer()
                        Text("Next...")
                        Spacer()
                    }
                }
                .frame(height: 60)
            }

            if thumbnailIntractor.hasNext && thumbnailIntractor.isFetching {
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
