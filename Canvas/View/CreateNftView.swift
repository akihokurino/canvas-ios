import SwiftUI

struct CreateNftView: View {
    let data: CanvasAPI.WorkFragment.Thumbnail
    let callback: ((Int, Int) -> Void)

    @Environment(\.presentationMode) private var presentationMode
    @State var point: String = ""
    @State var level: String = ""

    var body: some View {
        VStack {
            RemoteImageView(url: data.imageUrl)
                .frame(width: 200)
                .clipped()

            Spacer().frame(height: 10)
            TextFieldView(value: $point, label: "Point", keyboardType: .numberPad)
            Spacer().frame(height: 10)
            TextFieldView(value: $level, label: "Level", keyboardType: .numberPad)
            Spacer()
            ActionButton(text: "Create NFT", background: .primary) {
                if !point.isEmpty && !level.isEmpty {
                    callback(Int(point)!, Int(level)!)
                }
            }
        }
        .padding()
    }
}
