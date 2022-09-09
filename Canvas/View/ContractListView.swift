import ComposableArchitecture
import SwiftUI

struct ContractListView: View {
    let store: Store<ContractListVM.State, ContractListVM.Action>

    var body: some View {
        WithViewStore(store) { viewStore in
            List {
                ForEach(viewStore.state.contracts) { item in
                    ZStack {
                        Button(action: {
                            viewStore.send(.presentDetailView(item))
                        }) {
                            ContractRow(data: item)
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
                            send: ContractListVM.Action.shouldShowHUD
                        ))
                    }
                }, alignment: .center
            )
            .pullToRefresh(isShowing: viewStore.binding(
                get: \.shouldPullToRefresh,
                send: ContractListVM.Action.shouldPullToRefresh
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
                state: \.contractDetailView,
                action: ContractListVM.Action.contractDetailView
            ),
            destination: ContractDetailView.init(store:),
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
