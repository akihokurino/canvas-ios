import Combine
import ComposableArchitecture
import SwiftUI

struct ArchiveListView: View {
    let store: Store<ArchiveListVM.State, ArchiveListVM.Action>

    var body: some View {
        WithViewStore(store) { viewStore in
            List {
                VStack {
                    ForEach(viewStore.state.archives) { item in
                        Button(action: {
                            viewStore.send(.presentDetailView(item))
                        }) {
                            ArchiveRow(data: item)
                        }
                        .onAppear {
                            if item == viewStore.state.archives.last {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    viewStore.send(.startNext)
                                }
                            }
                        }
                    }
                    .listRowSeparator(.hidden)
                    .buttonStyle(PlainButtonStyle())

                    if viewStore.state.initialized && viewStore.state.hasNext {
                        HStack {
                            Spacer()
                            ProgressView()
                            Spacer()
                        }
                        .frame(height: 60)
                        .listRowSeparator(.hidden)
                        .buttonStyle(PlainButtonStyle())
                    } else {
                        Spacer().frame(height: 60)
                            .listRowSeparator(.hidden)
                            .buttonStyle(PlainButtonStyle())
                    }
                }
            }
            .overlay(
                Group {
                    if viewStore.state.shouldShowHUD {
                        HUD(isLoading: viewStore.binding(
                            get: \.shouldShowHUD,
                            send: ArchiveListVM.Action.shouldShowHUD
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
        .navigate(
            using: store.scope(
                state: \.archiveDetailView,
                action: ArchiveListVM.Action.archiveDetailView
            ),
            destination: ArchiveDetailView.init(store:),
            onDismiss: {
                ViewStore(store.stateless).send(.popDetailView)
            }
        )
    }
}

struct ArchiveRow: View {
    let data: CanvasAPI.WorkFragment

    private let gridItemLayout = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]

    var body: some View {
        VStack(alignment: .leading) {
            Text(data.id).font(.headline)

            HStack {
                ForEach(data.frames.shuffled().prefix(3)) { frame in
                    RemoteImageView(url: frame.resizedImageUrl)
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: .infinity)
                        .cornerRadius(4)
                }
            }
        }
        .padding(.top, 10)
        .padding(.bottom, 10)
    }
}
