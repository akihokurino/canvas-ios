import Combine
import ComposableArchitecture
import Foundation

enum RootVM {
    static let reducer = Reducer<State, Action, Environment> { state, action, environment in
        switch action {
            case .startInitialize:
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

                return firebaseAuthFlow().flatMap { _ in amplifyAuthFlow() }
                    .map { _ in true }
                    .subscribe(on: environment.backgroundQueue)
                    .receive(on: environment.mainQueue)
                    .catchToEffect()
                    .map(RootVM.Action.endInitialize)
            case .endInitialize(.success(_)):
                state.shouldShowHUD = false
                return .none
            case .endInitialize(.failure(_)):
                state.shouldShowHUD = false
                return .none
            case .shouldShowHUD(let val):
                state.shouldShowHUD = val
                return .none
        }
    }
}

extension RootVM {
    enum Action: Equatable {
        case startInitialize
        case endInitialize(Result<Bool, AppError>)
        case shouldShowHUD(Bool)
    }

    struct State: Equatable {
        var shouldShowHUD = false
    }

    struct Environment {
        let mainQueue: AnySchedulerOf<DispatchQueue>
        let backgroundQueue: AnySchedulerOf<DispatchQueue>
    }
}
