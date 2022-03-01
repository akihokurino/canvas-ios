import Amplify
import Apollo
import AWSPluginsCore
import Combine
import Foundation

struct NftClient {
    static let shared = NftClient()

    func caller() -> Future<NftCaller, AppError> {
        return Future<NftCaller, AppError> { promise in
            guard Amplify.Auth.getCurrentUser() != nil else {
                promise(.failure(AppError.defaultError()))
                return
            }

            Amplify.Auth.fetchAuthSession { result in
                do {
                    let session = try result.get()
                    let cognitoTokenProvider = session as! AuthCognitoTokensProvider
                    let tokens = try cognitoTokenProvider.getCognitoTokens().get()
                    let token = tokens.idToken

                    let cache = InMemoryNormalizedCache()
                    let store = ApolloStore(cache: cache)
                    let client = URLSessionClient()
                    let provider = NetworkInterceptorProvider(store: store, client: client)

                    let transport = RequestChainNetworkTransport(
                        interceptorProvider: provider,
                        endpointURL: URL(string: "https://t9vyn4nsya.execute-api.ap-northeast-1.amazonaws.com/default/graphql")!,
                        additionalHeaders: ["authorization": "bearer \(token)"]
                    )

                    let apollo = ApolloClient(networkTransport: transport, store: store)

                    promise(.success(NftCaller(cli: apollo)))

                } catch {
                    promise(.failure(AppError.wrap(error)))
                }
            }
        }
    }
}

struct NftCaller {
    let cli: ApolloClient

    func isOwnNft(workId: String) -> Future<Bool, AppError> {
        return Future<Bool, AppError> { promise in
            cli.fetch(query: NftAPI.IsOwnNftQuery(workId: workId)) { result in
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

                    promise(.success(data.isOwnNft))
                case .failure(let error):
                    promise(.failure(.wrap(error)))
                }
            }
        }
    }

    func createNft(workId: String, thumbnailUrl: String, level: Int, point: Int) -> Future<Void, AppError> {
        return Future<Void, AppError> { promise in
            cli.perform(mutation: NftAPI.CreateNftMutation(workId: workId, thumbnailUrl: thumbnailUrl, level: level, point: point)) { result in
                switch result {
                case .success(let graphQLResult):
                    if let errors = graphQLResult.errors {
                        if !errors.filter({ $0.message != nil }).isEmpty {
                            let messages = errors.filter { $0.message != nil }.map { $0.message! }
                            promise(.failure(.plain(messages.joined(separator: "\n"))))
                            return
                        }
                    }

                    promise(.success(()))
                case .failure(let error):
                    promise(.failure(.wrap(error)))
                }
            }
        }
    }
}
