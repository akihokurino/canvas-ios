import AVKit
import ComposableArchitecture
import SwiftUI

struct ArchiveDetailView: View {
    let store: Store<ArchiveDetailVM.State, ArchiveDetailVM.Action>

    @State private var presentMenu = false

    private let gridItemSize = UIScreen.main.bounds.size.width / 3
    private let gridItemLayout = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]

    var body: some View {
        WithViewStore(store) { viewStore in
            ScrollView {
                VStack {
                    ZStack(alignment: .center) {
                        VideoView(url: URL(string: viewStore.state.archive.videoUrl)!)
                            .frame(maxWidth: .infinity)
                            .frame(height: 600)
                    }
                    .overlay(Spacer()
                        .frame(maxWidth: .infinity)
                        .frame(height: 70)
                        .background(Color(UIColor.systemBackground)), alignment: .top)
                    .overlay(Spacer()
                        .frame(maxWidth: .infinity)
                        .frame(height: 70)
                        .background(Color(UIColor.systemBackground)), alignment: .bottom)

                    LazyVGrid(columns: gridItemLayout, alignment: HorizontalAlignment.leading, spacing: 3) {
                        ForEach(viewStore.state.frames) { data in
                            Button(action: {
                                viewStore.send(.presentMintNftView(data))
                            }) {
                                RemoteImageView(url: data.resizedImageUrl)
                                    .scaledToFit()
                                    .frame(width: gridItemSize)
                            }
                        }
                    }
                }
            }
            .overlay(
                Group {
                    if viewStore.state.shouldShowHUD {
                        HUD(isLoading: viewStore.binding(
                            get: \.shouldShowHUD,
                            send: ArchiveDetailVM.Action.shouldShowHUD
                        ))
                    }
                }, alignment: .center
            )
            .onAppear {
                viewStore.send(.startInitialize)
            }
            .refreshable {
                await viewStore.send(.startRefresh, while: \.shouldPullToRefresh)
            }
            .navigationBarTitle("", displayMode: .inline)
            .sheet(isPresented: viewStore.binding(
                get: \.isPresentedMintNftView,
                send: ArchiveDetailVM.Action.isPresentedMintNftView
            )) {
                MintNftView(data: viewStore.state.selectFrame!) { schema, amount in
                    viewStore.send(.isPresentedMintNftView(false))
                    viewStore.send(.mint(MintInput()))
                }
            }
            .alert(
                viewStore.error?.alert.title ?? "",
                isPresented: viewStore.binding(
                    get: { $0.isPresentedErrorAlert },
                    send: ArchiveDetailVM.Action.isPresentedErrorAlert
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
