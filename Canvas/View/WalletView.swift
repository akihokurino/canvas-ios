import CombineSchedulers
import ComposableArchitecture
import SwiftUI

struct WalletView: View {
    let store: Store<WalletVM.State, WalletVM.Action>

    var body: some View {
        WithViewStore(store) { viewStore in
            ScrollView {
                VStack(alignment: .leading) {
                    Button(action: {
                        UIPasteboard.general.string = viewStore.address
                    }) {
                        Text(viewStore.address)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .multilineTextAlignment(.leading)
                            .font(.headline)
                            .lineLimit(nil)
                    }
                    .foregroundColor(Color.blue)

                    Spacer().frame(height: 20)

                    Text("\(viewStore.balance) Ether")
                        .frame(
                            minWidth: 0,
                            maxWidth: .infinity,
                            minHeight: 100,
                            maxHeight: 100,
                            alignment: .center
                        )
                        .background(Color.green)
                        .foregroundColor(Color.white)
                        .cornerRadius(5.0)
                        .font(.largeTitle)
                }
                .padding()
            }
            .overlay(
                Group {
                    if viewStore.state.shouldShowHUD {
                        HUD(isLoading: viewStore.binding(
                            get: \.shouldShowHUD,
                            send: WalletVM.Action.shouldShowHUD
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
                    send: WalletVM.Action.isPresentedErrorAlert
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
