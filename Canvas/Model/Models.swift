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
    let contracts: [NftAPI.ContractFragment]
    let cursor: String?
}

struct TokensWithCursor: Equatable {
    let tokens: [NftAPI.TokenFragment]
    let cursor: String?
}

struct TokenBundle: Equatable {
    let erc721: NftAPI.TokenFragment?
    let erc1155: NftAPI.TokenFragment?
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

