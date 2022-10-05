import SwiftUI

struct TextFieldView: View {
    @Binding var value: String

    let label: String
    let keyboardType: UIKeyboardType
    var isDisable: Bool = false

    var body: some View {
        VStack(alignment: .leading) {
            if !label.isEmpty {
                Text(label)
                    .foregroundColor(Color.gray)
                    .font(.body)
            }
            Group {
                TextField("", text: $value, onEditingChanged: { _ in

                }, onCommit: {})
                    .disabled(isDisable)
                    .keyboardType(keyboardType)
                    .textFieldStyle(PlainTextFieldStyle())
                    .frame(height: 50)
                    .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
            }
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(Color.gray.opacity(0.5), lineWidth: 1)
            )
        }
    }
}
