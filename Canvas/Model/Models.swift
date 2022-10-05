import Foundation

struct ArchivesWithHasNext: Equatable {
    let archives: [CanvasAPI.WorkFragment]
    let hasNext: Bool
}

struct FramesWithHasNext: Equatable {
    let frames: [CanvasAPI.FrameFragment]
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
