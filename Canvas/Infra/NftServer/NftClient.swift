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
                    let configuration = URLSessionConfiguration.default
                    configuration.timeoutIntervalForRequest = 60.0
                    configuration.timeoutIntervalForResource = 60.0
                    let client = URLSessionClient(sessionConfiguration: configuration)
                    let provider = NetworkInterceptorProvider(store: store, client: client)

                    let transport = RequestChainNetworkTransport(
                        interceptorProvider: provider,
                        endpointURL: URL(string: "https://ji1t807ur2.execute-api.ap-northeast-1.amazonaws.com/default/graphql")!,
                        additionalHeaders: ["authorization": "bearer \(token)"]
                    )

                    let apollo = ApolloClient(networkTransport: transport, store: store)

                    promise(.success(NftCaller(cli: apollo)))

                } catch {
                    promise(.failure(.plain(error.localizedDescription)))
                }
            }
        }
    }
}

struct NftCaller {
    let cli: ApolloClient

    func getWallet() -> Future<(address: String, balance: Double), AppError> {
        return Future<(address: String, balance: Double), AppError> { promise in
            cli.fetch(query: NftAPI.GetMeQuery()) { result in
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

                    promise(.success((address: data.me.walletAddress, balance: data.me.balance)))
                case .failure(let error):
                    promise(.failure(.plain(error.localizedDescription)))
                }
            }
        }
    }

    func getNftAssets(workId: String) -> Future<(erc721: Asset?, erc1155: Asset?), AppError> {
        return Future<(erc721: Asset?, erc1155: Asset?), AppError> { promise in
            cli.fetch(query: NftAPI.GetWorkQuery(workId: workId)) { result in
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

                    promise(.success((
                        erc721: data.work.asset721 != nil ? Asset(address: data.work.asset721!.address, tokenId: data.work.asset721!.tokenId, imageUrl: data.work.asset721!.imageUrl) : nil,
                        erc1155: data.work.asset1155 != nil ? Asset(address: data.work.asset1155!.address, tokenId: data.work.asset1155!.tokenId, imageUrl: data.work.asset1155!.imageUrl) : nil
                    )))
                case .failure(let error):
                    promise(.failure(.plain(error.localizedDescription)))
                }
            }
        }
    }

    func isOwnNft(workId: String) -> Future<(erc721: Bool, erc1155: Bool), AppError> {
        return Future<(erc721: Bool, erc1155: Bool), AppError> { promise in
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

                    promise(.success((
                        erc721: data.isOwnNft.erc721,
                        erc1155: data.isOwnNft.erc1155
                    )))
                case .failure(let error):
                    promise(.failure(.plain(error.localizedDescription)))
                }
            }
        }
    }

    func createERC721(workId: String, gsPath: String) -> Future<Void, AppError> {
        return Future<Void, AppError> { promise in
            cli.perform(mutation: NftAPI.CreateErc721Mutation(workId: workId, gsPath: gsPath)) { result in
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
                    promise(.failure(.plain(error.localizedDescription)))
                }
            }
        }
    }

    func createERC1155(workId: String, gsPath: String, amount: Int) -> Future<Void, AppError> {
        return Future<Void, AppError> { promise in
            cli.perform(mutation: NftAPI.CreateErc1155Mutation(workId: workId, gsPath: gsPath, amount: amount)) { result in
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
                    promise(.failure(.plain(error.localizedDescription)))
                }
            }
        }
    }

    func sellERC721(workId: String, ether: Double) -> Future<Void, AppError> {
        return Future<Void, AppError> { promise in
            cli.perform(mutation: NftAPI.SellErc721Mutation(workId: workId, ether: ether)) { result in
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
                    promise(.failure(.plain(error.localizedDescription)))
                }
            }
        }
    }

    func sellERC1155(workId: String, ether: Double) -> Future<Void, AppError> {
        return Future<Void, AppError> { promise in
            cli.perform(mutation: NftAPI.SellErc1155Mutation(workId: workId, ether: ether)) { result in
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
                    promise(.failure(.plain(error.localizedDescription)))
                }
            }
        }
    }

    func transferERC721(workId: String, toAddress: String) -> Future<Void, AppError> {
        return Future<Void, AppError> { promise in
            cli.perform(mutation: NftAPI.TransferErc721Mutation(workId: workId, toAddress: toAddress)) { result in
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
                    promise(.failure(.plain(error.localizedDescription)))
                }
            }
        }
    }

    func transferERC1155(workId: String, toAddress: String) -> Future<Void, AppError> {
        return Future<Void, AppError> { promise in
            cli.perform(mutation: NftAPI.TransferErc1155Mutation(workId: workId, toAddress: toAddress)) { result in
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
                    promise(.failure(.plain(error.localizedDescription)))
                }
            }
        }
    }
}
