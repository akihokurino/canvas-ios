import Combine
import SwiftUI

class Authenticator: ObservableObject {
    private var cancellable: AnyCancellable?

    @Published var errorProvider: AppError?

    func login() {
        cancellable?.cancel()
        cancellable = FirebaseAuthManager.shared.signInAnonymously()
            .flatMap { _ in FirebaseMessageManager.shared.token() }
            .sink(receiveCompletion: { completion in
                switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        self.errorProvider = error
                }
            }, receiveValue: { token in
                print(token)
            })
    }
}
