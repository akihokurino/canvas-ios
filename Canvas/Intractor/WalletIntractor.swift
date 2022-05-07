import Combine
import SwiftUI

class WalletIntractor: ObservableObject {
    private var cancellable: AnyCancellable?

    @Published var address: String = ""
    @Published var balance: Double = 0.0
    @Published var errors: AppError?
    @Published var isInitializing: Bool = false

    func initialize() {
        guard address.isEmpty else {
            return
        }
        
        cancellable?.cancel()
        
        isInitializing = true

        cancellable = NftClient.shared.caller()
            .flatMap { caller in caller.getWallet() }
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished: break
                case .failure(let error):
                    self.isInitializing = false
                    self.errors = error
                }
            }, receiveValue: { val in
                self.isInitializing = false
                self.address = val.address
                self.balance = val.balance
            })
    }
}
