import Foundation
import SwiftUIPager

struct ArchivesWithHasNext: Equatable {
    let archives: [AssetGeneratorAPI.WorkFragment]
    let hasNext: Bool
}

struct FramesWithHasNext: Equatable {
    let frames: [AssetGeneratorAPI.FrameFragment]
    let hasNext: Bool
}

struct ContractsWithCursor: Equatable {
    let contracts: [NftGeneratorAPI.ContractFragment]
    let cursor: String?
    let hasNext: Bool
}

struct TokensWithCursor: Equatable {
    let tokens: [NftGeneratorAPI.TokenFragment]
    let cursor: String?
    let hasNext: Bool
}

struct Wallet: Equatable {
    let address: String
    let balance: Double
}

extension Page: Equatable, Hashable {
    public static func == (lhs: SwiftUIPager.Page, rhs: SwiftUIPager.Page) -> Bool {
        return lhs.index == rhs.index
    }

    public func hash(into hasher: inout Hasher) {}
}

