import Combine
import ComposableArchitecture
import SwiftUI

struct ArchiveListView: View {
    let store: Store<ArchiveListVM.State, ArchiveListVM.Action>

    var body: some View {
        WithViewStore(store) { viewStore in
            List {
                if viewStore.state.initialized {
                    VStack {
                        ForEach(viewStore.state.archives) { item in
                            Button(action: {
                                viewStore.send(.presentDetailView(item))
                            }) {
                                ArchiveRow(data: item)
                            }
                        }
                        .listRowSeparator(.hidden)
                        .buttonStyle(PlainButtonStyle())

                        if viewStore.state.hasNext {
                            HStack {
                                Spacer()
                                ProgressView()
                                Spacer()
                            }
                            .frame(height: 60)
                            .listRowSeparator(.hidden)
                            .buttonStyle(PlainButtonStyle())
                            .onTapGesture {
                                // TODO: onAppearでInfinityScroll実現できない
                                // ロード時に全てのCellがonAppearしてしまう
                                viewStore.send(.startFetchNextArchive)
                            }
                        } else {
                            Spacer().frame(height: 60)
                                .listRowSeparator(.hidden)
                                .buttonStyle(PlainButtonStyle())
                        }
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
            .alert(
                viewStore.error?.alert.title ?? "",
                isPresented: viewStore.binding(
                    get: { $0.isPresentedErrorAlert },
                    send: ArchiveListVM.Action.isPresentedErrorAlert
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
    let data: AssetGeneratorAPI.WorkFragment

    private let gridItemLayout = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]

    var body: some View {
        VStack(alignment: .leading) {
            Text(data.id).font(.headline)

            HStack {
                ForEach(data.frames.prefix(3)) { frame in
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
