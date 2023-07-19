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

            return NftGeneratorClient.shared.caller()
                .flatMap { caller in caller.mintedToken(workId: archive.id) }
                .map { TokenBundle(erc721: $0.0, erc1155: $0.1) }
                .subscribe(on: environment.backgroundQueue)
                .receive(on: environment.mainQueue)
                .catchToEffect()
                .map(ArchiveDetailVM.Action.endInitialize)
        case .endInitialize(.success(let result)):
            state.erc721 = result.erc721
            state.erc1155 = result.erc1155
            state.shouldShowHUD = false
            state.initialized = true
            return .none
        case .endInitialize(.failure(let error)):
            state.shouldShowHUD = false
            state.isPresentedErrorAlert = true
            state.error = error
            return .none
        case .startRefresh:
            let archive = state.archive
            state.shouldPullToRefresh = true

            return NftGeneratorClient.shared.caller()
                .flatMap { caller in caller.mintedToken(workId: archive.id) }
                .map { TokenBundle(erc721: $0.0, erc1155: $0.1) }
                .subscribe(on: environment.backgroundQueue)
                .receive(on: environment.mainQueue)
                .catchToEffect()
                .map(ArchiveDetailVM.Action.endRefresh)
        case .endRefresh(.success(let result)):
            state.erc721 = result.erc721
            state.erc1155 = result.erc1155
            state.shouldPullToRefresh = false
            return .none
        case .endRefresh(.failure(let error)):
            state.shouldPullToRefresh = false
            state.isPresentedErrorAlert = true
            state.error = error
            return .none
        case .shouldShowHUD(let val):
            state.shouldShowHUD = val
            return .none
        case .shouldPullToRefresh(let val):
            state.shouldPullToRefresh = val
            return .none
        case .presentMintNftView(let data):
            state.selectFrame = data
            state.isPresentedMintNftView = true
            return .none
        case .isPresentedMintNftView(let val):
            state.isPresentedMintNftView = val
            return .none
        case .presentBulkMintNftView:
            state.isPresentedBulkMintNftView = true
            return .none
        case .isPresentedBulkMintNftView(let val):
            state.isPresentedBulkMintNftView = val
            return .none
        case .mintERC721(let input):
            guard let data = state.selectFrame else {
                return .none
            }

            let archive = state.archive
            state.shouldShowHUD = true

            return NftGeneratorClient.shared.caller()
                .flatMap { caller in caller.mintERC721(workId: archive.id, gsPath: data.imageGsPath).map { caller } }
                .flatMap { caller in caller.mintedToken(workId: archive.id) }
                .map { TokenBundle(erc721: $0.0, erc1155: $0.1) }
                .subscribe(on: environment.backgroundQueue)
                .receive(on: environment.mainQueue)
                .catchToEffect()
                .map(ArchiveDetailVM.Action.minted)
        case .mintERC1155(let input):
            guard let data = state.selectFrame else {
                return .none
            }

            let archive = state.archive
            state.shouldShowHUD = true

            return NftGeneratorClient.shared.caller()
                .flatMap { caller in caller.mintERC1155(workId: archive.id, gsPath: data.imageGsPath, amount: input.amount).map { caller } }
                .flatMap { caller in caller.mintedToken(workId: archive.id) }
                .map { TokenBundle(erc721: $0.0, erc1155: $0.1) }
                .subscribe(on: environment.backgroundQueue)
                .receive(on: environment.mainQueue)
                .catchToEffect()
                .map(ArchiveDetailVM.Action.minted)
        case .minted(.success(let result)):
            state.erc721 = result.erc721
            state.erc1155 = result.erc1155
            state.shouldShowHUD = false
            return .none
        case .minted(.failure(let error)):
            state.shouldShowHUD = false
            state.isPresentedErrorAlert = true
            state.error = error
            return .none
        case .bulkMintERC721(let input):
            let archive = state.archive
            state.shouldShowHUD = true

            return NftGeneratorClient.shared.caller()
                .flatMap { caller in caller.bulkMintERC721(workId: archive.id, ether: input.ether) }
                .map { true }
                .subscribe(on: environment.backgroundQueue)
                .receive(on: environment.mainQueue)
                .catchToEffect()
                .map(ArchiveDetailVM.Action.bulkMinted)
        case .bulkMintERC1155(let input):
            let archive = state.archive
            state.shouldShowHUD = true

            return NftGeneratorClient.shared.caller()
                .flatMap { caller in caller.bulkMintERC1155(workId: archive.id, amount: input.amount, ether: input.ether) }
                .map { true }
                .subscribe(on: environment.backgroundQueue)
                .receive(on: environment.mainQueue)
                .catchToEffect()
                .map(ArchiveDetailVM.Action.bulkMinted)
        case .bulkMinted(.success(_)):
            state.shouldShowHUD = false
            return .none
        case .bulkMinted(.failure(let error)):
            state.shouldShowHUD = false
            state.isPresentedErrorAlert = true
            state.error = error
            return .none
        case .presentSellNftView(let schema):
            switch schema {
            case .erc721:
                state.isPresentedERC721SellNftView = true
            case .erc1155:
                state.isPresentedERC1155SellNftView = true
            default:
                break
            }
            return .none
        case .isPresentedERC721SellNftView(let val):
            state.isPresentedERC721SellNftView = val
            return .none
        case .isPresentedERC1155SellNftView(let val):
            state.isPresentedERC1155SellNftView = val
            return .none
        case .sellERC721(let input):
            let archive = state.archive
            state.shouldShowHUD = true

            return NftGeneratorClient.shared.caller()
                .flatMap { caller in caller.sellERC721(workId: archive.id, ether: input.ether).map { _ in caller } }
                .flatMap { caller in caller.mintedToken(workId: archive.id) }
                .map { TokenBundle(erc721: $0.0, erc1155: $0.1) }
                .subscribe(on: environment.backgroundQueue)
                .receive(on: environment.mainQueue)
                .catchToEffect()
                .map(ArchiveDetailVM.Action.selled)
        case .sellERC1155(let input):
            let archive = state.archive
            state.shouldShowHUD = true

            return NftGeneratorClient.shared.caller()
                .flatMap { caller in caller.sellERC1155(workId: archive.id, ether: input.ether).map { _ in caller } }
                .flatMap { caller in caller.mintedToken(workId: archive.id) }
                .map { TokenBundle(erc721: $0.0, erc1155: $0.1) }
                .subscribe(on: environment.backgroundQueue)
                .receive(on: environment.mainQueue)
                .catchToEffect()
                .map(ArchiveDetailVM.Action.selled)
        case .selled(.success(let result)):
            state.erc721 = result.erc721
            state.erc1155 = result.erc1155
            state.shouldShowHUD = false
            return .none
        case .selled(.failure(let error)):
            state.shouldShowHUD = false
            state.isPresentedErrorAlert = true
            state.error = error
            return .none
        case .transferERC721(let input):
            let archive = state.archive
            state.shouldShowHUD = true

            return NftGeneratorClient.shared.caller()
                .flatMap { caller in caller.transferERC721(workId: archive.id, toAddress: input.toAddress).map { _ in caller } }
                .flatMap { caller in caller.mintedToken(workId: archive.id) }
                .map { TokenBundle(erc721: $0.0, erc1155: $0.1) }
                .subscribe(on: environment.backgroundQueue)
                .receive(on: environment.mainQueue)
                .catchToEffect()
                .map(ArchiveDetailVM.Action.transfered)
        case .transferERC1155(let input):
            let archive = state.archive
            state.shouldShowHUD = true

            return NftGeneratorClient.shared.caller()
                .flatMap { caller in caller.transferERC1155(workId: archive.id, toAddress: input.toAddress).map { _ in caller } }
                .flatMap { caller in caller.mintedToken(workId: archive.id) }
                .map { TokenBundle(erc721: $0.0, erc1155: $0.1) }
                .subscribe(on: environment.backgroundQueue)
                .receive(on: environment.mainQueue)
                .catchToEffect()
                .map(ArchiveDetailVM.Action.selled)
        case .transfered(.success(let result)):
            state.erc721 = result.erc721
            state.erc1155 = result.erc1155
            state.shouldShowHUD = false
            return .none
        case .transfered(.failure(let error)):
            state.shouldShowHUD = false
            state.isPresentedErrorAlert = true
            state.error = error
            return .none
        case .fetchFrames:
            let workId = state.archive.id
            return AssetGeneratorClient.shared.caller()
                .flatMap { caller in caller.framesByWork(workId: workId) }
                .subscribe(on: environment.backgroundQueue)
                .receive(on: environment.mainQueue)
                .catchToEffect()
                .map(ArchiveDetailVM.Action.frames)
        case .frames(.success(let frames)):
            state.frames = frames
            return .none
        case .frames(.failure(let error)):
            state.isPresentedErrorAlert = true
            state.error = error
            return .none
        case .isPresentedErrorAlert(let val):
            state.isPresentedErrorAlert = val
            if !val {
                state.error = nil
            }
            return .none
        }
    }
}

