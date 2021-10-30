import Combine
import SwiftUI

class ThumbnailListFetcher: ObservableObject {
    private var cancellable: AnyCancellable?
    private var page: Int = 1

    @Published var thumbnails: [GraphQL.ThumbnailFragment] = []
    @Published var errors: AppError?
    @Published var hasNext: Bool = false
    @Published var isFetching: Bool = false

    func initialize(isRefresh: Bool = false, callback: @escaping () -> ()) {
        guard FirebaseAuthManager.shared.isLogin() else {
            return
        }
        
        if !isRefresh && !thumbnails.isEmpty {
            return
        }

        page = 1
        isFetching = true
        hasNext = false
        cancellable?.cancel()

        cancellable = GraphQLClient.shared.caller()
            .flatMap { caller in caller.thumbnails(page: self.page) }
            .sink(receiveCompletion: { completion in
                switch completion {
                    case .finished:
                        callback()
                        self.isFetching = false
                    case .failure(let error):
                        callback()
                        self.isFetching = false
                        self.errors = error
                }
            }, receiveValue: { val in
                self.thumbnails = val.0
                self.hasNext = val.1
            })
    }

    func next(callback: @escaping () -> ()) {
        guard FirebaseAuthManager.shared.isLogin() else {
            return
        }

        guard !isFetching else {
            return
        }

        page += 1
        isFetching = true
        hasNext = true
        cancellable?.cancel()

        cancellable = GraphQLClient.shared.caller()
            .flatMap { caller in caller.thumbnails(page: self.page) }
            .sink(receiveCompletion: { completion in
                switch completion {
                    case .finished:
                        callback()
                        self.isFetching = false
                    case .failure(let error):
                        callback()
                        self.isFetching = false
                        self.errors = error
                }
            }, receiveValue: { val in
                self.thumbnails.append(contentsOf: val.0)
                self.hasNext = val.1
            })
    }
}
