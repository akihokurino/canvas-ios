import Combine
import SwiftUI

class Authenticator: ObservableObject {
    private var cancellable: AnyCancellable?

    @Published var errors: AppError?

    func login() {
        cancellable?.cancel()

        if FirebaseAuthManager.shared.isLogin() {
            cancellable = FirebaseMessageManager.shared.token()
                .flatMap { token in CanvasClient.shared.caller().map { ($0, token) } }
                .flatMap { tp in tp.0.registerFCMToken(token: tp.1) }
                .subscribe(on: DispatchQueue.global())
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { completion in
                    switch completion {
                        case .finished:
                            break
                        case .failure(let error):
                            self.errors = error
                    }
                }, receiveValue: { _ in

                })
        } else {
            cancellable = FirebaseAuthManager.shared.signInAnonymously()
                .flatMap { _ in FirebaseMessageManager.shared.token() }
                .flatMap { token in CanvasClient.shared.caller().map { ($0, token) } }
                .flatMap { tp in tp.0.registerFCMToken(token: tp.1) }
                .subscribe(on: DispatchQueue.global())
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { completion in
                    switch completion {
                        case .finished:
                            break
                        case .failure(let error):
                            self.errors = error
                    }
                }, receiveValue: { _ in

                })
        }

        if !AmplifyAuthManager.shared.isLogin() {
            cancellable = AmplifyAuthManager.shared.signIn()
                .subscribe(on: DispatchQueue.global())
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { completion in
                    switch completion {
                        case .finished:
                            break
                        case .failure(let error):
                            self.errors = error
                    }
                }, receiveValue: { _ in

                })
        }
    }

    func syncFCMToken(token: String) {
        guard FirebaseAuthManager.shared.isLogin() else {
            return
        }

        cancellable?.cancel()

        cancellable = CanvasClient.shared.caller()
            .flatMap { caller in caller.registerFCMToken(token: token) }
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        self.errors = error
                }
            }, receiveValue: { _ in

            })
    }
}
