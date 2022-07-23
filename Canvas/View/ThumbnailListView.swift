import Combine
import ComposableArchitecture
import SwiftUI

struct ThumbnailListView: View {
    let store: Store<ThumbnailListVM.State, ThumbnailListVM.Action>

    private let thumbnailSize = UIScreen.main.bounds.size.width / 3
    private let gridItemLayout = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]

    var body: some View {
        WithViewStore(store) { viewStore in
            List {
                LazyVGrid(columns: gridItemLayout, alignment: HorizontalAlignment.leading, spacing: 3) {
                    ForEach(viewStore.state.thumbnails) { data in
                        Button(action: {
                            viewStore.send(.presentDetailView(data))
                        }) {
                            RemoteImageView(url: data.imageUrl)
                                .scaledToFit()
                                .frame(width: thumbnailSize)
                        }
                    }
                }
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets())
                .buttonStyle(PlainButtonStyle())

                bottom
            }
            .listStyle(PlainListStyle())
            .overlay(
                Group {
                    if viewStore.state.shouldShowHUD {
                        HUD(isLoading: viewStore.binding(
                            get: \.shouldShowHUD,
                            send: ThumbnailListVM.Action.shouldShowHUD
                        ))
                    }
                }, alignment: .center
            )
            .pullToRefresh(isShowing: viewStore.binding(
                get: \.shouldPullToRefresh,
                send: ThumbnailListVM.Action.shouldPullToRefresh
            )) {
                viewStore.send(.startRefresh)
            }
            .navigationBarTitle("", displayMode: .inline)
            .sheet(isPresented: viewStore.binding(
                get: \.isPresentedDetailView,
                send: ThumbnailListVM.Action.isPresentedDetailView
            )) {
                ThumbnailDetailView(url: viewStore.selectThumbnail?.imageUrl)
            }
            .onAppear {
                viewStore.send(.startInitialize)
            }
        }
    }

    private var bottom: some View {
        WithViewStore(store) { viewStore in
            Group {
                if viewStore.state.hasNext && !viewStore.state.shouldShowNextLoading {
                    Button(action: {
                        viewStore.send(.startNext)
                    }) {
                        HStack {
                            Spacer()
                            Text("Next")
                            Spacer()
                        }
                    }
                    .frame(height: 60)
                    .foregroundColor(Color.blue)
                }

                if viewStore.state.hasNext && viewStore.state.shouldShowNextLoading {
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
}
