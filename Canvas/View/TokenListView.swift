import ComposableArchitecture
import SwiftUI

struct TokenListView: View {
    let store: Store<TokenListVM.State, TokenListVM.Action>

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
                            send: TokenListVM.Action.shouldShowHUD
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
        }
    }
}
