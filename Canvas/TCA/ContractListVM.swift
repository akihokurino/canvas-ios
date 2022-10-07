import Combine
import ComposableArchitecture
import Foundation

enum ContractListVM {
    static let reducer = Reducer<State, Action, Environment> { state, action, environment in
        switch action {
        case .startInitialize:
            guard !state.initialized else {
                return .none
            }

            state.shouldShowHUD = true
            state.cursor = nil

            let cursor = state.cursor

            return NftClient.shared.caller()
                .flatMap { caller in caller.contracts(cursor: cursor) }
                .map { ContractsWithCursor(contracts: $0.0, cursor: $0.1) }
                .subscribe(on: environment.backgroundQueue)
                .receive(on: environment.mainQueue)
                .catchToEffect()
                .map(ContractListVM.Action.endInitialize)
        case .endInitialize(.success(let result)):
            state.contracts = result.contracts
            state.cursor = result.cursor
            state.shouldShowHUD = false

            state.initialized = true

            return .none
        case .endInitialize(.failure(_)):
            state.shouldShowHUD = false
            return .none
        case .startRefresh:
            state.shouldPullToRefresh = true
            state.cursor = nil

            let cursor = state.cursor

            return NftClient.shared.caller()
                .flatMap { caller in caller.contracts(cursor: cursor) }
                .map { ContractsWithCursor(contracts: $0.0, cursor: $0.1) }
                .subscribe(on: environment.backgroundQueue)
                .receive(on: environment.mainQueue)
                .catchToEffect()
                .map(ContractListVM.Action.endRefresh)
        case .endRefresh(.success(let result)):
            state.contracts = result.contracts
            state.cursor = result.cursor
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

            let cursor = state.cursor

            return NftClient.shared.caller()
                .flatMap { caller in caller.contracts(cursor: cursor) }
                .map { ContractsWithCursor(contracts: $0.0, cursor: $0.1) }
                .subscribe(on: environment.backgroundQueue)
                .receive(on: environment.mainQueue)
                .catchToEffect()
                .map(ContractListVM.Action.endNext)
        case .endNext(.success(let result)):
            state.contracts.append(contentsOf: result.contracts)
            state.cursor = result.cursor
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
            state.contractDetailView = ContractDetailVM.State(
                contract: data,
                tokenListView: TokenListVM.State(contract: data),
                multiTokenListView: MultiTokenListVM.State(contract: data)
            )
            return .none
        case .popDetailView:
            state.contractDetailView = nil
            return .none
        case .startSyncAllTokens:
            state.shouldShowHUD = true

            return NftClient.shared.caller()
                .flatMap { caller in caller.syncAllTokens() }
                .map { true }
                .subscribe(on: environment.backgroundQueue)
                .receive(on: environment.mainQueue)
                .catchToEffect()
                .map(ContractListVM.Action.endSyncAllTokens)
        case .endSyncAllTokens(.success(_)):
            state.shouldShowHUD = false
            return .none
        case .endSyncAllTokens(.failure(_)):
            state.shouldShowHUD = false
            return .none

        case .contractDetailView(let action):
            return .none
        }
    }
    .connect(
        ContractDetailVM.reducer,
        state: \.contractDetailView,
        action: /ContractListVM.Action.contractDetailView,
        environment: { _environment in
            ContractDetailVM.Environment(
                mainQueue: _environment.mainQueue,
                backgroundQueue: _environment.backgroundQueue
            )
        }
    )
}

extension ContractListVM {
    enum Action: Equatable {
        case startInitialize
        case endInitialize(Result<ContractsWithCursor, AppError>)
        case startRefresh
        case endRefresh(Result<ContractsWithCursor, AppError>)
        case startNext
        case endNext(Result<ContractsWithCursor, AppError>)
        case shouldShowHUD(Bool)
        case shouldPullToRefresh(Bool)
        case presentDetailView(NftAPI.ContractFragment)
        case popDetailView
        case startSyncAllTokens
        case endSyncAllTokens(Result<Bool, AppError>)

        case contractDetailView(ContractDetailVM.Action)
    }

    struct State: Equatable {
        var initialized = false
        var shouldShowHUD = false
        var shouldPullToRefresh = false
        var shouldShowNextLoading = false
        var cursor: String? = nil
        var contracts: [NftAPI.ContractFragment] = []
        var hasNext: Bool {
            cursor != ""
        }

        var contractDetailView: ContractDetailVM.State?
    }

    struct Environment {
        let mainQueue: AnySchedulerOf<DispatchQueue>
        let backgroundQueue: AnySchedulerOf<DispatchQueue>
    }
}
