import Apollo
import Combine
import Foundation

extension NftGeneratorAPI.ContractFragment: Identifiable, Equatable {
    public var id: String {
        return address
    }

    public static func == (lhs: NftGeneratorAPI.ContractFragment, rhs: NftGeneratorAPI.ContractFragment) -> Bool {
        return lhs.id == rhs.id
    }
}

extension NftGeneratorAPI.TokenFragment: Identifiable, Equatable {
    public static func == (lhs: NftGeneratorAPI.TokenFragment, rhs: NftGeneratorAPI.TokenFragment) -> Bool {
        return lhs.id == rhs.id
    }
}

struct NftGeneratorClient {
    static let shared = NftGeneratorClient()

    func caller() -> Future<NftCaller, AppError> {
        return Future<NftCaller, AppError> { promise in
            let cache = InMemoryNormalizedCache()
            let store = ApolloStore(cache: cache)
            let configuration = URLSessionConfiguration.default
            configuration.timeoutIntervalForRequest = 60.0
            configuration.timeoutIntervalForResource = 60.0
            let client = URLSessionClient(sessionConfiguration: configuration)
            let provider = NetworkInterceptorProvider(store: store, client: client)

            let transport = RequestChainNetworkTransport(
                interceptorProvider: provider,
                endpointURL: URL(string: "https://canvas-nft-generator.akiho.app/graphql")!,
                additionalHeaders: ["x-sig": "dfc098a0c28eb19095c8857b0110918dff82907507572db21f811cbb34b6720c0a391da40955f48851dd17187e1477ffec520580f453922d1152bf4ff721b9681c"]
            )

            let apollo = ApolloClient(networkTransport: transport, store: store)

            promise(.success(NftCaller(cli: apollo)))
        }
    }
}

struct NftCaller {
    let cli: ApolloClient

    func wallet() -> Future<(address: String, balance: Double), AppError> {
        return Future<(address: String, balance: Double), AppError> { promise in
            cli.fetch(query: NftGeneratorAPI.GetWalletQuery()) { result in
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

                    promise(.success((address: data.wallet.address, balance: data.wallet.balance)))
                case .failure(let error):
                    promise(.failure(.plain(error.localizedDescription)))
                }
            }
        }
    }

    func contracts(cursor: String?) -> Future<([NftGeneratorAPI.ContractFragment], String?), AppError> {
        return Future<([NftGeneratorAPI.ContractFragment], String?), AppError> { promise in
            cli.fetch(query: NftGeneratorAPI.GetContractsQuery(cursor: cursor, limit: 10)) { result in
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

                    promise(.success((data.wallet.contracts.edges.map { $0.node.fragments.contractFragment }, data.wallet.contracts.edges.last?.cursor)))
                case .failure(let error):
                    promise(.failure(.plain(error.localizedDescription)))
                }
            }
        }
    }

    func tokens(address: String, cursor: String?) -> Future<([NftGeneratorAPI.TokenFragment], String?), AppError> {
        return Future<([NftGeneratorAPI.TokenFragment], String?), AppError> { promise in
            cli.fetch(query: NftGeneratorAPI.GetTokensQuery(address: address, cursor: cursor, limit: 18)) { result in
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

                    promise(.success((data.contract.tokens.edges.map { $0.node.fragments.tokenFragment }, data.contract.tokens.edges.last?.cursor)))
                case .failure(let error):
                    promise(.failure(.plain(error.localizedDescription)))
                }
            }
        }
    }

    func mint(workId: String, gsPath: String) -> Future<Void, AppError> {
        return Future<Void, AppError> { promise in
            cli.perform(mutation: NftGeneratorAPI.MintMutation(workId: workId, gsPath: gsPath)) { result in
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

    func sell(address: String, tokenId: String, ether: Double) -> Future<Void, AppError> {
        return Future<Void, AppError> { promise in
            cli.perform(mutation: NftGeneratorAPI.SellMutation(address: address, tokenId: tokenId, ether: ether)) { result in
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

    func transfer(address: String, tokenId: String, toAddress: String) -> Future<Void, AppError> {
        return Future<Void, AppError> { promise in
            cli.perform(mutation: NftGeneratorAPI.TransferMutation(address: address, tokenId: tokenId, toAddress: toAddress)) { result in
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
