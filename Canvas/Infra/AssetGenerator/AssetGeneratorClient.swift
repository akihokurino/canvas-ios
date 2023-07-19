import Apollo
import Combine
import Firebase
import UIKit

extension AssetGeneratorAPI.WorkFragment: Identifiable, Equatable {
    public static func == (lhs: AssetGeneratorAPI.WorkFragment, rhs: AssetGeneratorAPI.WorkFragment) -> Bool {
        return lhs.id == rhs.id
    }
}

extension AssetGeneratorAPI.WorkFragment.Frame: Identifiable, Equatable {
    public static func == (lhs: AssetGeneratorAPI.WorkFragment.Frame, rhs: AssetGeneratorAPI.WorkFragment.Frame) -> Bool {
        return lhs.id == rhs.id
    }
}

extension AssetGeneratorAPI.FrameFragment: Identifiable, Equatable {
    public static func == (lhs: AssetGeneratorAPI.FrameFragment, rhs: AssetGeneratorAPI.FrameFragment) -> Bool {
        return lhs.id == rhs.id
    }
}

struct AssetGeneratorClient {
    static let shared = AssetGeneratorClient()

    func caller() -> Future<CanvasCaller, AppError> {
        return Future<CanvasCaller, AppError> { promise in
            guard let me = Auth.auth().currentUser else {
                promise(.failure(AppError.defaultError()))
                return
            }

            me.getIDTokenForcingRefresh(true) { idToken, error in
                if let error = error {
                    promise(.failure(.plain(error.localizedDescription)))
                    return
                }

                guard let token = idToken else {
                    promise(.failure(AppError.defaultError()))
                    return
                }

                let cache = InMemoryNormalizedCache()
                let store = ApolloStore(cache: cache)
                let client = URLSessionClient()
                let provider = NetworkInterceptorProvider(store: store, client: client)

                let transport = RequestChainNetworkTransport(
                    interceptorProvider: provider,
                    endpointURL: URL(string: "https://canvas-329810.an.r.appspot.com/query")!,
                    additionalHeaders: ["authorization": "bearer \(token)"]
                )

                let apollo = ApolloClient(networkTransport: transport, store: store)

                promise(.success(CanvasCaller(cli: apollo)))
            }
        }
    }
}

struct CanvasCaller {
    let cli: ApolloClient

    func works(page: Int) -> Future<([AssetGeneratorAPI.WorkFragment], Bool), AppError> {
        return Future<([AssetGeneratorAPI.WorkFragment], Bool), AppError> { promise in
            cli.fetch(query: AssetGeneratorAPI.ListWorkQuery(page: page, limit: 10)) { result in
                switch result {
                case .success(let graphQLResult):
                    if let errors = graphQLResult.errors {
                        if !errors.filter({ $0.message != nil }).isEmpty {
                            let messages = errors.filter { $0.message != nil }.map { $0.message! }
                            promise(.failure(.plain(messages.joined(separator: "\n"))))
                            return
                        }
                    }

                    guard let data = graphQLResult.data else {
                        promise(.failure(AppError.defaultError()))
                        return
                    }

                    let items = data.works.edges.map { $0.node.fragments.workFragment }
                    let hasNext = data.works.pageInfo.hasNextPage

                    promise(.success((items, hasNext)))
                case .failure(let error):
                    promise(.failure(.plain(error.localizedDescription)))
                }
            }
        }
    }
    
    func framesByWork(workId: String) -> Future<[AssetGeneratorAPI.FrameFragment], AppError> {
        return Future<[AssetGeneratorAPI.FrameFragment], AppError> { promise in
            cli.fetch(query: AssetGeneratorAPI.ListFrameByWorkQuery(workId: workId)) { result in
                switch result {
                case .success(let graphQLResult):
                    if let errors = graphQLResult.errors {
                        if !errors.filter({ $0.message != nil }).isEmpty {
                            let messages = errors.filter { $0.message != nil }.map { $0.message! }
                            promise(.failure(.plain(messages.joined(separator: "\n"))))
                            return
                        }
                    }

                    guard let data = graphQLResult.data else {
                        promise(.failure(AppError.defaultError()))
                        return
                    }

                    let items = data.work.frames.map { $0.fragments.frameFragment }
                    
                    promise(.success(items))
                case .failure(let error):
                    promise(.failure(.plain(error.localizedDescription)))
                }
            }
        }
    }

    func frames(page: Int) -> Future<([AssetGeneratorAPI.FrameFragment], Bool), AppError> {
        return Future<([AssetGeneratorAPI.FrameFragment], Bool), AppError> { promise in
            cli.fetch(query: AssetGeneratorAPI.ListFrameQuery(page: page, limit: 18)) { result in
                switch result {
                case .success(let graphQLResult):
                    if let errors = graphQLResult.errors {
                        if !errors.filter({ $0.message != nil }).isEmpty {
                            let messages = errors.filter { $0.message != nil }.map { $0.message! }
                            promise(.failure(.plain(messages.joined(separator: "\n"))))
                            return
                        }
                    }

                    guard let data = graphQLResult.data else {
                        promise(.failure(AppError.defaultError()))
                        return
                    }

                    let items = data.frames.edges.map { $0.node.fragments.frameFragment }
                    let hasNext = data.frames.pageInfo.hasNextPage

                    promise(.success((items, hasNext)))
                case .failure(let error):
                    promise(.failure(.plain(error.localizedDescription)))
                }
            }
        }
    }

    func registerFCMToken(token: String) -> Future<Void, AppError> {
        let udid = UIDevice.current.identifierForVendor!.uuidString
        return Future<Void, AppError> { promise in
            cli.perform(mutation: AssetGeneratorAPI.RegisterFmcTokenMutation(token: token, device: udid)) { result in
                switch result {
                case .success(let graphQLResult):
                    if let errors = graphQLResult.errors {
                        if !errors.filter({ $0.message != nil }).isEmpty {
                            let messages = errors.filter { $0.message != nil }.map { $0.message! }
                            promise(.failure(.plain(messages.joined(separator: "\n"))))
                            return
                        }
                    }

                    guard let _ = graphQLResult.data else {
                        promise(.failure(AppError.defaultError()))
                        return
                    }

                    promise(.success(()))
                case .failure(let error):
                    promise(.failure(.plain(error.localizedDescription)))
                }
            }
        }
    }
}
