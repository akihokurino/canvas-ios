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
        case .presentMintNftView(let data):
            state.selectThumbnail = data
            state.isPresentedMintNftView = true
            return .none
        case .isPresentedMintNftView(let val):
            state.isPresentedMintNftView = val
            return .none
        case .createERC721(let input):
            guard let data = state.selectThumbnail else {
                return .none
            }

            let archive = state.archive
            state.shouldShowHUD = true
            
            return NftClient.shared.caller()
                .flatMap { caller in caller.createERC721(workId: archive.id, gsPath: data.imageGsPath).map { caller } }
                .flatMap { caller in caller.getNftAssets(workId: archive.id).combineLatest(caller.isOwnNft(workId: archive.id)) }
                .map { AssetBundle(erc721: $0.0.erc721, ownERC721: $0.1.erc721, erc1155: $0.0.erc1155, ownERC1155: $0.1.erc1155) }
                .subscribe(on: environment.backgroundQueue)
                .receive(on: environment.mainQueue)
                .catchToEffect()
                .map(ArchiveDetailVM.Action.created)
        case .createERC1155(let input):
            guard let data = state.selectThumbnail else {
                return .none
            }

            let archive = state.archive
            state.shouldShowHUD = true

            return NftClient.shared.caller()
                .flatMap { caller in caller.createERC1155(workId: archive.id, gsPath: data.imageGsPath, amount: input.amount).map { caller } }
                .flatMap { caller in caller.getNftAssets(workId: archive.id).combineLatest(caller.isOwnNft(workId: archive.id)) }
                .map { AssetBundle(erc721: $0.0.erc721, ownERC721: $0.1.erc721, erc1155: $0.0.erc1155, ownERC1155: $0.1.erc1155) }
                .subscribe(on: environment.backgroundQueue)
                .receive(on: environment.mainQueue)
                .catchToEffect()
                .map(ArchiveDetailVM.Action.created)
        case .created(.success(let result)):
            state.erc721 = result.erc721
            state.ownERC721 = result.ownERC721
            state.erc1155 = result.erc1155
            state.ownERC1155 = result.ownERC1155
            state.shouldShowHUD = false
            return .none
        case .created(.failure(_)):
            state.shouldShowHUD = false
            return .none
        case .presentNftView(let type):
            state.selectNftType = type
            switch type {
            case .ERC721:
                state.isPresentedERC721NftView = true
            case .ERC1155:
                state.isPresentedERC1155NftView = true
            }
            return .none
        case .isPresentedERC721NftView(let val):
            state.isPresentedERC721NftView = val
            return .none
        case .isPresentedERC1155NftView(let val):
            state.isPresentedERC1155NftView = val
            return .none
        case .sellERC721(let input):
            let archive = state.archive
            state.shouldShowHUD = true

            return NftClient.shared.caller()
                .flatMap { caller in caller.sellERC721(workId: archive.id, ether: input.ether) }
                .map { _ in true }
                .subscribe(on: environment.backgroundQueue)
                .receive(on: environment.mainQueue)
                .catchToEffect()
                .map(ArchiveDetailVM.Action.selled)
        case .sellERC1155(let input):
            let archive = state.archive
            state.shouldShowHUD = true

            return NftClient.shared.caller()
                .flatMap { caller in caller.sellERC1155(workId: archive.id, ether: input.ether) }
                .map { _ in true }
                .subscribe(on: environment.backgroundQueue)
                .receive(on: environment.mainQueue)
                .catchToEffect()
                .map(ArchiveDetailVM.Action.selled)
        case .selled(.success(_)):
            state.shouldShowHUD = false
            return .none
        case .selled(.failure(_)):
            state.shouldShowHUD = false
            return .none
        case .transferERC721(let input):
            let archive = state.archive
            state.shouldShowHUD = true

            return NftClient.shared.caller()
                .flatMap { caller in caller.transferERC721(workId: archive.id, toAddress: input.toAddress) }
                .map { _ in true }
                .subscribe(on: environment.backgroundQueue)
                .receive(on: environment.mainQueue)
                .catchToEffect()
                .map(ArchiveDetailVM.Action.transfered)
        case .transferERC1155(let input):
            let archive = state.archive
            state.shouldShowHUD = true

            return NftClient.shared.caller()
                .flatMap { caller in caller.transferERC1155(workId: archive.id, toAddress: input.toAddress) }
                .map { _ in true }
                .subscribe(on: environment.backgroundQueue)
                .receive(on: environment.mainQueue)
                .catchToEffect()
                .map(ArchiveDetailVM.Action.selled)
        case .transfered(.success(_)):
            state.shouldShowHUD = false
            return .none
        case .transfered(.failure(_)):
            state.shouldShowHUD = false
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
        case presentMintNftView(CanvasAPI.WorkFragment.Thumbnail)
        case isPresentedMintNftView(Bool)
        case createERC721(CreateERC721Input)
        case createERC1155(CreateERC1155Input)
        case created(Result<AssetBundle, AppError>)
        case presentNftView(NftType)
        case isPresentedERC721NftView(Bool)
        case isPresentedERC1155NftView(Bool)
        case sellERC721(SellInput)
        case sellERC1155(SellInput)
        case selled(Result<Bool, AppError>)
        case transferERC721(TransferInput)
        case transferERC1155(TransferInput)
        case transfered(Result<Bool, AppError>)
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
        var isPresentedMintNftView = false
        var selectThumbnail: CanvasAPI.WorkFragment.Thumbnail? = nil
        var isPresentedERC721NftView = false
        var isPresentedERC1155NftView = false
        var selectNftType: NftType? = nil
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

struct CreateERC721Input: Equatable {}

struct CreateERC1155Input: Equatable {
    let amount: Int
}

struct SellInput: Equatable {
    let ether: Double
}

struct TransferInput: Equatable {
    let toAddress: String
}
