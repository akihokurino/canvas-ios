import Combine
import ComposableArchitecture
import Foundation

enum ArchiveDetailVM {
    static let reducer = Reducer<State, Action, Environment> { state, action, environment in
        switch action {
        case .startInitialize:
            guard !state.initialized else {
                return .none
            }

            let archive = state.archive
            state.shouldShowHUD = true

            return NftClient.shared.caller()
                .flatMap { caller in caller.getNftAssets(workId: archive.id).combineLatest(caller.isOwnNft(workId: archive.id)) }
                .map { AssetBundle(erc721: $0.0.erc721, ownERC721: $0.1.erc721, erc1155: $0.0.erc1155, ownERC1155: $0.1.erc1155) }
                .subscribe(on: environment.backgroundQueue)
                .receive(on: environment.mainQueue)
                .catchToEffect()
                .map(ArchiveDetailVM.Action.endInitialize)
        case .endInitialize(.success(let result)):
            state.erc721 = result.erc721
            state.ownERC721 = result.ownERC721
            state.erc1155 = result.erc1155
            state.ownERC1155 = result.ownERC1155
            state.shouldShowHUD = false

            state.initialized = true

            return .none
        case .endInitialize(.failure(_)):
            state.shouldShowHUD = false
            return .none
        case .startRefresh:
            let archive = state.archive
            state.shouldPullToRefresh = true

            return NftClient.shared.caller()
                .flatMap { caller in caller.getNftAssets(workId: archive.id).combineLatest(caller.isOwnNft(workId: archive.id)) }
                .map { AssetBundle(erc721: $0.0.erc721, ownERC721: $0.1.erc721, erc1155: $0.0.erc1155, ownERC1155: $0.1.erc1155) }
                .subscribe(on: environment.backgroundQueue)
                .receive(on: environment.mainQueue)
                .catchToEffect()
                .map(ArchiveDetailVM.Action.endRefresh)
        case .endRefresh(.success(let result)):
            state.erc721 = result.erc721
            state.ownERC721 = result.ownERC721
            state.erc1155 = result.erc1155
            state.ownERC1155 = result.ownERC1155
            state.shouldPullToRefresh = false
            return .none
        case .endRefresh(.failure(_)):
            state.shouldPullToRefresh = false
            return .none
        case .shouldShowHUD(let val):
            state.shouldShowHUD = val
            return .none
        case .shouldPullToRefresh(let val):
            state.shouldPullToRefresh = val
            return .none
        }
    }
}

extension ArchiveDetailVM {
    enum Action: Equatable {
        case startInitialize
        case endInitialize(Result<AssetBundle, AppError>)
        case startRefresh
        case endRefresh(Result<AssetBundle, AppError>)
        case shouldShowHUD(Bool)
        case shouldPullToRefresh(Bool)
    }

    struct State: Equatable {
        let archive: CanvasAPI.WorkFragment

        var initialized = false
        var shouldShowHUD = false
        var shouldPullToRefresh = false
        var ownERC721: Bool = false
        var erc721: Asset?
        var ownERC1155: Bool = false
        var erc1155: Asset?
    }

    struct Environment {
        let mainQueue: AnySchedulerOf<DispatchQueue>
        let backgroundQueue: AnySchedulerOf<DispatchQueue>
    }
}

enum NftType {
    case ERC721
    case ERC1155
}

struct Asset: Equatable {
    let address: String
    let tokenId: String
    let imageUrl: String
}

struct AssetBundle: Equatable {
    let erc721: Asset?
    let ownERC721: Bool
    let erc1155: Asset?
    let ownERC1155: Bool
}
