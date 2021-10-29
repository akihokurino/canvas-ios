import Combine
import SwiftUI

class ThumbnailFetcher: ObservableObject {
    private var _thumbnails: AnyCancellable?
    private var _page: Int = 1
    
    @Published var thumbnailProvider: [GraphQL.ThumbnailFragment] = []
    @Published var errorProvider: AppError?

    func initThumbnails() {
        guard FirebaseAuthManager.shared.isLogin() else {
            return
        }
        
        _page = 1

        _thumbnails?.cancel()
        _thumbnails = GraphQLClient.shared.caller()
            .flatMap { caller in caller.thumbnails(page: self._page) }
            .sink(receiveCompletion: { completion in
                switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        self.errorProvider = error
                }
            }, receiveValue: { val in
                self.thumbnailProvider = val
            })
    }
}
