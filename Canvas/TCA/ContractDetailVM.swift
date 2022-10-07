import Combine
import ComposableArchitecture
import Foundation
import SwiftUIPager

enum ContractDetailVM {
    static let reducer = Reducer<State, Action, Environment> { state, action, environment in
        switch action {
        case .changePage(let index):
            state.currentPage = .withIndex(index)
            state.currentSelection = index
            return .none
        case .shouldShowHUD(let val):
            state.shouldShowHUD = val
            return .none
        case .isPresentedSellNftView(let val):
            state.isPresentedSellNftView = val
            return .none
        case .presentBulkSellNftView:
            state.isPresentedBulkSellNftView = true
            return .none
        case .isPresentedBulkSellNftView(let val):
            state.isPresentedBulkSellNftView = val
            return .none
        case .sellERC721(let input):
            guard let token = state.selectToken else {
                return .none
            }
            state.shouldShowHUD = true

            return NftClient.shared.caller()
                .flatMap { caller in caller.sellERC721(workId: token.workId, ether: input.ether).map { caller } }
                .flatMap { caller in caller.mintedToken(workId: token.workId) }
                .map { $0.0! }
                .subscribe(on: environment.backgroundQueue)
                .receive(on: environment.mainQueue)
                .catchToEffect()
                .map(ContractDetailVM.Action.selled)
        case .sellERC1155(let input):
            guard let token = state.selectToken else {
                return .none
            }
            state.shouldShowHUD = true

            return NftClient.shared.caller()
                .flatMap { caller in caller.sellERC1155(workId: token.workId, ether: input.ether).map { caller } }
                .flatMap { caller in caller.mintedToken(workId: token.workId) }
                .map { $0.1! }
                .subscribe(on: environment.backgroundQueue)
                .receive(on: environment.mainQueue)
                .catchToEffect()
                .map(ContractDetailVM.Action.selled)
        case .selled(.success(let token)):
            state.shouldShowHUD = false
            if state.tokenListView != nil {
                state.tokenListView!.tokens = state.tokenListView!.tokens.map { $0.id == token.id ? token : $0 }
            }
            if state.multiTokenListView != nil {
                state.multiTokenListView!.tokens = state.multiTokenListView!.tokens.map { $0.id == token.id ? token : $0 }
            }
            return .none
        case .selled(.failure(_)):
            state.shouldShowHUD = false
            return .none
        case .transferERC721(let input):
            guard let token = state.selectToken else {
                return .none
            }
            state.shouldShowHUD = true

            return NftClient.shared.caller()
                .flatMap { caller in caller.transferERC721(workId: token.workId, toAddress: input.toAddress).map { caller } }
                .flatMap { caller in caller.mintedToken(workId: token.workId) }
                .map { $0.0! }
                .subscribe(on: environment.backgroundQueue)
                .receive(on: environment.mainQueue)
                .catchToEffect()
                .map(ContractDetailVM.Action.transfered)
        case .transferERC1155(let input):
            guard let token = state.selectToken else {
                return .none
            }
            state.shouldShowHUD = true

            return NftClient.shared.caller()
                .flatMap { caller in caller.transferERC1155(workId: token.workId, toAddress: input.toAddress).map { caller } }
                .flatMap { caller in caller.mintedToken(workId: token.workId) }
                .map { $0.1! }
                .subscribe(on: environment.backgroundQueue)
                .receive(on: environment.mainQueue)
                .catchToEffect()
                .map(ContractDetailVM.Action.selled)
        case .transfered(.success(let token)):
            state.shouldShowHUD = false
            if state.tokenListView != nil {
                state.tokenListView!.tokens = state.tokenListView!.tokens.map { $0.id == token.id ? token : $0 }
            }
            if state.multiTokenListView != nil {
                state.multiTokenListView!.tokens = state.multiTokenListView!.tokens.map { $0.id == token.id ? token : $0 }
            }
            return .none
        case .transfered(.failure(_)):
            state.shouldShowHUD = false
            return .none
        case .startSellAllTokens(let data):
            state.shouldShowHUD = true

            let address = state.contract.address

            return NftClient.shared.caller()
                .flatMap { caller in caller.sellAllTokens(address: address, ether: data.ether) }
                .map { true }
                .subscribe(on: environment.backgroundQueue)
                .receive(on: environment.mainQueue)
                .catchToEffect()
                .map(ContractDetailVM.Action.endSellAllTokens)
        case .endSellAllTokens(.success(_)):
            state.shouldShowHUD = false
            return .none
        case .endSellAllTokens(.failure(_)):
            state.shouldShowHUD = false
            return .none

        case .tokenListView(let action):
            switch action {
            case .presentSellNftView(let data):
                state.selectToken = data
                state.isPresentedSellNftView = true
                return .none
            default:
                return .none
            }
        case .multiTokenListView(let action):
            switch action {
            case .presentSellNftView(let data):
                state.selectToken = data
                state.isPresentedSellNftView = true
                return .none
            default:
                return .none
            }
        }
    }
    .connect(
        TokenListVM.reducer,
        state: \.tokenListView,
        action: /ContractDetailVM.Action.tokenListView,
        environment: { _environment in
            TokenListVM.Environment(
                mainQueue: _environment.mainQueue,
                backgroundQueue: _environment.backgroundQueue
            )
        }
    )
    .connect(
        MultiTokenListVM.reducer,
        state: \.multiTokenListView,
        action: /ContractDetailVM.Action.multiTokenListView,
        environment: { _environment in
            MultiTokenListVM.Environment(
                mainQueue: _environment.mainQueue,
                backgroundQueue: _environment.backgroundQueue
            )
        }
    )
}

extension ContractDetailVM {
    enum Action: Equatable {
        case changePage(Int)
        case shouldShowHUD(Bool)
        case isPresentedSellNftView(Bool)
        case presentBulkSellNftView
        case isPresentedBulkSellNftView(Bool)
        case sellERC721(SellInput)
        case sellERC1155(SellInput)
        case selled(Result<NftAPI.TokenFragment, AppError>)
        case transferERC721(TransferInput)
        case transferERC1155(TransferInput)
        case transfered(Result<NftAPI.TokenFragment, AppError>)
        case startSellAllTokens(SellAllTokensInput)
        case endSellAllTokens(Result<Bool, AppError>)

        case tokenListView(TokenListVM.Action)
        case multiTokenListView(MultiTokenListVM.Action)
    }

    struct State: Equatable {
        let contract: NftAPI.ContractFragment
        let pageIndexes = Array(0 ..< 2)

        var shouldShowHUD = false
        var currentPage: Page = .withIndex(0)
        var currentSelection: Int = 0
        var selectToken: NftAPI.TokenFragment? = nil
        var isPresentedSellNftView = false
        var isPresentedBulkSellNftView = false

        var tokenListView: TokenListVM.State?
        var multiTokenListView: MultiTokenListVM.State?
    }

    struct Environment {
        let mainQueue: AnySchedulerOf<DispatchQueue>
        let backgroundQueue: AnySchedulerOf<DispatchQueue>
    }
}

struct SellAllTokensInput: Equatable {
    let ether: Double
}
