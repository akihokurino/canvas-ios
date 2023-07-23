import SwiftUI

struct MintNftView: View {
    let data: AssetGeneratorAPI.FrameFragment
    let callback: (NftGeneratorAPI.Schema, Int?) -> Void

    @State var amount: String = "1"
    
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            VStack {
                RemoteImageView(url: data.orgImageUrl)
                    .frame(width: 200)
                    .clipped()
                Spacer().frame(height: 10)
                TextFieldView(value: $amount, label: "数量（ERC1155）", keyboardType: .numberPad, isDisable: true)
                Spacer()
                ActionButton(text: "発行", buttonType: .primary) {
                    callback(.erc721, nil)
                }
            }
            .padding()
            .navigationBarTitle("NFT発行", displayMode: .inline)
            .navigationBarItems(leading: Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "xmark")
            })
        }
    }
}