extension ArchiveDetailVM {
    enum Action: Equatable {
        case startInitialize
        case endInitialize(Result<TokenBundle, AppError>)
        case startRefresh
        case endRefresh(Result<TokenBundle, AppError>)
        case shouldShowHUD(Bool)
        case shouldPullToRefresh(Bool)
        case presentMintNftView(AssetGeneratorAPI.FrameFragment)
        case isPresentedMintNftView(Bool)
        case presentBulkMintNftView
        case isPresentedBulkMintNftView(Bool)
        case mintERC721(MintERC721Input)
        case mintERC1155(MintERC1155Input)
        case minted(Result<TokenBundle, AppError>)
        case bulkMintERC721(BulkMintERC721Input)
        case bulkMintERC1155(BulkMintERC1155Input)
        case bulkMinted(Result<Bool, AppError>)
        case presentSellNftView(NftGeneratorAPI.Schema)
        case isPresentedERC721SellNftView(Bool)
        case isPresentedERC1155SellNftView(Bool)
        case sellERC721(SellInput)
        case sellERC1155(SellInput)
        case selled(Result<TokenBundle, AppError>)
        case transferERC721(TransferInput)
        case transferERC1155(TransferInput)
        case transfered(Result<TokenBundle, AppError>)
        case fetchFrames
        case frames(Result<[AssetGeneratorAPI.FrameFragment], AppError>)
        case isPresentedErrorAlert(Bool)
    }

    struct State: Equatable {
        let archive: AssetGeneratorAPI.WorkFragment

        var frames: [AssetGeneratorAPI.FrameFragment] = []
        var initialized = false
        var shouldShowHUD = false
        var shouldPullToRefresh = false
        var erc721: NftGeneratorAPI.TokenFragment?
        var erc1155: NftGeneratorAPI.TokenFragment?
        var isPresentedMintNftView = false
        var isPresentedBulkMintNftView = false
        var selectFrame: AssetGeneratorAPI.FrameFragment? = nil
        var isPresentedERC721SellNftView = false
        var isPresentedERC1155SellNftView = false
        var isPresentedErrorAlert = false
        var error: AppError?
    }

    struct Environment {
        let mainQueue: AnySchedulerOf<DispatchQueue>
        let backgroundQueue: AnySchedulerOf<DispatchQueue>
    }
}

struct MintERC721Input: Equatable {}

struct MintERC1155Input: Equatable {
    let amount: Int
}

struct BulkMintERC721Input: Equatable {
    let ether: Double
}

struct BulkMintERC1155Input: Equatable {
    let amount: Int
    let ether: Double
}

struct SellInput: Equatable {
    let ether: Double
}

struct TransferInput: Equatable {
    let toAddress: String
}
