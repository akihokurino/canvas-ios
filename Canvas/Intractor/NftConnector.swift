import Combine
import SwiftUI

class NftConnector: ObservableObject {
    private var cancellable: AnyCancellable?

    @Published var isOwn: Bool?
    @Published var errors: AppError?
    @Published var isRequesting: Bool = false

    func isOwn(workId: String) {
        cancellable?.cancel()

        cancellable = NftClient.shared.caller()
            .flatMap { caller in caller.isOwnNft(workId: workId) }
            .sink(receiveCompletion: { completion in
                switch completion {
                    case .finished:
                        self.isRequesting = false
                    case .failure(let error):
                        self.isRequesting = false
                        self.errors = error
                }
            }, receiveValue: { val in
                self.isOwn = val
            })
    }

    func create(workId: String, thumbnailUrl: String, level: Int, point: Int) {
        cancellable?.cancel()

        cancellable = NftClient.shared.caller()
            .flatMap { caller in caller.createNft(workId: workId, thumbnailUrl: thumbnailUrl, level: level, point: point) }
            .sink(receiveCompletion: { completion in
                switch completion {
                    case .finished:
                        self.isRequesting = false
                    case .failure(let error):
                        self.isRequesting = false
                        self.errors = error
                }
            }, receiveValue: { _ in

            })
    }
}
