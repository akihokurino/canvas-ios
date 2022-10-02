import Combine
import ComposableArchitecture
import SwiftUI

struct FrameListView: View {
    let store: Store<FrameListVM.State, FrameListVM.Action>

    private let gridItemSize = UIScreen.main.bounds.size.width / 3
    private let gridItemLayout = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]

    var body: some View {
        WithViewStore(store) { viewStore in
            List {
                LazyVGrid(columns: gridItemLayout, alignment: HorizontalAlignment.leading, spacing: 3) {
                    ForEach(viewStore.state.frames) { data in
                        Button(action: {
                            viewStore.send(.presentDetailView(data))
                        }) {
                            RemoteImageView(url: data.resizedImageUrl)
                                .scaledToFit()
                                .frame(width: gridItemSize)
                        }
                    }
                }
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets())
                .buttonStyle(PlainButtonStyle())

                if viewStore.state.initialized {
                    bottom
                }
            }
            .listStyle(PlainListStyle())
            .overlay(
                Group {
                    if viewStore.state.shouldShowHUD {
                        HUD(isLoading: viewStore.binding(
                            get: \.shouldShowHUD,
                            send: FrameListVM.Action.shouldShowHUD
                        ))
                    }
                }, alignment: .center
            )
            .refreshable {
                await viewStore.send(.startRefresh, while: \.shouldPullToRefresh)
            }
            .navigationBarTitle("", displayMode: .inline)
            .sheet(isPresented: viewStore.binding(
                get: \.isPresentedDetailView,
                send: FrameListVM.Action.isPresentedDetailView
            )) {
                FrameDetailView(url: viewStore.selectFrame?.orgImageUrl)
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
