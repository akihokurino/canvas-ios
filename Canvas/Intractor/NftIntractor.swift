import Combine
import SwiftUI

enum NftType {
    case ERC721
    case ERC1155
}

struct Asset {
    let address: String
    let tokenId: String
    let imageUrl: String
}

class NftIntractor: ObservableObject {
    private var cancellables: Set<AnyCancellable> = []

    @Published var ownNft721: Bool = false
    @Published var nft721: Asset?

    @Published var ownNft1155: Bool = false
    @Published var nft1155: Asset?

    @Published var errors: AppError?
    @Published var isLoading: Bool = false
    @Published var isInitAsset: Bool = false

    func getNft(workId: String) {
        ownNft721 = false
        nft721 = nil

        ownNft1155 = false
        nft1155 = nil

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
                self.nft721 = val.0.erc721
                self.nft1155 = val.0.erc1155
                self.ownNft721 = val.1.erc721
                self.ownNft1155 = val.1.erc1155

                self.isInitAsset = true
                self.isLoading = false
            })
            .store(in: &cancellables)
    }

    func create721(workId: String, gsPath: String, level: Int, point: Int) {
        isLoading = true

        NftClient.shared.caller()
            .flatMap { caller in caller.createNft721(workId: workId, gsPath: gsPath, level: level, point: point) }
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

    func create1155(workId: String, gsPath: String, level: Int, point: Int, amount: Int) {
        isLoading = true

        NftClient.shared.caller()
            .flatMap { caller in caller.createNft1155(workId: workId, gsPath: gsPath, level: level, point: point, amount: amount) }
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

    func sell721(workId: String, ether: Double) {
        isLoading = true

        NftClient.shared.caller()
            .flatMap { caller in caller.sellNft721(workId: workId, ether: ether) }
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

    func sell1155(workId: String, ether: Double) {
        isLoading = true

        NftClient.shared.caller()
            .flatMap { caller in caller.sellNft1155(workId: workId, ether: ether) }
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

    func transfer721(workId: String, address: String) {
        isLoading = true

        NftClient.shared.caller()
            .flatMap { caller in caller.transferNft721(workId: workId, toAddress: address) }
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

    func transfer1155(workId: String, address: String) {
        isLoading = true

        NftClient.shared.caller()
            .flatMap { caller in caller.transferNft1155(workId: workId, toAddress: address) }
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
