import SwiftUI

struct WalletView: View {
    @ObservedObject var walletIntractor = WalletIntractor()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Button(action: {}) {
                    Text(walletIntractor.address)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .multilineTextAlignment(.leading)
                        .font(.title3)
                        .lineLimit(nil)
                }
                Spacer().frame(height: 20)
                Text("\(walletIntractor.balance) Ether")
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
        .onAppear {
            walletIntractor.getWallet()
        }
    }
}
