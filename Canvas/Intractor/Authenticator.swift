import Combine
import SwiftUI

class Authenticator: ObservableObject {
    private var cancellables: Set<AnyCancellable> = []

    @Published var errors: AppError?

    func login() {
        if FirebaseAuthManager.shared.isLogin() {
            FirebaseMessageManager.shared.token()
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
                .store(in: &cancellables)
        } else {
            FirebaseAuthManager.shared.signInAnonymously()
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
                .store(in: &cancellables)
        }

        if !AmplifyAuthManager.shared.isLogin() {
            AmplifyAuthManager.shared.signIn()
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
                .store(in: &cancellables)
        }
    }

    func syncFCMToken(token: String) {
        guard FirebaseAuthManager.shared.isLogin() else {
            return
        }

        CanvasClient.shared.caller()
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
            .store(in: &cancellables)
    }
}
