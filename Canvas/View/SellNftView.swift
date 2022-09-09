import SwiftUI

struct SellNftView: View {
    let schema: NftAPI.Schema
    let token: Token
    let isOwn: Bool
    let sell: (Double) -> Void
    let transfer: (String) -> Void

    @State var ether: String = ""
    @State var address: String = ""

    var body: some View {
        VStack {
            RemoteImageView(url: token.imageUrl)
                .frame(width: 200)
                .clipped()

            Spacer().frame(height: 10)
            TextFieldView(value: $ether, label: "Ether", keyboardType: .decimalPad)
            Spacer().frame(height: 10)
            TextFieldView(value: $address, label: "To Address", keyboardType: .default)
            Spacer()
            HStack {
                ActionButton(text: "Sell", background: isOwn ? .primary : .disable) {
                    if !ether.isEmpty {
                        sell(Double(ether)!)
                    }
                }
                Spacer()
                ActionButton(text: "Transfer", background: isOwn ? .primary : .disable) {
                    if !address.isEmpty {
                        transfer(address)
                    }
                }
                Spacer()
                ActionButton(text: "Web", background: isOwn ? .primary : .disable) {
                    UIApplication.shared.open(URL(string: "https://testnets.opensea.io/assets/\(token.address)/\(token.tokenId)")!)
                }
            }
        }
        .padding()
    }
}
