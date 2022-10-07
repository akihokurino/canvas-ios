import SwiftUI

struct SellNftView: View {
    let token: NftAPI.TokenFragment
    let sell: (Double) -> Void
    let transfer: (String) -> Void

    @State var ether: String = ""
    @State var address: String = ""

    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            VStack {
                RemoteImageView(url: token.imageUrl)
                    .frame(width: 200)
                    .clipped()

                Spacer().frame(height: 10)
                TextFieldView(value: $ether, label: "売買額（Ether）", keyboardType: .decimalPad, isDisable: token.priceEth != nil)
                Spacer().frame(height: 10)
                TextFieldView(value: $address, label: "宛先", keyboardType: .emailAddress, isDisable: !token.isOwn)
                Spacer()
                HStack {
                    ActionButton(text: "売り注文", buttonType: !token.isOwn || token.priceEth != nil ? .disable : .primary) {
                        if !ether.isEmpty {
                            sell(Double(ether)!)
                        }
                    }
                    Spacer()
                    ActionButton(text: "送付", buttonType: !token.isOwn ? .disable : .primary) {
                        if !address.isEmpty {
                            transfer(address)
                        }
                    }
                }
            }
            .padding()
            .navigationBarTitle("NFT取引", displayMode: .inline)
            .navigationBarItems(leading: Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "xmark")
            }, trailing: Button(action: {
                UIApplication.shared.open(URL(string: "https://testnets.opensea.io/assets/\(token.address)/\(token.tokenId)")!)
            }) {
                Image(systemName: "link")
            })
            .onAppear {
                if let price = token.priceEth {
                    ether = "\(price)"
                }
            }
        }
    }
}
