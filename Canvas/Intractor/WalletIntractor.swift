import Combine
import SwiftUI

class WalletIntractor: ObservableObject {
    private var cancellable: AnyCancellable?

    @Published var address: String = ""
    @Published var balance: Double = 0.0
    @Published var errors: AppError?

    func getWallet() {
        cancellable?.cancel()

        cancellable = NftClient.shared.caller()
            .flatMap { caller in caller.getWallet() }
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished: break
                case .failure(let error):
                    self.errors = error
                }
            }, receiveValue: { val in
                self.address = val.address
                self.balance = val.balance
            })
    }
}
