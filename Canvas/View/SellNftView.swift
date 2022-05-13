import SwiftUI

struct SellNftView: View {
    let nftType: NftType
    let asset: Asset
    let isOwn: Bool
    let sell: (Double) -> Void
    let transfer: (String) -> Void

    @Environment(\.presentationMode) private var presentationMode
    @State var ether: String = ""
    @State var address: String = ""

    var body: some View {
        VStack {
            RemoteImageView(url: asset.imageUrl)
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
                    UIApplication.shared.open(URL(string: "https://testnets.opensea.io/assets/\(asset.address)/\(asset.tokenId)")!)
                }
            }
        }
        .padding()
    }
}
