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
            state.shouldShowHUD = false

            state.workListView = WorkListVM.State()
            state.archivePageView = ArchivePageVM.State(
                archiveListView: ArchiveListVM.State(),
                frameListView: FrameListVM.State()
            )
            state.contractListView = ContractListVM.State()
            state.walletView = WalletVM.State()

            state.initialized = true

            return .none
        case .endInitialize(.failure(let error)):
            state.shouldShowHUD = false
            state.isPresentedErrorAlert = true
            state.error = error
            return .none
        case .shouldShowHUD(let val):
            state.shouldShowHUD = val
            return .none
        case .presentAlert(let val):
            state.isPresentedAlert = val
            return .none
        case .isPresentedErrorAlert(let val):
            state.isPresentedErrorAlert = val
            if !val {
                state.error = nil
            }
            return .none

        case .workListView(let action):
            return .none
        case .archivePageView(let action):
            switch action {
            case .archiveListView(let action):
                switch action {
                case .archiveDetailView(let action):
                    switch action {
                    case .minted(.failure(_)):
                        state.alertText = "Mintに失敗しました\nWalletの残高とIPFSサーバーの起動を確認してください"
                        state.isPresentedAlert = true
                    default:
                        break
                    }
                default:
                    break
                }
            default:
                break
            }
            return .none
        case .contractListView(let action):
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
        ArchivePageVM.reducer,
        state: \.archivePageView,
        action: /RootVM.Action.archivePageView,
        environment: { _environment in
            ArchivePageVM.Environment(
                mainQueue: _environment.mainQueue,
                backgroundQueue: _environment.backgroundQueue
            )
        }
    )
    .connect(
        ContractListVM.reducer,
        state: \.contractListView,
        action: /RootVM.Action.contractListView,
        environment: { _environment in
            ContractListVM.Environment(
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
        case presentAlert(Bool)
        case isPresentedErrorAlert(Bool)

        case workListView(WorkListVM.Action)
        case archivePageView(ArchivePageVM.Action)
        case contractListView(ContractListVM.Action)
        case walletView(WalletVM.Action)
    }

    struct State: Equatable {
        var initialized = false
        var shouldShowHUD = false
        var isPresentedAlert = false
        var alertText = ""
        var isPresentedErrorAlert = false
        var error: AppError?

        var workListView: WorkListVM.State?
        var archivePageView: ArchivePageVM.State?
        var contractListView: ContractListVM.State?
        var walletView: WalletVM.State?
    }

    struct Environment {
        let mainQueue: AnySchedulerOf<DispatchQueue>
        let backgroundQueue: AnySchedulerOf<DispatchQueue>
    }
}
