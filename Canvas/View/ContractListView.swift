import ComposableArchitecture
import SwiftUI

struct ContractListView: View {
    let store: Store<ContractListVM.State, ContractListVM.Action>

    @State private var presentMenu = false

    var body: some View {
        WithViewStore(store) { viewStore in
            List {
                if viewStore.state.initialized {
                    VStack {
                        ForEach(viewStore.state.contracts) { item in
                            Button(action: {
                                viewStore.send(.presentDetailView(item))
                            }) {
                                ContractRow(data: item)
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
                                viewStore.send(.startNext)
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
                            send: ContractListVM.Action.shouldShowHUD
                        ))
                    }
                }, alignment: .center
            )
            .refreshable {
                await viewStore.send(.startRefresh, while: \.shouldPullToRefresh)
            }
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                presentMenu = true
            }) {
                Image(systemName: "ellipsis")
            })
            .onAppear {
                viewStore.send(.startInitialize)
            }
            .actionSheet(isPresented: $presentMenu) {
                ActionSheet(title: Text("メニュー"), buttons:
                    [
                        .default(Text("OpenSeaと同期")) {
                            viewStore.send(.startSyncAllTokens)
                        },
                        .cancel(),
                    ])
            }
        }
        .navigate(
            using: store.scope(
                state: \.contractDetailView,
                action: ContractListVM.Action.contractDetailView
            ),
            destination: ContractDetailView.init(store:),
            onDismiss: {
                ViewStore(store.stateless).send(.popDetailView)
            }
        )
    }
}

struct ContractRow: View {
    let data: NftAPI.ContractFragment

    private let gridItemLayout = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]

    var body: some View {
        VStack(alignment: .leading) {
            Text(data.address).font(.headline)
            Text("\(data.schema.rawValue)").font(.caption)
                .padding(.top, 2)

            HStack {
                ForEach((data.tokens.map { $0.fragments.tokenFragment } + data.multiTokens.map { $0.fragments.tokenFragment }).prefix(3)) { token in
                    RemoteImageView(url: token.imageUrl)
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
