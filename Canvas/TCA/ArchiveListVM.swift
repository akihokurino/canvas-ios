import Combine
import ComposableArchitecture
import Foundation

enum ArchiveListVM {
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

            return AssetGeneratorClient.shared.caller()
                .flatMap { caller in caller.works(page: page) }
                .map { ArchivesWithHasNext(archives: $0.0, hasNext: $0.1) }
                .subscribe(on: environment.backgroundQueue)
                .receive(on: environment.mainQueue)
                .catchToEffect()
                .map(ArchiveListVM.Action.endInitialize)
        case .endInitialize(.success(let result)):
            state.archives = result.archives
            state.hasNext = result.hasNext
            state.shouldShowHUD = false

            state.initialized = true

            return .none
        case .endInitialize(.failure(let error)):
            state.shouldShowHUD = false
            state.isPresentedErrorAlert = true
            state.error = error
            return .none
        case .startRefresh:
            state.shouldPullToRefresh = true
            state.page = 1
            state.hasNext = false

            let page = state.page

            return AssetGeneratorClient.shared.caller()
                .flatMap { caller in caller.works(page: page) }
                .map { ArchivesWithHasNext(archives: $0.0, hasNext: $0.1) }
                .subscribe(on: environment.backgroundQueue)
                .receive(on: environment.mainQueue)
                .catchToEffect()
                .map(ArchiveListVM.Action.endRefresh)
        case .endRefresh(.success(let result)):
            state.archives = result.archives
            state.hasNext = result.hasNext
            state.shouldPullToRefresh = false
            return .none
        case .endRefresh(.failure(let error)):
            state.shouldPullToRefresh = false
            state.isPresentedErrorAlert = true
            state.error = error
            return .none
        case .startFetchNextArchive:
            guard !state.shouldShowNextLoading, state.hasNext else {
                return .none
            }

            state.shouldShowNextLoading = true
            state.hasNext = false
            state.page += 1

            let page = state.page

            return AssetGeneratorClient.shared.caller()
                .flatMap { caller in caller.works(page: page) }
                .map { ArchivesWithHasNext(archives: $0.0, hasNext: $0.1) }
                .subscribe(on: environment.backgroundQueue)
                .receive(on: environment.mainQueue)
                .catchToEffect()
                .map(ArchiveListVM.Action.endFetchNextArchive)
        case .endFetchNextArchive(.success(let result)):
            state.archives.append(contentsOf: result.archives)
            state.hasNext = result.hasNext
            state.shouldShowNextLoading = false
            return .none
        case .endFetchNextArchive(.failure(let error)):
            state.shouldShowNextLoading = false
            state.isPresentedErrorAlert = true
            state.error = error
            return .none
        case .shouldShowHUD(let val):
            state.shouldShowHUD = val
            return .none
        case .shouldPullToRefresh(let val):
            state.shouldPullToRefresh = val
            return .none
        case .presentDetailView(let data):
            state.archiveDetailView = ArchiveDetailVM.State(archive: data)
            return .none
        case .popDetailView:
            state.archiveDetailView = nil
            return .none
        case .isPresentedErrorAlert(let val):
            state.isPresentedErrorAlert = val
            if !val {
                state.error = nil
            }
            return .none

        case .archiveDetailView(let action):
            return .none
        }
    }
    .connect(
        ArchiveDetailVM.reducer,
        state: \.archiveDetailView,
        action: /ArchiveListVM.Action.archiveDetailView,
        environment: { _environment in
            ArchiveDetailVM.Environment(
                mainQueue: _environment.mainQueue,
                backgroundQueue: _environment.backgroundQueue
            )
        }
    )
}

extension ArchiveListVM {
    enum Action: Equatable {
        case startInitialize
        case endInitialize(Result<ArchivesWithHasNext, AppError>)
        case startRefresh
        case endRefresh(Result<ArchivesWithHasNext, AppError>)
        case startFetchNextArchive
        case endFetchNextArchive(Result<ArchivesWithHasNext, AppError>)
        case shouldShowHUD(Bool)
        case shouldPullToRefresh(Bool)
        case presentDetailView(AssetGeneratorAPI.WorkFragment)
        case popDetailView
        case isPresentedErrorAlert(Bool)

        case archiveDetailView(ArchiveDetailVM.Action)
    }

    struct State: Equatable {
        var initialized = false
        var shouldShowHUD = false
        var shouldPullToRefresh = false
        var shouldShowNextLoading = false
        var page = 1
        var hasNext = false
        var archives: [AssetGeneratorAPI.WorkFragment] = []
        var isPresentedErrorAlert = false
        var error: AppError?

        var archiveDetailView: ArchiveDetailVM.State?
    }

    struct Environment {
        let mainQueue: AnySchedulerOf<DispatchQueue>
        let backgroundQueue: AnySchedulerOf<DispatchQueue>
    }
}
