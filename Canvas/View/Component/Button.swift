import SwiftUI

enum ActionButtonType {
    case primary
    case caution
    case disable

    var color: Color {
        switch self {
        case .primary:
            return Color.blue
        case .caution:
            return Color.red
        case .disable:
            return Color.gray
        }
    }
}

struct ActionButton: View {
    let text: String
    let buttonType: ActionButtonType
    let action: () -> Void

    init(text: String, buttonType: ActionButtonType, action: @escaping () -> Void) {
        self.text = text
        self.buttonType = buttonType
        self.action = action
    }

    var body: some View {
        Button(action: {
            guard buttonType != .disable else {
                return
            }
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            action()
        }) {
            HStack {
                Spacer()
                Text(text)
                    .foregroundColor(Color.white)
                    .fontWeight(.bold)
                Spacer()
            }
        }
        .padding(.horizontal, 5)
        .padding(.vertical, 15)
        .background(buttonType.color)
        .cornerRadius(4.0)
    }
}
