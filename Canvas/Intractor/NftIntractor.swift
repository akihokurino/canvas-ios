import Combine
import SwiftUI



class NftIntractor: ObservableObject {
    private var cancellables: Set<AnyCancellable> = []

    @Published var ownERC721: Bool = false
    @Published var erc721: Asset?

    @Published var ownERC1155: Bool = false
    @Published var erc1155: Asset?

    @Published var errors: AppError?
    @Published var isLoading: Bool = false
    @Published var isInitAsset: Bool = false

    func getNft(workId: String) {
        ownERC721 = false
        erc721 = nil

        ownERC1155 = false
        erc1155 = nil

        isLoading = true

        NftClient.shared.caller()
            .flatMap { caller in caller.getNftAssets(workId: workId).combineLatest(caller.isOwnNft(workId: workId)) }
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished: break
                case .failure(let error):
                    self.errors = error
                }
            }, receiveValue: { val in
                self.erc721 = val.0.erc721
                self.erc1155 = val.0.erc1155
                
                self.ownERC721 = val.1.erc721
                self.ownERC1155 = val.1.erc1155

                self.isInitAsset = true
                self.isLoading = false
            })
            .store(in: &cancellables)
    }

    func createERC721(workId: String, gsPath: String) {
        isLoading = true

        NftClient.shared.caller()
            .flatMap { caller in caller.createERC721(workId: workId, gsPath: gsPath) }
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished: break
                case .failure(let error):
                    self.isLoading = false
                    self.errors = error
                }
            }, receiveValue: { _ in
                self.isLoading = false
                self.getNft(workId: workId)
            })
            .store(in: &cancellables)
    }

    func createERC1155(workId: String, gsPath: String, amount: Int) {
        isLoading = true

        NftClient.shared.caller()
            .flatMap { caller in caller.createERC1155(workId: workId, gsPath: gsPath, amount: amount) }
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished: break
                case .failure(let error):
                    self.isLoading = false
                    self.errors = error
                }
            }, receiveValue: { _ in
                self.isLoading = false
                self.getNft(workId: workId)
            })
            .store(in: &cancellables)
    }

    func sellERC721(workId: String, ether: Double) {
        isLoading = true

        NftClient.shared.caller()
            .flatMap { caller in caller.sellERC721(workId: workId, ether: ether) }
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished: break
                case .failure(let error):
                    self.isLoading = false
                    self.errors = error
                }
            }, receiveValue: { _ in
                self.isLoading = false
            })
            .store(in: &cancellables)
    }

    func sellERC1155(workId: String, ether: Double) {
        isLoading = true

        NftClient.shared.caller()
            .flatMap { caller in caller.sellERC1155(workId: workId, ether: ether) }
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished: break
                case .failure(let error):
                    self.isLoading = false
                    self.errors = error
                }
            }, receiveValue: { _ in
                self.isLoading = false
            })
            .store(in: &cancellables)
    }

    func transferERC721(workId: String, address: String) {
        isLoading = true

        NftClient.shared.caller()
            .flatMap { caller in caller.transferERC721(workId: workId, toAddress: address) }
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished: break
                case .failure(let error):
                    self.isLoading = false
                    self.errors = error
                }
            }, receiveValue: { _ in
                self.isLoading = false
                self.getNft(workId: workId)
            })
            .store(in: &cancellables)
    }

    func transferERC1155(workId: String, address: String) {
        isLoading = true

        NftClient.shared.caller()
            .flatMap { caller in caller.transferERC1155(workId: workId, toAddress: address) }
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished: break
                case .failure(let error):
                    self.isLoading = false
                    self.errors = error
                }
            }, receiveValue: { _ in
                self.isLoading = false
                self.getNft(workId: workId)
            })
            .store(in: &cancellables)
    }
}
