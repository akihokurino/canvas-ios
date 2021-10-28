import Combine
import SwiftUI

class Authenticator: ObservableObject {
    private var _login: AnyCancellable?
    private var _syncFCMToken: AnyCancellable?

    @Published var errorProvider: AppError?

    func login() {
        _login?.cancel()
        _login = FirebaseAuthManager.shared.signInAnonymously()
            .flatMap { _ in FirebaseMessageManager.shared.token() }
            .flatMap { token in GraphQLClient.shared.caller().map { ($0, token) } }
            .flatMap { tp in tp.0.registerFCMToken(token: tp.1) }
            .sink(receiveCompletion: { completion in
                switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        self.errorProvider = error
                }
            }, receiveValue: { _ in

            })
    }

    func syncFCMToken(token: String) {
        guard FirebaseAuthManager.shared.isLogin() else {
            return
        }

        _syncFCMToken?.cancel()
        _syncFCMToken = GraphQLClient.shared.caller()
            .flatMap { caller in caller.registerFCMToken(token: token) }
            .sink(receiveCompletion: { completion in
                switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        self.errorProvider = error
                }
            }, receiveValue: { _ in

            })
    }
}
