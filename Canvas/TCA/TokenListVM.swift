import Combine
import ComposableArchitecture
import Foundation

enum TokenListVM {
    static let reducer = Reducer<State, Action, Environment> { state, action, environment in
        switch action {
        case .startInitialize:
            guard !state.initialized else {
                return .none
            }

            state.shouldShowHUD = true
            state.cursor = nil

            let address = state.contract.address
            let cursor = state.cursor

            return NftClient.shared.caller()
                .flatMap { caller in caller.tokens(address: address, cursor: cursor) }
                .map { TokensWithCursor(tokens: $0.0, cursor: $0.1) }
                .subscribe(on: environment.backgroundQueue)
                .receive(on: environment.mainQueue)
                .catchToEffect()
                .map(TokenListVM.Action.endInitialize)
        case .endInitialize(.success(let result)):
            state.tokens = result.tokens
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

            let address = state.contract.address
            let cursor = state.cursor

            return NftClient.shared.caller()
                .flatMap { caller in caller.tokens(address: address, cursor: cursor) }
                .map { TokensWithCursor(tokens: $0.0, cursor: $0.1) }
                .subscribe(on: environment.backgroundQueue)
                .receive(on: environment.mainQueue)
                .catchToEffect()
                .map(TokenListVM.Action.endRefresh)
        case .endRefresh(.success(let result)):
            state.tokens = result.tokens
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

            let address = state.contract.address
            let cursor = state.cursor

            return NftClient.shared.caller()
                .flatMap { caller in caller.tokens(address: address, cursor: cursor) }
                .map { TokensWithCursor(tokens: $0.0, cursor: $0.1) }
                .subscribe(on: environment.backgroundQueue)
                .receive(on: environment.mainQueue)
                .catchToEffect()
                .map(TokenListVM.Action.endNext)
        case .endNext(.success(let result)):
            state.tokens.append(contentsOf: result.tokens)
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
        case .presentSellNftView(let token):
            return .none
        }
    }
}

extension TokenListVM {
    enum Action: Equatable {
        case startInitialize
        case endInitialize(Result<TokensWithCursor, AppError>)
        case startRefresh
        case endRefresh(Result<TokensWithCursor, AppError>)
        case startNext
        case endNext(Result<TokensWithCursor, AppError>)
        case shouldShowHUD(Bool)
        case shouldPullToRefresh(Bool)
        case presentSellNftView(NftAPI.TokenFragment)
    }

    struct State: Equatable {
        let contract: NftAPI.ContractFragment

        var initialized = false
        var shouldShowHUD = false
        var shouldPullToRefresh = false
        var shouldShowNextLoading = false
        var cursor: String? = nil
        var tokens: [NftAPI.TokenFragment] = []
        var hasNext: Bool {
            cursor != ""
        }
    }

    struct Environment {
        let mainQueue: AnySchedulerOf<DispatchQueue>
        let backgroundQueue: AnySchedulerOf<DispatchQueue>
    }
}
