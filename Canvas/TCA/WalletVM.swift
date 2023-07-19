import Combine
import ComposableArchitecture
import Foundation

enum WalletVM {
    static let reducer = Reducer<State, Action, Environment> { state, action, environment in
        switch action {
        case .startInitialize:
            guard !state.initialized else {
                return .none
            }

            state.shouldShowHUD = true

            return NftGeneratorClient.shared.caller()
                .flatMap { caller in caller.wallet() }
                .map { Wallet(address: $0.address, balance: $0.balance) }
                .subscribe(on: environment.backgroundQueue)
                .receive(on: environment.mainQueue)
                .catchToEffect()
                .map(WalletVM.Action.endInitialize)
        case .endInitialize(.success(let result)):
            state.address = result.address
            state.balance = result.balance
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

            return NftGeneratorClient.shared.caller()
                .flatMap { caller in caller.wallet() }
                .map { result in Wallet(address: result.address, balance: result.balance) }
                .subscribe(on: environment.backgroundQueue)
                .receive(on: environment.mainQueue)
                .catchToEffect()
                .map(WalletVM.Action.endRefresh)
        case .endRefresh(.success(let result)):
            state.address = result.address
            state.balance = result.balance
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
        case .isPresentedErrorAlert(let val):
            state.isPresentedErrorAlert = val
            if !val {
                state.error = nil
            }
            return .none
        }
    }
}

extension WalletVM {
    enum Action: Equatable {
        case startInitialize
        case endInitialize(Result<Wallet, AppError>)
        case startRefresh
        case endRefresh(Result<Wallet, AppError>)
        case shouldShowHUD(Bool)
        case shouldPullToRefresh(Bool)
        case isPresentedErrorAlert(Bool)
    }

    struct State: Equatable {
        var initialized = false
        var shouldShowHUD = false
        var shouldPullToRefresh = false
        var address = ""
        var balance: Double = 0.0
        var isPresentedErrorAlert = false
        var error: AppError?
    }

    struct Environment {
        let mainQueue: AnySchedulerOf<DispatchQueue>
        let backgroundQueue: AnySchedulerOf<DispatchQueue>
    }
}
