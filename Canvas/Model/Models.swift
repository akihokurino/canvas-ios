import Foundation

struct ArchivesWithHasNext: Equatable {
    let archives: [CanvasAPI.WorkFragment]
    let hasNext: Bool
}

struct ThumbnailsWithHasNext: Equatable {
    let thumbnails: [CanvasAPI.ThumbnailFragment]
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

struct Token: Equatable {
    let address: String
    let tokenId: String
    let imageUrl: String
}

struct TokenBundle: Equatable {
    let erc721: Token?
    let ownERC721: Bool
    let erc1155: Token?
    let ownERC1155: Bool
}

struct Wallet: Equatable {
    let address: String
    let balance: Double
}
