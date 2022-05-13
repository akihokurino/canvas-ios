import SwiftUI

struct CreateNftView: View {
    let data: CanvasAPI.WorkFragment.Thumbnail
    let hasNft721: Bool
    let hasNft1155: Bool
    let callback: (NftType, Int, Int, Int?) -> Void

    @Environment(\.presentationMode) private var presentationMode
    @State var point: String = ""
    @State var level: String = ""
    @State var amount: String = ""

    var body: some View {
        VStack {
            RemoteImageView(url: data.imageUrl)
                .frame(width: 200)
                .clipped()

            Spacer().frame(height: 10)
            TextFieldView(value: $point, label: "Point", keyboardType: .numberPad)
            Spacer().frame(height: 10)
            TextFieldView(value: $level, label: "Level", keyboardType: .numberPad)
            Spacer().frame(height: 10)
            TextFieldView(value: $amount, label: "Amount", keyboardType: .numberPad)
            Spacer()
            HStack {
                ActionButton(text: "Mint NFT721", background: hasNft721 ? .disable : .primary) {
                    if !point.isEmpty, !level.isEmpty {
                        callback(NftType.ERC721, Int(point)!, Int(level)!, nil)
                    }
                }
                Spacer()
                ActionButton(text: "Mint NFT1155", background: hasNft1155 ? .disable : .primary) {
                    if !point.isEmpty, !level.isEmpty, !amount.isEmpty {
                        callback(NftType.ERC1155, Int(point)!, Int(level)!, Int(amount)!)
                    }
                }
            }
        }
        .padding()
    }
}
