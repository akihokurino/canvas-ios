import Foundation

enum AppError: Error {
    case plain(String)
    case wrap(Error)
    
    static func defaultError() -> AppError {
        return .plain("エラーが発生しました")
    }
}
