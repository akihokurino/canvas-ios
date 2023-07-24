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
            ScrollView {
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

                if viewStore.state.initialized {
                    if viewStore.state.hasNext {
                        HStack {
                            Spacer()
                            ProgressView()
                            Spacer()
                        }
                        .frame(height: 60)
                        .onTapGesture {
                            // TODO: onAppearでInfinityScroll実現できない
                            // ロード時に全てのCellがonAppearしてしまう
                            viewStore.send(.startFetchNextFrame)
                        }
                    } else {
                        Spacer().frame(height: 60)
                    }
                }
            }
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
            .alert(
                viewStore.error?.alert.title ?? "",
                isPresented: viewStore.binding(
                    get: { $0.isPresentedErrorAlert },
                    send: FrameListVM.Action.isPresentedErrorAlert
                ),
                presenting: viewStore.error?.alert
            ) { _ in
                Button("OK") {
                    viewStore.send(.isPresentedErrorAlert(false))
                }
            } message: { entity in
                Text(entity.message)
            }
        }
    }
}
