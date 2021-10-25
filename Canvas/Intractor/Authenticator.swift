import Combine
import SwiftUI

class Authenticator: ObservableObject {
    private var cancellable: AnyCancellable?

    @Published var errorProvider: AppError?

    func login() {
        cancellable?.cancel()
        cancellable = FirebaseAuthManager.shared.signInAnonymously().sink(receiveCompletion: { completion in
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
