import SwiftUI

struct MintNftView: View {
    let data: CanvasAPI.WorkFragment.Thumbnail
    let hasERC721: Bool
    let hasERC1155: Bool
    let callback: (Schema, Int?) -> Void

    @State var amount: String = ""

    var body: some View {
        VStack {
            RemoteImageView(url: data.imageUrl)
                .frame(width: 200)
                .clipped()

            Spacer().frame(height: 10)
            TextFieldView(value: $amount, label: "Amount", keyboardType: .numberPad)
            Spacer()
            HStack {
                ActionButton(text: "Mint ERC721", background: hasERC721 ? .disable : .primary) {
                    callback(Schema.ERC721, nil)
                }
                Spacer()
                ActionButton(text: "Mint ERC1155", background: hasERC1155 ? .disable : .primary) {
                    if !amount.isEmpty {
                        callback(Schema.ERC1155, Int(amount)!)
                    }
                }
            }
        }
        .padding()
    }
}
