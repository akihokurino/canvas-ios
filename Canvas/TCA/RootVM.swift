import Combine
import ComposableArchitecture
import Foundation

enum RootVM {
    static let reducer = Reducer<State, Action, Environment> { state, action, environment in
        switch action {
            case .startInitialize:
                state.initializing = true

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
                    if !AmplifyAuthManager.shared.isLogin() {
                        return AmplifyAuthManager.shared.signIn().eraseToAnyPublisher()
                    } else {
                        return Empty(completeImmediately: false).eraseToAnyPublisher()
                    }
                }

                return firebaseAuthFlow().flatMap { _ in amplifyAuthFlow() }
                    .map { _ in true }
                    .subscribe(on: environment.backgroundQueue)
                    .receive(on: environment.mainQueue)
                    .catchToEffect()
                    .map(RootVM.Action.endInitialize)
            case .endInitialize(.success(_)):
                state.initializing = false
                return .none
            case .endInitialize(.failure(_)):
                state.initializing = false
                return .none
        }
    }
}

extension RootVM {
    enum Action: Equatable {
        case startInitialize
        case endInitialize(Result<Bool, AppError>)
    }

    struct State: Equatable {
        var initializing: Bool
    }

    struct Environment {
        let mainQueue: AnySchedulerOf<DispatchQueue>
        let backgroundQueue: AnySchedulerOf<DispatchQueue>
    }
}
