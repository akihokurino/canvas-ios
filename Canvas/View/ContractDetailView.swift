import ComposableArchitecture
import SwiftUI
import SwiftUIPager

struct ContractDetailView: View {
    let store: Store<ContractDetailVM.State, ContractDetailVM.Action>

    var body: some View {
        WithViewStore(store) { viewStore in
            List {
                VStack {
                    ForEach(viewStore.state.tokens) { data in
                        Button(action: {
                            viewStore.send(.presentSellNftView(data))
                        }) {
                            TokenRow(data: data)
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
                            viewStore.send(.startFetchNextToken)
                        }
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
                            send: ContractDetailVM.Action.shouldShowHUD
                        ))
                    }
                }, alignment: .center
            )
            .refreshable {
                await viewStore.send(.startRefresh, while: \.shouldPullToRefresh)
            }
            .navigationBarTitle(viewStore.state.contract.name, displayMode: .inline)
            .onAppear {
                viewStore.send(.startInitialize)
            }
            .sheet(isPresented: viewStore.binding(
                get: \.isPresentedSellNftView,
                send: ContractDetailVM.Action.isPresentedSellNftView
            )) {
                SellNftView(token: viewStore.state.selectToken!, sell: { ether in
                    viewStore.send(.isPresentedSellNftView(false))
                    viewStore.send(.startSell(SellInput(ether: ether)))
                }, transfer: { address in
                    viewStore.send(.isPresentedSellNftView(false))
                    viewStore.send(.startTransfer(TransferInput(toAddress: address)))
                })
            }
            .alert(
                viewStore.error?.alert.title ?? "",
                isPresented: viewStore.binding(
                    get: { $0.isPresentedErrorAlert },
                    send: ContractDetailVM.Action.isPresentedErrorAlert
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

struct TokenRow: View {
    let data: NftGeneratorAPI.TokenFragment

    var body: some View {
        VStack(alignment: .leading) {
            Text("\(data.address)#\(data.tokenId)").font(.subheadline).foregroundColor(data.isOwner ? Color("Text") : Color.gray)
            Text("\(data.name) / \(data.description)").font(.subheadline).foregroundColor(data.isOwner ? Color("Text") : Color.gray)

            Spacer().frame(height: 10)

            RemoteImageView(url: data.imageUrl)
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: .infinity)
                .cornerRadius(4)

            if let priceEth = data.priceEth {
                Spacer().frame(height: 10)
                Text("\(priceEth.description) AVAX")
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 40, maxHeight: 40, alignment: .center)
                    .background(Color.green)
                    .foregroundColor(Color.white)
                    .cornerRadius(4)
            }

            Spacer().frame(height: 20)
        }
        .padding(.top, 10)
        .padding(.bottom, 10)
    }
}
