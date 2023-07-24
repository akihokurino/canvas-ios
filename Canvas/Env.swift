import Foundation

enum Env {
    static let walletSecret = Bundle.main.object(forInfoDictionaryKey: "Wallet Secret") as! String
    static let internalToken = Bundle.main.object(forInfoDictionaryKey: "Internal Token") as! String
    static let infuraKey = Bundle.main.object(forInfoDictionaryKey: "Infura Key") as! String
}
