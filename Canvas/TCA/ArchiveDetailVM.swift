import Combine
import ComposableArchitecture
import Foundation

enum ArchiveDetailVM {
    static let reducer = Reducer<State, Action, Environment> { state, action, environment in
        switch action {
        case .startInitialize:
            let workId = state.archive.id
            return AssetGeneratorClient.shared.caller()
                .flatMap { caller in caller.framesByWork(workId: workId) }
                .subscribe(on: environment.backgroundQueue)
                .receive(on: environment.mainQueue)
                .catchToEffect()
                .map(ArchiveDetailVM.Action.endInitialize)
        case .endInitialize(.success(let frames)):
            state.frames = frames
            return .none
        case .endInitialize(.failure(let error)):
            state.isPresentedErrorAlert = true
            state.error = error
            return .none
        case .startRefresh:
            state.shouldPullToRefresh = true

            let workId = state.archive.id
            return AssetGeneratorClient.shared.caller()
                .flatMap { caller in caller.framesByWork(workId: workId) }
                .subscribe(on: environment.backgroundQueue)
                .receive(on: environment.mainQueue)
                .catchToEffect()
                .map(ArchiveDetailVM.Action.endRefresh)
        case .endRefresh(.success(let frames)):
            state.frames = frames
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
        case .mint(let input):
            guard let data = state.selectFrame else {
                return .none
            }

            let archive = state.archive
            state.shouldShowHUD = true

            return NftGeneratorClient.shared.caller()
                .flatMap { caller in caller.mint(workId: archive.id, gsPath: data.imageGsPath).map { caller } }
                .map { _ in true }
                .subscribe(on: environment.backgroundQueue)
                .receive(on: environment.mainQueue)
                .catchToEffect()
                .map(ArchiveDetailVM.Action.minted)
        case .minted(.success(_)):
            state.shouldShowHUD = false
            return .none
        case .minted(.failure(let error)):
            state.shouldShowHUD = false
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
        case endInitialize(Result<[AssetGeneratorAPI.FrameFragment], AppError>)
        case startRefresh
        case endRefresh(Result<[AssetGeneratorAPI.FrameFragment], AppError>)
        case shouldShowHUD(Bool)
        case shouldPullToRefresh(Bool)
        case presentMintNftView(AssetGeneratorAPI.FrameFragment)
        case isPresentedMintNftView(Bool)
        case mint(MintInput)
        case minted(Result<Bool, AppError>)
        case isPresentedErrorAlert(Bool)
    }

    struct State: Equatable {
        let archive: AssetGeneratorAPI.WorkFragment

        var frames: [AssetGeneratorAPI.FrameFragment] = []
        var initialized = false
        var shouldShowHUD = false
        var shouldPullToRefresh = false
        var isPresentedMintNftView = false
        var selectFrame: AssetGeneratorAPI.FrameFragment? = nil
        var isPresentedErrorAlert = false
        var error: AppError?
    }

    struct Environment {
        let mainQueue: AnySchedulerOf<DispatchQueue>
        let backgroundQueue: AnySchedulerOf<DispatchQueue>
    }
}

struct MintInput: Equatable {}
