import Combine
import SwiftUI

class NftIntractor: ObservableObject {
    private var cancellable: AnyCancellable?

    @Published var hasNft: Bool?
    @Published var errors: AppError?
    @Published var isRequesting: Bool = false

    func hasNft(workId: String) {
        cancellable?.cancel()
        
        hasNft = false
        
//        cancellable = NftClient.shared.caller()
//            .flatMap { caller in caller.hasNft(workId: workId) }
//            .sink(receiveCompletion: { completion in
//                switch completion {
//                case .finished: break
//                case .failure(let error):
//                    self.errors = error
//                }
//            }, receiveValue: { val in
//                self.hasNft = val
//            })
    }

    func create(workId: String, thumbnailUrl: String, level: Int, point: Int) {
        cancellable?.cancel()

//        isRequesting = true
//
//        cancellable = NftClient.shared.caller()
//            .flatMap { caller in caller.createNft(workId: workId, thumbnailUrl: thumbnailUrl, level: level, point: point) }
//            .sink(receiveCompletion: { completion in
//                switch completion {
//                case .finished:
//                    self.isRequesting = false
//                case .failure(let error):
//                    self.isRequesting = false
//                    self.errors = error
//                }
//            }, receiveValue: { _ in
//                self.hasNft(workId: workId)
//            })
    }
}
