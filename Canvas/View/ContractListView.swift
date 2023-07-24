import ComposableArchitecture
import SwiftUI

struct ContractListView: View {
    let store: Store<ContractListVM.State, ContractListVM.Action>

    @State private var presentMenu = false

    var body: some View {
        WithViewStore(store) { viewStore in
            List {
                if viewStore.state.initialized {
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
                            viewStore.send(.startFetchNextContract)
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
            .onAppear {
                viewStore.send(.startInitialize)
            }
            .alert(
                viewStore.error?.alert.title ?? "",
                isPresented: viewStore.binding(
                    get: { $0.isPresentedErrorAlert },
                    send: ContractListVM.Action.isPresentedErrorAlert
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
    let data: NftGeneratorAPI.ContractFragment

    private let gridItemLayout = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]

    var body: some View {
        VStack(alignment: .leading) {
            Text("\(data.name) / \(data.network.rawValue)").font(.headline)
            Text(data.address).font(.subheadline)
                .padding(.top, 1)
            Text("\(data.schema.rawValue)").font(.caption)
                .padding(.top, 1)

            HStack {
                ForEach((data.tokens.edges.map { $0.node.fragments.tokenFragment }).prefix(3)) { token in
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
