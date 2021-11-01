import Apollo
import Combine
import Firebase
import UIKit

struct NetworkInterceptorProvider: InterceptorProvider {
    private let store: ApolloStore
    private let client: URLSessionClient

    init(store: ApolloStore,
         client: URLSessionClient)
    {
        self.store = store
        self.client = client
    }

    func interceptors<Operation: GraphQLOperation>(for operation: Operation) -> [ApolloInterceptor] {
        return [
            MaxRetryInterceptor(),
            CacheReadInterceptor(store: store),
            NetworkFetchInterceptor(client: client),
            ResponseCodeInterceptor(),
            JSONResponseParsingInterceptor(cacheKeyForObject: store.cacheKeyForObject),
            AutomaticPersistedQueryInterceptor(),
            CacheWriteInterceptor(store: store)
        ]
    }
}

struct GraphQLClient {
    static let shared = GraphQLClient()

    func caller() -> Future<GraphQLCaller, AppError> {
        return Future<GraphQLCaller, AppError> { promise in
            guard let me = Auth.auth().currentUser else {
                promise(.failure(AppError.defaultError()))
                return
            }

            me.getIDTokenForcingRefresh(true) { idToken, error in
                if let error = error {
                    promise(.failure(.wrap(error)))
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

                promise(.success(GraphQLCaller(cli: apollo)))
            }
        }
    }
}

struct GraphQLCaller {
    let cli: ApolloClient

    func thumbnails(page: Int) -> Future<([GraphQL.ThumbnailFragment], Bool), AppError> {
        return Future<([GraphQL.ThumbnailFragment], Bool), AppError> { promise in
            cli.fetch(query: GraphQL.ListThumbnailQuery(page: page, limit: 21)) { result in
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

                    let items = data.thumbnails.edges.map { $0.node.fragments.thumbnailFragment }
                    let hasNext = data.thumbnails.pageInfo.hasNextPage

                    promise(.success((items, hasNext)))
                case .failure(let error):
                    promise(.failure(.wrap(error)))
                }
            }
        }
    }

    func works(page: Int) -> Future<([GraphQL.WorkFragment], Bool), AppError> {
        return Future<([GraphQL.WorkFragment], Bool), AppError> { promise in
            cli.fetch(query: GraphQL.ListWorkQuery(page: page, limit: 20)) { result in
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
                    promise(.failure(.wrap(error)))
                }
            }
        }
    }

    func registerFCMToken(token: String) -> Future<Void, AppError> {
        let udid = UIDevice.current.identifierForVendor!.uuidString
        return Future<Void, AppError> { promise in
            cli.perform(mutation: GraphQL.RegisterFmcTokenMutation(token: token, device: udid)) { result in
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
                    promise(.failure(.wrap(error)))
                }
            }
        }
    }
}
