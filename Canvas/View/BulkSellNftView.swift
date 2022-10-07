import SwiftUI

struct BulkSellNftView: View {
    let callback: (Double) -> Void

    @State var ether: String = ""

    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            VStack {
                TextFieldView(value: $ether, label: "売買額（Ether）", keyboardType: .decimalPad)
                Spacer()
                ActionButton(text: "売り注文", buttonType: .primary) {
                    if !ether.isEmpty {
                        callback(Double(ether)!)
                    }
                }
            }
            .padding()
            .navigationBarTitle("NFT一括取引", displayMode: .inline)
            .navigationBarItems(leading: Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "xmark")
            })
        }
    }
}
