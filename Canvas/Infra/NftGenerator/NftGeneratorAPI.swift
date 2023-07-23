// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

/// NftGeneratorAPI namespace
public enum NftGeneratorAPI {
  public enum Schema: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
    public typealias RawValue = String
    case erc721
    case erc1155
    /// Auto generated constant for unknown enum values
    case __unknown(RawValue)

    public init?(rawValue: RawValue) {
      switch rawValue {
        case "ERC721": self = .erc721
        case "ERC1155": self = .erc1155
        default: self = .__unknown(rawValue)
      }
    }

    public var rawValue: RawValue {
      switch self {
        case .erc721: return "ERC721"
        case .erc1155: return "ERC1155"
        case .__unknown(let value): return value
      }
    }

    public static func == (lhs: Schema, rhs: Schema) -> Bool {
      switch (lhs, rhs) {
        case (.erc721, .erc721): return true
        case (.erc1155, .erc1155): return true
        case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
        default: return false
      }
    }

    public static var allCases: [Schema] {
      return [
        .erc721,
        .erc1155,
      ]
    }
  }

  public enum Network: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
    public typealias RawValue = String
    case avalanche
    /// Auto generated constant for unknown enum values
    case __unknown(RawValue)

    public init?(rawValue: RawValue) {
      switch rawValue {
        case "AVALANCHE": self = .avalanche
        default: self = .__unknown(rawValue)
      }
    }

    public var rawValue: RawValue {
      switch self {
        case .avalanche: return "AVALANCHE"
        case .__unknown(let value): return value
      }
    }

    public static func == (lhs: Network, rhs: Network) -> Bool {
      switch (lhs, rhs) {
        case (.avalanche, .avalanche): return true
        case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
        default: return false
      }
    }

    public static var allCases: [Network] {
      return [
        .avalanche,
      ]
    }
  }

  public final class GetWalletQuery: GraphQLQuery {
    /// The raw GraphQL definition of this operation.
    public let operationDefinition: String =
      """
      query GetWallet {
        wallet {
          __typename
          address
          balance
        }
      }
      """

    public let operationName: String = "GetWallet"

    public init() {
    }

    public struct Data: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["QueryRoot"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("wallet", type: .nonNull(.object(Wallet.selections))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(wallet: Wallet) {
        self.init(unsafeResultMap: ["__typename": "QueryRoot", "wallet": wallet.resultMap])
      }

      public var wallet: Wallet {
        get {
          return Wallet(unsafeResultMap: resultMap["wallet"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "wallet")
        }
      }

      public struct Wallet: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["MyWallet"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("address", type: .nonNull(.scalar(String.self))),
            GraphQLField("balance", type: .nonNull(.scalar(Double.self))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(address: String, balance: Double) {
          self.init(unsafeResultMap: ["__typename": "MyWallet", "address": address, "balance": balance])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var address: String {
          get {
            return resultMap["address"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "address")
          }
        }

        public var balance: Double {
          get {
            return resultMap["balance"]! as! Double
          }
          set {
            resultMap.updateValue(newValue, forKey: "balance")
          }
        }
      }
    }
  }

  public final class GetContractsQuery: GraphQLQuery {
    /// The raw GraphQL definition of this operation.
    public let operationDefinition: String =
      """
      query GetContracts($cursor: String, $limit: Int!) {
        wallet {
          __typename
          contracts(last: $limit, before: $cursor) {
            __typename
            pageInfo {
              __typename
              hasNextPage
            }
            edges {
              __typename
              cursor
              node {
                __typename
                ...ContractFragment
              }
            }
          }
        }
      }
      """

    public let operationName: String = "GetContracts"

    public var queryDocument: String {
      var document: String = operationDefinition
      document.append("\n" + ContractFragment.fragmentDefinition)
      document.append("\n" + TokenFragment.fragmentDefinition)
      return document
    }

    public var cursor: String?
    public var limit: Int

    public init(cursor: String? = nil, limit: Int) {
      self.cursor = cursor
      self.limit = limit
    }

    public var variables: GraphQLMap? {
      return ["cursor": cursor, "limit": limit]
    }

    public struct Data: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["QueryRoot"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("wallet", type: .nonNull(.object(Wallet.selections))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(wallet: Wallet) {
        self.init(unsafeResultMap: ["__typename": "QueryRoot", "wallet": wallet.resultMap])
      }

      public var wallet: Wallet {
        get {
          return Wallet(unsafeResultMap: resultMap["wallet"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "wallet")
        }
      }

      public struct Wallet: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["MyWallet"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("contracts", arguments: ["last": GraphQLVariable("limit"), "before": GraphQLVariable("cursor")], type: .nonNull(.object(Contract.selections))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(contracts: Contract) {
          self.init(unsafeResultMap: ["__typename": "MyWallet", "contracts": contracts.resultMap])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var contracts: Contract {
          get {
            return Contract(unsafeResultMap: resultMap["contracts"]! as! ResultMap)
          }
          set {
            resultMap.updateValue(newValue.resultMap, forKey: "contracts")
          }
        }

        public struct Contract: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["ContractConnection"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("pageInfo", type: .nonNull(.object(PageInfo.selections))),
              GraphQLField("edges", type: .nonNull(.list(.nonNull(.object(Edge.selections))))),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(pageInfo: PageInfo, edges: [Edge]) {
            self.init(unsafeResultMap: ["__typename": "ContractConnection", "pageInfo": pageInfo.resultMap, "edges": edges.map { (value: Edge) -> ResultMap in value.resultMap }])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          public var pageInfo: PageInfo {
            get {
              return PageInfo(unsafeResultMap: resultMap["pageInfo"]! as! ResultMap)
            }
            set {
              resultMap.updateValue(newValue.resultMap, forKey: "pageInfo")
            }
          }

          public var edges: [Edge] {
            get {
              return (resultMap["edges"] as! [ResultMap]).map { (value: ResultMap) -> Edge in Edge(unsafeResultMap: value) }
            }
            set {
              resultMap.updateValue(newValue.map { (value: Edge) -> ResultMap in value.resultMap }, forKey: "edges")
            }
          }

          public struct PageInfo: GraphQLSelectionSet {
            public static let possibleTypes: [String] = ["PageInfo"]

            public static var selections: [GraphQLSelection] {
              return [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("hasNextPage", type: .nonNull(.scalar(Bool.self))),
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(hasNextPage: Bool) {
              self.init(unsafeResultMap: ["__typename": "PageInfo", "hasNextPage": hasNextPage])
            }

            public var __typename: String {
              get {
                return resultMap["__typename"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "__typename")
              }
            }

            public var hasNextPage: Bool {
              get {
                return resultMap["hasNextPage"]! as! Bool
              }
              set {
                resultMap.updateValue(newValue, forKey: "hasNextPage")
              }
            }
          }

          public struct Edge: GraphQLSelectionSet {
            public static let possibleTypes: [String] = ["ContractEdge"]

            public static var selections: [GraphQLSelection] {
              return [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("cursor", type: .nonNull(.scalar(String.self))),
                GraphQLField("node", type: .nonNull(.object(Node.selections))),
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(cursor: String, node: Node) {
              self.init(unsafeResultMap: ["__typename": "ContractEdge", "cursor": cursor, "node": node.resultMap])
            }

            public var __typename: String {
              get {
                return resultMap["__typename"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "__typename")
              }
            }

            public var cursor: String {
              get {
                return resultMap["cursor"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "cursor")
              }
            }

            public var node: Node {
              get {
                return Node(unsafeResultMap: resultMap["node"]! as! ResultMap)
              }
              set {
                resultMap.updateValue(newValue.resultMap, forKey: "node")
              }
            }

            public struct Node: GraphQLSelectionSet {
              public static let possibleTypes: [String] = ["Contract"]

              public static var selections: [GraphQLSelection] {
                return [
                  GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                  GraphQLFragmentSpread(ContractFragment.self),
                ]
              }

              public private(set) var resultMap: ResultMap

              public init(unsafeResultMap: ResultMap) {
                self.resultMap = unsafeResultMap
              }

              public var __typename: String {
                get {
                  return resultMap["__typename"]! as! String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "__typename")
                }
              }

              public var fragments: Fragments {
                get {
                  return Fragments(unsafeResultMap: resultMap)
                }
                set {
                  resultMap += newValue.resultMap
                }
              }

              public struct Fragments {
                public private(set) var resultMap: ResultMap

                public init(unsafeResultMap: ResultMap) {
                  self.resultMap = unsafeResultMap
                }

                public var contractFragment: ContractFragment {
                  get {
                    return ContractFragment(unsafeResultMap: resultMap)
                  }
                  set {
                    resultMap += newValue.resultMap
                  }
                }
              }
            }
          }
        }
      }
    }
  }

  public final class GetTokensQuery: GraphQLQuery {
    /// The raw GraphQL definition of this operation.
    public let operationDefinition: String =
      """
      query GetTokens($address: ID!, $cursor: String, $limit: Int!) {
        contract(address: $address) {
          __typename
          tokens(last: $limit, before: $cursor) {
            __typename
            pageInfo {
              __typename
              hasNextPage
            }
            edges {
              __typename
              cursor
              node {
                __typename
                ...TokenFragment
              }
            }
          }
        }
      }
      """

    public let operationName: String = "GetTokens"

    public var queryDocument: String {
      var document: String = operationDefinition
      document.append("\n" + TokenFragment.fragmentDefinition)
      return document
    }

    public var address: GraphQLID
    public var cursor: String?
    public var limit: Int

    public init(address: GraphQLID, cursor: String? = nil, limit: Int) {
      self.address = address
      self.cursor = cursor
      self.limit = limit
    }

    public var variables: GraphQLMap? {
      return ["address": address, "cursor": cursor, "limit": limit]
    }

    public struct Data: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["QueryRoot"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("contract", arguments: ["address": GraphQLVariable("address")], type: .nonNull(.object(Contract.selections))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(contract: Contract) {
        self.init(unsafeResultMap: ["__typename": "QueryRoot", "contract": contract.resultMap])
      }

      public var contract: Contract {
        get {
          return Contract(unsafeResultMap: resultMap["contract"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "contract")
        }
      }

      public struct Contract: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["Contract"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("tokens", arguments: ["last": GraphQLVariable("limit"), "before": GraphQLVariable("cursor")], type: .nonNull(.object(Token.selections))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(tokens: Token) {
          self.init(unsafeResultMap: ["__typename": "Contract", "tokens": tokens.resultMap])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var tokens: Token {
          get {
            return Token(unsafeResultMap: resultMap["tokens"]! as! ResultMap)
          }
          set {
            resultMap.updateValue(newValue.resultMap, forKey: "tokens")
          }
        }

        public struct Token: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["TokenConnection"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("pageInfo", type: .nonNull(.object(PageInfo.selections))),
              GraphQLField("edges", type: .nonNull(.list(.nonNull(.object(Edge.selections))))),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(pageInfo: PageInfo, edges: [Edge]) {
            self.init(unsafeResultMap: ["__typename": "TokenConnection", "pageInfo": pageInfo.resultMap, "edges": edges.map { (value: Edge) -> ResultMap in value.resultMap }])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          public var pageInfo: PageInfo {
            get {
              return PageInfo(unsafeResultMap: resultMap["pageInfo"]! as! ResultMap)
            }
            set {
              resultMap.updateValue(newValue.resultMap, forKey: "pageInfo")
            }
          }

          public var edges: [Edge] {
            get {
              return (resultMap["edges"] as! [ResultMap]).map { (value: ResultMap) -> Edge in Edge(unsafeResultMap: value) }
            }
            set {
              resultMap.updateValue(newValue.map { (value: Edge) -> ResultMap in value.resultMap }, forKey: "edges")
            }
          }

          public struct PageInfo: GraphQLSelectionSet {
            public static let possibleTypes: [String] = ["PageInfo"]

            public static var selections: [GraphQLSelection] {
              return [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("hasNextPage", type: .nonNull(.scalar(Bool.self))),
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(hasNextPage: Bool) {
              self.init(unsafeResultMap: ["__typename": "PageInfo", "hasNextPage": hasNextPage])
            }

            public var __typename: String {
              get {
                return resultMap["__typename"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "__typename")
              }
            }

            public var hasNextPage: Bool {
              get {
                return resultMap["hasNextPage"]! as! Bool
              }
              set {
                resultMap.updateValue(newValue, forKey: "hasNextPage")
              }
            }
          }

          public struct Edge: GraphQLSelectionSet {
            public static let possibleTypes: [String] = ["TokenEdge"]

            public static var selections: [GraphQLSelection] {
              return [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("cursor", type: .nonNull(.scalar(String.self))),
                GraphQLField("node", type: .nonNull(.object(Node.selections))),
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(cursor: String, node: Node) {
              self.init(unsafeResultMap: ["__typename": "TokenEdge", "cursor": cursor, "node": node.resultMap])
            }

            public var __typename: String {
              get {
                return resultMap["__typename"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "__typename")
              }
            }

            public var cursor: String {
              get {
                return resultMap["cursor"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "cursor")
              }
            }

            public var node: Node {
              get {
                return Node(unsafeResultMap: resultMap["node"]! as! ResultMap)
              }
              set {
                resultMap.updateValue(newValue.resultMap, forKey: "node")
              }
            }

            public struct Node: GraphQLSelectionSet {
              public static let possibleTypes: [String] = ["Token"]

              public static var selections: [GraphQLSelection] {
                return [
                  GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                  GraphQLFragmentSpread(TokenFragment.self),
                ]
              }

              public private(set) var resultMap: ResultMap

              public init(unsafeResultMap: ResultMap) {
                self.resultMap = unsafeResultMap
              }

              public init(id: GraphQLID, address: String, tokenId: String, imageUrl: String, name: String, description: String, priceEth: Double? = nil, isOwner: Bool, createdAt: String) {
                self.init(unsafeResultMap: ["__typename": "Token", "id": id, "address": address, "tokenId": tokenId, "imageUrl": imageUrl, "name": name, "description": description, "priceEth": priceEth, "isOwner": isOwner, "createdAt": createdAt])
              }

              public var __typename: String {
                get {
                  return resultMap["__typename"]! as! String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "__typename")
                }
              }

              public var fragments: Fragments {
                get {
                  return Fragments(unsafeResultMap: resultMap)
                }
                set {
                  resultMap += newValue.resultMap
                }
              }

              public struct Fragments {
                public private(set) var resultMap: ResultMap

                public init(unsafeResultMap: ResultMap) {
                  self.resultMap = unsafeResultMap
                }

                public var tokenFragment: TokenFragment {
                  get {
                    return TokenFragment(unsafeResultMap: resultMap)
                  }
                  set {
                    resultMap += newValue.resultMap
                  }
                }
              }
            }
          }
        }
      }
    }
  }

  public final class MintMutation: GraphQLMutation {
    /// The raw GraphQL definition of this operation.
    public let operationDefinition: String =
      """
      mutation Mint($workId: String!, $gsPath: String!) {
        mint(input: {workId: $workId, gsPath: $gsPath, isAsync: true})
      }
      """

    public let operationName: String = "Mint"

    public var workId: String
    public var gsPath: String

    public init(workId: String, gsPath: String) {
      self.workId = workId
      self.gsPath = gsPath
    }

    public var variables: GraphQLMap? {
      return ["workId": workId, "gsPath": gsPath]
    }

    public struct Data: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["MutationRoot"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("mint", arguments: ["input": ["workId": GraphQLVariable("workId"), "gsPath": GraphQLVariable("gsPath"), "isAsync": true]], type: .nonNull(.scalar(Bool.self))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(mint: Bool) {
        self.init(unsafeResultMap: ["__typename": "MutationRoot", "mint": mint])
      }

      public var mint: Bool {
        get {
          return resultMap["mint"]! as! Bool
        }
        set {
          resultMap.updateValue(newValue, forKey: "mint")
        }
      }
    }
  }

  public final class SellMutation: GraphQLMutation {
    /// The raw GraphQL definition of this operation.
    public let operationDefinition: String =
      """
      mutation Sell($address: String!, $tokenId: String!, $ether: Float!) {
        sell(
          input: {address: $address, tokenId: $tokenId, ether: $ether, isAsync: true}
        )
      }
      """

    public let operationName: String = "Sell"

    public var address: String
    public var tokenId: String
    public var ether: Double

    public init(address: String, tokenId: String, ether: Double) {
      self.address = address
      self.tokenId = tokenId
      self.ether = ether
    }

    public var variables: GraphQLMap? {
      return ["address": address, "tokenId": tokenId, "ether": ether]
    }

    public struct Data: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["MutationRoot"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("sell", arguments: ["input": ["address": GraphQLVariable("address"), "tokenId": GraphQLVariable("tokenId"), "ether": GraphQLVariable("ether"), "isAsync": true]], type: .nonNull(.scalar(Bool.self))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(sell: Bool) {
        self.init(unsafeResultMap: ["__typename": "MutationRoot", "sell": sell])
      }

      public var sell: Bool {
        get {
          return resultMap["sell"]! as! Bool
        }
        set {
          resultMap.updateValue(newValue, forKey: "sell")
        }
      }
    }
  }

  public final class TransferMutation: GraphQLMutation {
    /// The raw GraphQL definition of this operation.
    public let operationDefinition: String =
      """
      mutation Transfer($address: String!, $tokenId: String!, $toAddress: String!) {
        transfer(
          input: {address: $address, tokenId: $tokenId, toAddress: $toAddress, isAsync: true}
        )
      }
      """

    public let operationName: String = "Transfer"

    public var address: String
    public var tokenId: String
    public var toAddress: String

    public init(address: String, tokenId: String, toAddress: String) {
      self.address = address
      self.tokenId = tokenId
      self.toAddress = toAddress
    }

    public var variables: GraphQLMap? {
      return ["address": address, "tokenId": tokenId, "toAddress": toAddress]
    }

    public struct Data: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["MutationRoot"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("transfer", arguments: ["input": ["address": GraphQLVariable("address"), "tokenId": GraphQLVariable("tokenId"), "toAddress": GraphQLVariable("toAddress"), "isAsync": true]], type: .nonNull(.scalar(Bool.self))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(transfer: Bool) {
        self.init(unsafeResultMap: ["__typename": "MutationRoot", "transfer": transfer])
      }

      public var transfer: Bool {
        get {
          return resultMap["transfer"]! as! Bool
        }
        set {
          resultMap.updateValue(newValue, forKey: "transfer")
        }
      }
    }
  }

  public struct ContractFragment: GraphQLFragment {
    /// The raw GraphQL definition of this fragment.
    public static let fragmentDefinition: String =
      """
      fragment ContractFragment on Contract {
        __typename
        address
        name
        schema
        network
        createdAt
        tokens(last: 3) {
          __typename
          edges {
            __typename
            node {
              __typename
              ...TokenFragment
            }
          }
        }
      }
      """

    public static let possibleTypes: [String] = ["Contract"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("address", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("name", type: .nonNull(.scalar(String.self))),
        GraphQLField("schema", type: .nonNull(.scalar(Schema.self))),
        GraphQLField("network", type: .nonNull(.scalar(Network.self))),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("tokens", arguments: ["last": 3], type: .nonNull(.object(Token.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(address: GraphQLID, name: String, schema: Schema, network: Network, createdAt: String, tokens: Token) {
      self.init(unsafeResultMap: ["__typename": "Contract", "address": address, "name": name, "schema": schema, "network": network, "createdAt": createdAt, "tokens": tokens.resultMap])
    }

    public var __typename: String {
      get {
        return resultMap["__typename"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "__typename")
      }
    }

    public var address: GraphQLID {
      get {
        return resultMap["address"]! as! GraphQLID
      }
      set {
        resultMap.updateValue(newValue, forKey: "address")
      }
    }

    public var name: String {
      get {
        return resultMap["name"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "name")
      }
    }

    public var schema: Schema {
      get {
        return resultMap["schema"]! as! Schema
      }
      set {
        resultMap.updateValue(newValue, forKey: "schema")
      }
    }

    public var network: Network {
      get {
        return resultMap["network"]! as! Network
      }
      set {
        resultMap.updateValue(newValue, forKey: "network")
      }
    }

    public var createdAt: String {
      get {
        return resultMap["createdAt"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "createdAt")
      }
    }

    public var tokens: Token {
      get {
        return Token(unsafeResultMap: resultMap["tokens"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "tokens")
      }
    }

    public struct Token: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["TokenConnection"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("edges", type: .nonNull(.list(.nonNull(.object(Edge.selections))))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(edges: [Edge]) {
        self.init(unsafeResultMap: ["__typename": "TokenConnection", "edges": edges.map { (value: Edge) -> ResultMap in value.resultMap }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var edges: [Edge] {
        get {
          return (resultMap["edges"] as! [ResultMap]).map { (value: ResultMap) -> Edge in Edge(unsafeResultMap: value) }
        }
        set {
          resultMap.updateValue(newValue.map { (value: Edge) -> ResultMap in value.resultMap }, forKey: "edges")
        }
      }

      public struct Edge: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["TokenEdge"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("node", type: .nonNull(.object(Node.selections))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(node: Node) {
          self.init(unsafeResultMap: ["__typename": "TokenEdge", "node": node.resultMap])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var node: Node {
          get {
            return Node(unsafeResultMap: resultMap["node"]! as! ResultMap)
          }
          set {
            resultMap.updateValue(newValue.resultMap, forKey: "node")
          }
        }

        public struct Node: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["Token"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLFragmentSpread(TokenFragment.self),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(id: GraphQLID, address: String, tokenId: String, imageUrl: String, name: String, description: String, priceEth: Double? = nil, isOwner: Bool, createdAt: String) {
            self.init(unsafeResultMap: ["__typename": "Token", "id": id, "address": address, "tokenId": tokenId, "imageUrl": imageUrl, "name": name, "description": description, "priceEth": priceEth, "isOwner": isOwner, "createdAt": createdAt])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          public var fragments: Fragments {
            get {
              return Fragments(unsafeResultMap: resultMap)
            }
            set {
              resultMap += newValue.resultMap
            }
          }

          public struct Fragments {
            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public var tokenFragment: TokenFragment {
              get {
                return TokenFragment(unsafeResultMap: resultMap)
              }
              set {
                resultMap += newValue.resultMap
              }
            }
          }
        }
      }
    }
  }

  public struct TokenFragment: GraphQLFragment {
    /// The raw GraphQL definition of this fragment.
    public static let fragmentDefinition: String =
      """
      fragment TokenFragment on Token {
        __typename
        id
        address
        tokenId
        imageUrl
        name
        description
        priceEth
        isOwner
        createdAt
      }
      """

    public static let possibleTypes: [String] = ["Token"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("address", type: .nonNull(.scalar(String.self))),
        GraphQLField("tokenId", type: .nonNull(.scalar(String.self))),
        GraphQLField("imageUrl", type: .nonNull(.scalar(String.self))),
        GraphQLField("name", type: .nonNull(.scalar(String.self))),
        GraphQLField("description", type: .nonNull(.scalar(String.self))),
        GraphQLField("priceEth", type: .scalar(Double.self)),
        GraphQLField("isOwner", type: .nonNull(.scalar(Bool.self))),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(id: GraphQLID, address: String, tokenId: String, imageUrl: String, name: String, description: String, priceEth: Double? = nil, isOwner: Bool, createdAt: String) {
      self.init(unsafeResultMap: ["__typename": "Token", "id": id, "address": address, "tokenId": tokenId, "imageUrl": imageUrl, "name": name, "description": description, "priceEth": priceEth, "isOwner": isOwner, "createdAt": createdAt])
    }

    public var __typename: String {
      get {
        return resultMap["__typename"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "__typename")
      }
    }

    public var id: GraphQLID {
      get {
        return resultMap["id"]! as! GraphQLID
      }
      set {
        resultMap.updateValue(newValue, forKey: "id")
      }
    }

    public var address: String {
      get {
        return resultMap["address"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "address")
      }
    }

    public var tokenId: String {
      get {
        return resultMap["tokenId"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "tokenId")
      }
    }

    public var imageUrl: String {
      get {
        return resultMap["imageUrl"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "imageUrl")
      }
    }

    public var name: String {
      get {
        return resultMap["name"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "name")
      }
    }

    public var description: String {
      get {
        return resultMap["description"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "description")
      }
    }

    public var priceEth: Double? {
      get {
        return resultMap["priceEth"] as? Double
      }
      set {
        resultMap.updateValue(newValue, forKey: "priceEth")
      }
    }

    public var isOwner: Bool {
      get {
        return resultMap["isOwner"]! as! Bool
      }
      set {
        resultMap.updateValue(newValue, forKey: "isOwner")
      }
    }

    public var createdAt: String {
      get {
        return resultMap["createdAt"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "createdAt")
      }
    }
  }
}
