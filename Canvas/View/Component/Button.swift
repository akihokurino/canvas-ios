import SwiftUI

enum ActionButtonColor {
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
    let background: ActionButtonColor
    let action: () -> Void

    init(text: String, background: ActionButtonColor, action: @escaping () -> Void) {
        self.text = text
        self.background = background
        self.action = action
    }

    var body: some View {
        Button(action: {
            guard background != .disable else {
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
        .padding(.horizontal, 15)
        .padding(.vertical, 15)
        .background(background.color)
        .cornerRadius(4.0)
    }
}
