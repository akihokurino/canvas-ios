import Combine
import SwiftUI

class NftIntractor: ObservableObject {
    private var cancellable: AnyCancellable?

    @Published var hasNft721: Bool?
    @Published var nft721: Asset?
    @Published var hasNft1155: Bool?
    @Published var nft1155: Asset?
    @Published var errors: AppError?
    @Published var isCreating: Bool = false

    func hasNft(workId: String) {
        cancellable?.cancel()

        hasNft721 = nil
        nft721 = nil
        hasNft1155 = nil
        nft1155 = nil
        
        cancellable = NftClient.shared.caller()
            .flatMap { caller in caller.getNftAssets(workId: workId) }
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished: break
                case .failure(let error):
                    self.errors = error
                }
            }, receiveValue: { val in
                self.hasNft721 = val.nft721 != nil
                self.nft721 = val.nft721
                self.hasNft1155 = val.nft1155 != nil
                self.nft1155 = val.nft1155
            })
    }

    func create721(workId: String, gsPath: String, level: Int, point: Int) {
        cancellable?.cancel()

        isCreating = true

        cancellable = NftClient.shared.caller()
            .flatMap { caller in caller.createNft721(workId: workId, gsPath: gsPath, level: level, point: point) }
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished: break
                case .failure(let error):
                    self.isCreating = false
                    self.errors = error
                }
            }, receiveValue: { _ in
                self.isCreating = false
                self.hasNft(workId: workId)
            })
    }

    func create1155(workId: String, gsPath: String, level: Int, point: Int, amount: Int) {
        cancellable?.cancel()

        isCreating = true

        cancellable = NftClient.shared.caller()
            .flatMap { caller in caller.createNft1155(workId: workId, gsPath: gsPath, level: level, point: point, amount: amount) }
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished: break
                case .failure(let error):
                    self.isCreating = false
                    self.errors = error
                }
            }, receiveValue: { _ in
                self.isCreating = false
                self.hasNft(workId: workId)
            })
    }
}
