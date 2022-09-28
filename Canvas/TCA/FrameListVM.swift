import Combine
import ComposableArchitecture
import Foundation

enum FrameListVM {
    static let reducer = Reducer<State, Action, Environment> { state, action, environment in
        switch action {
        case .startInitialize:
            guard !state.initialized else {
                return .none
            }

            state.shouldShowHUD = true
            state.page = 1
            state.hasNext = false

            let page = state.page

            return CanvasClient.shared.caller()
                .flatMap { caller in caller.frames(page: page) }
                .map { FramesWithHasNext(frames: $0.0, hasNext: $0.1) }
                .subscribe(on: environment.backgroundQueue)
                .receive(on: environment.mainQueue)
                .catchToEffect()
                .map(FrameListVM.Action.endInitialize)
        case .endInitialize(.success(let result)):
            state.frames = result.frames
            state.hasNext = result.hasNext
            state.shouldShowHUD = false

            state.initialized = true

            return .none
        case .endInitialize(.failure(_)):
            state.shouldShowHUD = false
            return .none
        case .startRefresh:
            state.shouldPullToRefresh = true
            state.page = 1
            state.hasNext = false

            let page = state.page

            return CanvasClient.shared.caller()
                .flatMap { caller in caller.frames(page: page) }
                .map { FramesWithHasNext(frames: $0.0, hasNext: $0.1) }
                .subscribe(on: environment.backgroundQueue)
                .receive(on: environment.mainQueue)
                .catchToEffect()
                .map(FrameListVM.Action.endRefresh)
        case .endRefresh(.success(let result)):
            state.frames = result.frames
            state.hasNext = result.hasNext
            state.shouldPullToRefresh = false
            return .none
        case .endRefresh(.failure(_)):
            state.shouldPullToRefresh = false
            return .none
        case .startNext:
            guard !state.shouldShowNextLoading, state.hasNext else {
                return .none
            }

            state.shouldShowNextLoading = true
            state.hasNext = false
            state.page += 1

            let page = state.page

            return CanvasClient.shared.caller()
                .flatMap { caller in caller.frames(page: page) }
                .map { FramesWithHasNext(frames: $0.0, hasNext: $0.1) }
                .subscribe(on: environment.backgroundQueue)
                .receive(on: environment.mainQueue)
                .catchToEffect()
                .map(FrameListVM.Action.endNext)
        case .endNext(.success(let result)):
            state.frames.append(contentsOf: result.frames)
            state.hasNext = result.hasNext
            state.shouldShowNextLoading = false
            return .none
        case .endNext(.failure(_)):
            state.shouldShowNextLoading = false
            return .none
        case .shouldShowHUD(let val):
            state.shouldShowHUD = val
            return .none
        case .shouldPullToRefresh(let val):
            state.shouldPullToRefresh = val
            return .none
        case .presentDetailView(let data):
            guard state.initialized else {
                return .none
            }
            
            state.selectFrame = data
            state.isPresentedDetailView = true
            return .none
        case .isPresentedDetailView(let val):
            state.isPresentedDetailView = val
            return .none
        }
    }
}

extension FrameListVM {
    enum Action: Equatable {
        case startInitialize
        case endInitialize(Result<FramesWithHasNext, AppError>)
        case startRefresh
        case endRefresh(Result<FramesWithHasNext, AppError>)
        case startNext
        case endNext(Result<FramesWithHasNext, AppError>)
        case shouldShowHUD(Bool)
        case shouldPullToRefresh(Bool)
        case presentDetailView(CanvasAPI.FrameFragment)
        case isPresentedDetailView(Bool)
    }

    struct State: Equatable {
        var initialized = false
        var shouldShowHUD = false
        var shouldPullToRefresh = false
        var shouldShowNextLoading = false
        var page = 1
        var hasNext = false
        var isPresentedDetailView = false
        var frames: [CanvasAPI.FrameFragment] = []
        var selectFrame: CanvasAPI.FrameFragment? = nil
    }

    struct Environment {
        let mainQueue: AnySchedulerOf<DispatchQueue>
        let backgroundQueue: AnySchedulerOf<DispatchQueue>
    }
}
