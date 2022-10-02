import ComposableArchitecture
import SwiftUI

struct ContractListView: View {
    let store: Store<ContractListVM.State, ContractListVM.Action>

    var body: some View {
        WithViewStore(store) { viewStore in
            List {
                VStack {
                    ForEach(viewStore.state.contracts) { item in
                        Button(action: {
                            viewStore.send(.presentDetailView(item))
                        }) {
                            ContractRow(data: item)
                        }
                        .onAppear {
                            if item == viewStore.state.contracts.last {
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
                ForEach(data.tokens.shuffled().prefix(3)) { token in
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
