import ComposableArchitecture
import SwiftUI

struct MultiTokenListView: View {
    let store: Store<MultiTokenListVM.State, MultiTokenListVM.Action>

    private let thumbnailSize = UIScreen.main.bounds.size.width / 3
    private let gridItemLayout = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]

    var body: some View {
        WithViewStore(store) { viewStore in
            ScrollView {
                LazyVGrid(columns: gridItemLayout, alignment: HorizontalAlignment.leading, spacing: 3) {
                    ForEach(viewStore.state.tokens) { data in
                        Button(action: {
                            viewStore.send(.presentSellNftView(data))
                        }) {
                            RemoteImageView(url: data.imageUrl)
                                .scaledToFit()
                                .frame(width: thumbnailSize)
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
                            viewStore.send(.startNext)
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
                            send: MultiTokenListVM.Action.shouldShowHUD
                        ))
                    }
                }, alignment: .center
            )
            .refreshable {
                await viewStore.send(.startRefresh, while: \.shouldPullToRefresh)
            }
            .navigationBarTitle("", displayMode: .inline)
            .onAppear {
                viewStore.send(.startInitialize)
            }
            .alert(
                viewStore.error?.alert.title ?? "",
                isPresented: viewStore.binding(
                    get: { $0.isPresentedErrorAlert },
                    send: MultiTokenListVM.Action.isPresentedErrorAlert
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
