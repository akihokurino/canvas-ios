import Foundation

enum AppError: Error, Equatable {
    case plain(String)
    
    static func defaultError() -> AppError {
        return .plain("エラーが発生しました")
    }
}
