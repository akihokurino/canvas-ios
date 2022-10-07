import SwiftUI

struct BulkMintNftView: View {
    let callback: (NftAPI.Schema, Int?, Double) -> Void

    @State var amount: String = ""
    @State var ether: String = ""

    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            VStack {
                TextFieldView(value: $amount, label: "数量（ERC1155）", keyboardType: .numberPad)
                Spacer().frame(height: 10)
                TextFieldView(value: $ether, label: "売買額（Ether）", keyboardType: .decimalPad)
                Spacer()
                HStack {
                    ActionButton(text: "ERC721", buttonType: .primary) {
                        if !ether.isEmpty {
                            callback(.erc721, nil, Double(ether)!)
                        }
                    }
                    Spacer()
                    ActionButton(text: "ERC1155", buttonType: .primary) {
                        if !amount.isEmpty && !ether.isEmpty {
                            callback(.erc1155, Int(amount)!, Double(ether)!)
                        }
                    }
                }
            }
            .padding()
            .navigationBarTitle("NFT一括発行", displayMode: .inline)
            .navigationBarItems(leading: Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "xmark")
            })
        }
    }
}
