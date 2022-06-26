import SwiftUI

struct CreateNftView: View {
    let data: CanvasAPI.WorkFragment.Thumbnail
    let hasERC721: Bool
    let hasERC1155: Bool
    let callback: (NftType, Int?) -> Void

    @Environment(\.presentationMode) private var presentationMode
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
                    callback(NftType.ERC721, nil)
                }
                Spacer()
                ActionButton(text: "Mint ERC1155", background: hasERC1155 ? .disable : .primary) {
                    if !amount.isEmpty {
                        callback(NftType.ERC1155, Int(amount)!)
                    }
                }
            }
        }
        .padding()
    }
}
