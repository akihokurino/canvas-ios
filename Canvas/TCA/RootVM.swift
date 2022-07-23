import Combine
import ComposableArchitecture
import Foundation

enum RootVM {
    static let reducer = Reducer<State, Action, Environment> { state, action, environment in
        switch action {
            case .startInitialize:
                guard !state.initialized else {
                    return .none
                }

                state.shouldShowHUD = true

                let firebaseAuthFlow = { () -> AnyPublisher<Void, AppError> in
                    if FirebaseAuthManager.shared.isLogin() {
                        return FirebaseMessageManager.shared.token()
                            .flatMap { token in CanvasClient.shared.caller().map { ($0, token) } }
                            .flatMap { tp in tp.0.registerFCMToken(token: tp.1) }
                            .eraseToAnyPublisher()
                    } else {
                        return FirebaseAuthManager.shared.signInAnonymously()
                            .flatMap { _ in FirebaseMessageManager.shared.token() }
                            .flatMap { token in CanvasClient.shared.caller().map { ($0, token) } }
                            .flatMap { tp in tp.0.registerFCMToken(token: tp.1) }
                            .eraseToAnyPublisher()
                    }
                }

                let amplifyAuthFlow = { () -> AnyPublisher<Void, AppError> in
                    AmplifyAuthManager.shared.signIn().eraseToAnyPublisher()
                }

                return firebaseAuthFlow()
                    .flatMap { _ in amplifyAuthFlow() }
                    .map { _ in true }
                    .subscribe(on: environment.backgroundQueue)
                    .receive(on: environment.mainQueue)
                    .catchToEffect()
                    .map(RootVM.Action.endInitialize)
            case .endInitialize(.success(_)):
                state.workListView = WorkListVM.State()
                state.thumbnailListView = ThumbnailListVM.State()
                state.walletView = WalletVM.State()
                state.shouldShowHUD = false

                state.initialized = true

                return .none
            case .endInitialize(.failure(_)):
                state.shouldShowHUD = false
                return .none
            case .shouldShowHUD(let val):
                state.shouldShowHUD = val
                return .none

            case .workListView(let action):
                return .none
            case .thumbnailListView(let action):
                return .none
            case .walletView(let action):
                return .none
        }
    }
    .connect(
        WorkListVM.reducer,
        state: \.workListView,
        action: /RootVM.Action.workListView,
        environment: { _environment in
            WorkListVM.Environment(
                mainQueue: _environment.mainQueue,
                backgroundQueue: _environment.backgroundQueue
            )
        }
    )
    .connect(
        ThumbnailListVM.reducer,
        state: \.thumbnailListView,
        action: /RootVM.Action.thumbnailListView,
        environment: { _environment in
            ThumbnailListVM.Environment(
                mainQueue: _environment.mainQueue,
                backgroundQueue: _environment.backgroundQueue
            )
        }
    )
    .connect(
        WalletVM.reducer,
        state: \.walletView,
        action: /RootVM.Action.walletView,
        environment: { _environment in
            WalletVM.Environment(
                mainQueue: _environment.mainQueue,
                backgroundQueue: _environment.backgroundQueue
            )
        }
    )
}

extension RootVM {
    enum Action: Equatable {
        case startInitialize
        case endInitialize(Result<Bool, AppError>)
        case shouldShowHUD(Bool)

        case workListView(WorkListVM.Action)
        case thumbnailListView(ThumbnailListVM.Action)
        case walletView(WalletVM.Action)
    }

    struct State: Equatable {
        var initialized = false
        var shouldShowHUD = false

        var workListView: WorkListVM.State?
        var thumbnailListView: ThumbnailListVM.State?
        var walletView: WalletVM.State?
    }

    struct Environment {
        let mainQueue: AnySchedulerOf<DispatchQueue>
        let backgroundQueue: AnySchedulerOf<DispatchQueue>
    }
}
