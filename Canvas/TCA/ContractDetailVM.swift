import Combine
import ComposableArchitecture
import Foundation
import SwiftUIPager

enum ContractDetailVM {
    static let reducer = Reducer<State, Action, Environment> { state, action, environment in
        switch action {
        case .startInitialize:
            guard !state.initialized else {
                return .none
            }

            state.shouldShowHUD = true
            state.cursor = nil
            state.hasNext = false

            let address = state.contract.address
            let cursor = state.cursor

            return NftGeneratorClient.shared.caller()
                .flatMap { caller in caller.tokens(address: address, cursor: cursor) }
                .map { TokensWithCursor(tokens: $0.0, cursor: $0.1, hasNext: $0.2) }
                .subscribe(on: environment.backgroundQueue)
                .receive(on: environment.mainQueue)
                .catchToEffect()
                .map(ContractDetailVM.Action.endInitialize)
        case .endInitialize(.success(let result)):
            state.tokens = result.tokens
            state.cursor = result.cursor
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
            state.cursor = nil
            state.hasNext = false

            let address = state.contract.address
            let cursor = state.cursor

            return NftGeneratorClient.shared.caller()
                .flatMap { caller in caller.tokens(address: address, cursor: cursor) }
                .map { TokensWithCursor(tokens: $0.0, cursor: $0.1, hasNext: $0.2) }
                .subscribe(on: environment.backgroundQueue)
                .receive(on: environment.mainQueue)
                .catchToEffect()
                .map(ContractDetailVM.Action.endRefresh)
        case .endRefresh(.success(let result)):
            state.tokens = result.tokens
            state.cursor = result.cursor
            state.hasNext = result.hasNext
            state.shouldPullToRefresh = false
            return .none
        case .endRefresh(.failure(let error)):
            state.shouldPullToRefresh = false
            state.isPresentedErrorAlert = true
            state.error = error
            return .none
        case .startNext:
            guard !state.shouldShowNextLoading, state.hasNext else {
                return .none
            }

            state.shouldShowNextLoading = true
            state.hasNext = false

            let address = state.contract.address
            let cursor = state.cursor

            return NftGeneratorClient.shared.caller()
                .flatMap { caller in caller.tokens(address: address, cursor: cursor) }
                .map { TokensWithCursor(tokens: $0.0, cursor: $0.1, hasNext: $0.2) }
                .subscribe(on: environment.backgroundQueue)
                .receive(on: environment.mainQueue)
                .catchToEffect()
                .map(ContractDetailVM.Action.endNext)
        case .endNext(.success(let result)):
            state.tokens.append(contentsOf: result.tokens)
            state.cursor = result.cursor
            state.hasNext = result.hasNext
            state.shouldShowNextLoading = false
            return .none
        case .endNext(.failure(let error)):
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
        case .isPresentedSellNftView(let val):
            state.isPresentedSellNftView = val
            return .none
        case .sell(let input):
            guard let token = state.selectToken else {
                return .none
            }
            state.shouldShowHUD = true

            return NftGeneratorClient.shared.caller()
                .flatMap { caller in caller.sell(address: token.address, tokenId: token.tokenId, ether: input.ether) }
                .subscribe(on: environment.backgroundQueue)
                .map { _ in true }
                .receive(on: environment.mainQueue)
                .catchToEffect()
                .map(ContractDetailVM.Action.selled)
        case .selled(.success(_)):
            state.shouldShowHUD = false
            return .none
        case .selled(.failure(let error)):
            state.shouldShowHUD = false
            state.isPresentedErrorAlert = true
            state.error = error
            return .none
        case .transfer(let input):
            guard let token = state.selectToken else {
                return .none
            }
            state.shouldShowHUD = true

            return NftGeneratorClient.shared.caller()
                .flatMap { caller in caller.transfer(address: token.address, tokenId: token.tokenId, toAddress: input.toAddress) }
                .subscribe(on: environment.backgroundQueue)
                .map { _ in true }
                .receive(on: environment.mainQueue)
                .catchToEffect()
                .map(ContractDetailVM.Action.transfered)
        case .transfered(.success(_)):
            state.shouldShowHUD = false
            return .none
        case .transfered(.failure(let error)):
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
        case .presentSellNftView(let data):
            state.selectToken = data
            state.isPresentedSellNftView = true
            return .none
        }
    }
}

extension ContractDetailVM {
    enum Action: Equatable {
        case startInitialize
        case endInitialize(Result<TokensWithCursor, AppError>)
        case startRefresh
        case endRefresh(Result<TokensWithCursor, AppError>)
        case startNext
        case endNext(Result<TokensWithCursor, AppError>)
        case shouldShowHUD(Bool)
        case shouldPullToRefresh(Bool)
        case presentSellNftView(NftGeneratorAPI.TokenFragment)
        case isPresentedSellNftView(Bool)
        case sell(SellInput)
        case selled(Result<Bool, AppError>)
        case transfer(TransferInput)
        case transfered(Result<Bool, AppError>)
        case isPresentedErrorAlert(Bool)
    }

    struct State: Equatable {
        let contract: NftGeneratorAPI.ContractFragment

        var initialized = false
        var shouldShowHUD = false
        var shouldPullToRefresh = false
        var selectToken: NftGeneratorAPI.TokenFragment? = nil
        var isPresentedSellNftView = false
        var isPresentedErrorAlert = false
        var error: AppError?
        var shouldShowNextLoading = false
        var cursor: String? = nil
        var tokens: [NftGeneratorAPI.TokenFragment] = []
        var hasNext: Bool = false
    }

    struct Environment {
        let mainQueue: AnySchedulerOf<DispatchQueue>
        let backgroundQueue: AnySchedulerOf<DispatchQueue>
    }
}

struct SellInput: Equatable {
    let ether: Double
}

struct TransferInput: Equatable {
    let toAddress: String
}
