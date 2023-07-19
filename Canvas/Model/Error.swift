import Foundation

struct ErrorAlertEntity {
    let title: String
    let message: String
}

enum AppError: Error, Equatable {
    case plain(String)

    static func defaultError() -> AppError {
        return .plain("internal error")
    }
    
    var alert: ErrorAlertEntity {
        switch self {
        case .plain(let message):
            return ErrorAlertEntity(title: "", message: message)
        }
    }
}
