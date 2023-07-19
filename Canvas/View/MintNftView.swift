import SwiftUI

struct MintNftView: View {
    let data: AssetGeneratorAPI.FrameFragment
    let hasERC721: Bool
    let hasERC1155: Bool
    let callback: (NftAPI.Schema, Int?) -> Void

    @State var amount: String = ""
    
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            VStack {
                RemoteImageView(url: data.orgImageUrl)
                    .frame(width: 200)
                    .clipped()

                Spacer().frame(height: 10)
                TextFieldView(value: $amount, label: "数量（ERC1155）", keyboardType: .numberPad, isDisable: hasERC1155)
                Spacer()
                HStack {
                    ActionButton(text: "ERC721", buttonType: hasERC721 ? .disable : .primary) {
                        callback(.erc721, nil)
                    }
                    Spacer()
                    ActionButton(text: "ERC1155", buttonType: hasERC1155 ? .disable : .primary) {
                        if !amount.isEmpty {
                            callback(.erc1155, Int(amount)!)
                        }
                    }
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
