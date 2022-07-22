import Combine
import ComposableArchitecture
import Foundation

struct Wallet: Equatable {
    let address: String
    let balance: Double
}

enum WalletVM {
    static let reducer = Reducer<State, Action, Environment> { state, action, environment in
        switch action {
        case .startInitialize:
            guard !state.initialized else {
                return .none
            }
            
            state.shouldShowHUD = true

            return NftClient.shared.caller()
                .flatMap { caller in caller.getWallet() }
                .map { Wallet(address: $0.address, balance: $0.balance) }
                .subscribe(on: environment.backgroundQueue)
                .receive(on: environment.mainQueue)
                .catchToEffect()
                .map(WalletVM.Action.endInitialize)
        case .endInitialize(.success(let wallet)):
            state.address = wallet.address
            state.balance = wallet.balance
            state.initialized = true
            state.shouldShowHUD = false
            return .none
        case .endInitialize(.failure(_)):
            state.shouldShowHUD = false
            return .none
        case .startRefresh:
            state.shouldPullToRefresh = true

            return NftClient.shared.caller()
                .flatMap { caller in caller.getWallet() }
                .map { result in Wallet(address: result.address, balance: result.balance) }
                .subscribe(on: environment.backgroundQueue)
                .receive(on: environment.mainQueue)
                .catchToEffect()
                .map(WalletVM.Action.endRefresh)
        case .endRefresh(.success(let wallet)):
            state.address = wallet.address
            state.balance = wallet.balance
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

extension WalletVM {
    enum Action: Equatable {
        case startInitialize
        case endInitialize(Result<Wallet, AppError>)
        case startRefresh
        case endRefresh(Result<Wallet, AppError>)
        case shouldShowHUD(Bool)
        case shouldPullToRefresh(Bool)
    }

    struct State: Equatable {
        var initialized = false
        var shouldShowHUD = false
        var shouldPullToRefresh = false
        
        var address = ""
        var balance: Double = 0.0
    }

    struct Environment {
        let mainQueue: AnySchedulerOf<DispatchQueue>
        let backgroundQueue: AnySchedulerOf<DispatchQueue>
    }
}
