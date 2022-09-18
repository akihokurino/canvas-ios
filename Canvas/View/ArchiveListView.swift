import Combine
import ComposableArchitecture
import SwiftUI
import SwiftUIRefresh

struct ArchiveListView: View {
    let store: Store<ArchiveListVM.State, ArchiveListVM.Action>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            List {
                ForEach(viewStore.state.archives) { item in
                    ZStack {
                        Button(action: {
                            viewStore.send(.presentDetailView(item))
                        }) {
                            ArchiveRow(data: item)
                        }
                    }
                }
                .listRowSeparator(.hidden)
                .buttonStyle(PlainButtonStyle())

                if viewStore.state.initialized {
                    bottom
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
            .pullToRefresh(isShowing: viewStore.binding(
                get: \.shouldPullToRefresh,
                send: ArchiveListVM.Action.shouldPullToRefresh
            )) {
                viewStore.send(.startRefresh)
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
                ForEach(data.thumbnails.shuffled().prefix(3)) { thumbnail in
                    RemoteImageView(url: thumbnail.imageUrl)
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
