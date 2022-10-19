// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

/// NftAPI namespace
public enum NftAPI {
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
    case rinkeby
    case goerli
    /// Auto generated constant for unknown enum values
    case __unknown(RawValue)

    public init?(rawValue: RawValue) {
      switch rawValue {
        case "RINKEBY": self = .rinkeby
        case "GOERLI": self = .goerli
        default: self = .__unknown(rawValue)
      }
    }

    public var rawValue: RawValue {
      switch self {
        case .rinkeby: return "RINKEBY"
        case .goerli: return "GOERLI"
        case .__unknown(let value): return value
      }
    }

    public static func == (lhs: Network, rhs: Network) -> Bool {
      switch (lhs, rhs) {
        case (.rinkeby, .rinkeby): return true
        case (.goerli, .goerli): return true
        case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
        default: return false
      }
    }

    public static var allCases: [Network] {
      return [
        .rinkeby,
        .goerli,
      ]
    }
  }

  public final class GetMeQuery: GraphQLQuery {
    /// The raw GraphQL definition of this operation.
    public let operationDefinition: String =
      """
      query GetMe {
        me {
          __typename
          id
          walletAddress
          balance
          erc721Balance
          erc1155Balance {
            __typename
            tokenName
            balance
          }
        }
      }
      """

    public let operationName: String = "GetMe"

    public init() {
    }

    public struct Data: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["QueryRoot"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("me", type: .nonNull(.object(Me.selections))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(me: Me) {
        self.init(unsafeResultMap: ["__typename": "QueryRoot", "me": me.resultMap])
      }

      public var me: Me {
        get {
          return Me(unsafeResultMap: resultMap["me"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "me")
        }
      }

      public struct Me: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["Publisher"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .nonNull(.scalar(String.self))),
            GraphQLField("walletAddress", type: .nonNull(.scalar(String.self))),
            GraphQLField("balance", type: .nonNull(.scalar(Double.self))),
            GraphQLField("erc721Balance", type: .nonNull(.scalar(Int.self))),
            GraphQLField("erc1155Balance", type: .nonNull(.list(.nonNull(.object(Erc1155Balance.selections))))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(id: String, walletAddress: String, balance: Double, erc721Balance: Int, erc1155Balance: [Erc1155Balance]) {
          self.init(unsafeResultMap: ["__typename": "Publisher", "id": id, "walletAddress": walletAddress, "balance": balance, "erc721Balance": erc721Balance, "erc1155Balance": erc1155Balance.map { (value: Erc1155Balance) -> ResultMap in value.resultMap }])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: String {
          get {
            return resultMap["id"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "id")
          }
        }

        public var walletAddress: String {
          get {
            return resultMap["walletAddress"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "walletAddress")
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

        public var erc721Balance: Int {
          get {
            return resultMap["erc721Balance"]! as! Int
          }
          set {
            resultMap.updateValue(newValue, forKey: "erc721Balance")
          }
        }

        public var erc1155Balance: [Erc1155Balance] {
          get {
            return (resultMap["erc1155Balance"] as! [ResultMap]).map { (value: ResultMap) -> Erc1155Balance in Erc1155Balance(unsafeResultMap: value) }
          }
          set {
            resultMap.updateValue(newValue.map { (value: Erc1155Balance) -> ResultMap in value.resultMap }, forKey: "erc1155Balance")
          }
        }

        public struct Erc1155Balance: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["Nft1155Balance"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("tokenName", type: .nonNull(.scalar(String.self))),
              GraphQLField("balance", type: .nonNull(.scalar(Int.self))),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(tokenName: String, balance: Int) {
            self.init(unsafeResultMap: ["__typename": "Nft1155Balance", "tokenName": tokenName, "balance": balance])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          public var tokenName: String {
            get {
              return resultMap["tokenName"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "tokenName")
            }
          }

          public var balance: Int {
            get {
              return resultMap["balance"]! as! Int
            }
            set {
              resultMap.updateValue(newValue, forKey: "balance")
            }
          }
        }
      }
    }
  }

  public final class GetMintedTokenQuery: GraphQLQuery {
    /// The raw GraphQL definition of this operation.
    public let operationDefinition: String =
      """
      query GetMintedToken($workId: String!) {
        mintedToken(workId: $workId) {
          __typename
          erc721 {
            __typename
            ...TokenFragment
          }
          erc1155 {
            __typename
            ...TokenFragment
          }
        }
      }
      """

    public let operationName: String = "GetMintedToken"

    public var queryDocument: String {
      var document: String = operationDefinition
      document.append("\n" + TokenFragment.fragmentDefinition)
      return document
    }

    public var workId: String

    public init(workId: String) {
      self.workId = workId
    }

    public var variables: GraphQLMap? {
      return ["workId": workId]
    }

    public struct Data: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["QueryRoot"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("mintedToken", arguments: ["workId": GraphQLVariable("workId")], type: .nonNull(.object(MintedToken.selections))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(mintedToken: MintedToken) {
        self.init(unsafeResultMap: ["__typename": "QueryRoot", "mintedToken": mintedToken.resultMap])
      }

      public var mintedToken: MintedToken {
        get {
          return MintedToken(unsafeResultMap: resultMap["mintedToken"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "mintedToken")
        }
      }

      public struct MintedToken: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["MintedToken"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("erc721", type: .object(Erc721.selections)),
            GraphQLField("erc1155", type: .object(Erc1155.selections)),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(erc721: Erc721? = nil, erc1155: Erc1155? = nil) {
          self.init(unsafeResultMap: ["__typename": "MintedToken", "erc721": erc721.flatMap { (value: Erc721) -> ResultMap in value.resultMap }, "erc1155": erc1155.flatMap { (value: Erc1155) -> ResultMap in value.resultMap }])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var erc721: Erc721? {
          get {
            return (resultMap["erc721"] as? ResultMap).flatMap { Erc721(unsafeResultMap: $0) }
          }
          set {
            resultMap.updateValue(newValue?.resultMap, forKey: "erc721")
          }
        }

        public var erc1155: Erc1155? {
          get {
            return (resultMap["erc1155"] as? ResultMap).flatMap { Erc1155(unsafeResultMap: $0) }
          }
          set {
            resultMap.updateValue(newValue?.resultMap, forKey: "erc1155")
          }
        }

        public struct Erc721: GraphQLSelectionSet {
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

          public init(address: String, workId: String, tokenId: String, name: String, description: String, imageUrl: String, isOwn: Bool, priceEth: Double? = nil) {
            self.init(unsafeResultMap: ["__typename": "Token", "address": address, "workId": workId, "tokenId": tokenId, "name": name, "description": description, "imageUrl": imageUrl, "isOwn": isOwn, "priceEth": priceEth])
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

        public struct Erc1155: GraphQLSelectionSet {
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

          public init(address: String, workId: String, tokenId: String, name: String, description: String, imageUrl: String, isOwn: Bool, priceEth: Double? = nil) {
            self.init(unsafeResultMap: ["__typename": "Token", "address": address, "workId": workId, "tokenId": tokenId, "name": name, "description": description, "imageUrl": imageUrl, "isOwn": isOwn, "priceEth": priceEth])
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

  public final class GetContractsQuery: GraphQLQuery {
    /// The raw GraphQL definition of this operation.
    public let operationDefinition: String =
      """
      query GetContracts($cursor: String, $limit: Int!) {
        contracts(nextKey: $cursor, limit: $limit) {
          __typename
          edges {
            __typename
            node {
              __typename
              ...ContractFragment
            }
          }
          nextKey
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
          GraphQLField("contracts", arguments: ["nextKey": GraphQLVariable("cursor"), "limit": GraphQLVariable("limit")], type: .nonNull(.object(Contract.selections))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(contracts: Contract) {
        self.init(unsafeResultMap: ["__typename": "QueryRoot", "contracts": contracts.resultMap])
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
            GraphQLField("edges", type: .nonNull(.list(.nonNull(.object(Edge.selections))))),
            GraphQLField("nextKey", type: .nonNull(.scalar(String.self))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(edges: [Edge], nextKey: String) {
          self.init(unsafeResultMap: ["__typename": "ContractConnection", "edges": edges.map { (value: Edge) -> ResultMap in value.resultMap }, "nextKey": nextKey])
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

        public var nextKey: String {
          get {
            return resultMap["nextKey"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "nextKey")
          }
        }

        public struct Edge: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["ContractEdge"]

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
            self.init(unsafeResultMap: ["__typename": "ContractEdge", "node": node.resultMap])
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

  public final class GetTokensQuery: GraphQLQuery {
    /// The raw GraphQL definition of this operation.
    public let operationDefinition: String =
      """
      query GetTokens($address: String!, $cursor: String, $limit: Int!) {
        tokens(address: $address, nextKey: $cursor, limit: $limit) {
          __typename
          edges {
            __typename
            node {
              __typename
              ...TokenFragment
            }
          }
          nextKey
        }
      }
      """

    public let operationName: String = "GetTokens"

    public var queryDocument: String {
      var document: String = operationDefinition
      document.append("\n" + TokenFragment.fragmentDefinition)
      return document
    }

    public var address: String
    public var cursor: String?
    public var limit: Int

    public init(address: String, cursor: String? = nil, limit: Int) {
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
          GraphQLField("tokens", arguments: ["address": GraphQLVariable("address"), "nextKey": GraphQLVariable("cursor"), "limit": GraphQLVariable("limit")], type: .nonNull(.object(Token.selections))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(tokens: Token) {
        self.init(unsafeResultMap: ["__typename": "QueryRoot", "tokens": tokens.resultMap])
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
            GraphQLField("nextKey", type: .nonNull(.scalar(String.self))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(edges: [Edge], nextKey: String) {
          self.init(unsafeResultMap: ["__typename": "TokenConnection", "edges": edges.map { (value: Edge) -> ResultMap in value.resultMap }, "nextKey": nextKey])
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

        public var nextKey: String {
          get {
            return resultMap["nextKey"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "nextKey")
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

            public init(address: String, workId: String, tokenId: String, name: String, description: String, imageUrl: String, isOwn: Bool, priceEth: Double? = nil) {
              self.init(unsafeResultMap: ["__typename": "Token", "address": address, "workId": workId, "tokenId": tokenId, "name": name, "description": description, "imageUrl": imageUrl, "isOwn": isOwn, "priceEth": priceEth])
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

  public final class GetMultiTokensQuery: GraphQLQuery {
    /// The raw GraphQL definition of this operation.
    public let operationDefinition: String =
      """
      query GetMultiTokens($address: String!, $cursor: String, $limit: Int!) {
        multiTokens(address: $address, nextKey: $cursor, limit: $limit) {
          __typename
          edges {
            __typename
            node {
              __typename
              ...TokenFragment
            }
          }
          nextKey
        }
      }
      """

    public let operationName: String = "GetMultiTokens"

    public var queryDocument: String {
      var document: String = operationDefinition
      document.append("\n" + TokenFragment.fragmentDefinition)
      return document
    }

    public var address: String
    public var cursor: String?
    public var limit: Int

    public init(address: String, cursor: String? = nil, limit: Int) {
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
          GraphQLField("multiTokens", arguments: ["address": GraphQLVariable("address"), "nextKey": GraphQLVariable("cursor"), "limit": GraphQLVariable("limit")], type: .nonNull(.object(MultiToken.selections))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(multiTokens: MultiToken) {
        self.init(unsafeResultMap: ["__typename": "QueryRoot", "multiTokens": multiTokens.resultMap])
      }

      public var multiTokens: MultiToken {
        get {
          return MultiToken(unsafeResultMap: resultMap["multiTokens"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "multiTokens")
        }
      }

      public struct MultiToken: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["TokenConnection"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("edges", type: .nonNull(.list(.nonNull(.object(Edge.selections))))),
            GraphQLField("nextKey", type: .nonNull(.scalar(String.self))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(edges: [Edge], nextKey: String) {
          self.init(unsafeResultMap: ["__typename": "TokenConnection", "edges": edges.map { (value: Edge) -> ResultMap in value.resultMap }, "nextKey": nextKey])
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

        public var nextKey: String {
          get {
            return resultMap["nextKey"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "nextKey")
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

            public init(address: String, workId: String, tokenId: String, name: String, description: String, imageUrl: String, isOwn: Bool, priceEth: Double? = nil) {
              self.init(unsafeResultMap: ["__typename": "Token", "address": address, "workId": workId, "tokenId": tokenId, "name": name, "description": description, "imageUrl": imageUrl, "isOwn": isOwn, "priceEth": priceEth])
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

  public final class MintErc721Mutation: GraphQLMutation {
    /// The raw GraphQL definition of this operation.
    public let operationDefinition: String =
      """
      mutation MintERC721($workId: String!, $gsPath: String!) {
        mintErc721(
          input: {workId: $workId, gsPath: $gsPath, useIpfs: true, isAsync: true}
        )
      }
      """

    public let operationName: String = "MintERC721"

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
          GraphQLField("mintErc721", arguments: ["input": ["workId": GraphQLVariable("workId"), "gsPath": GraphQLVariable("gsPath"), "useIpfs": true, "isAsync": true]], type: .nonNull(.scalar(Bool.self))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(mintErc721: Bool) {
        self.init(unsafeResultMap: ["__typename": "MutationRoot", "mintErc721": mintErc721])
      }

      public var mintErc721: Bool {
        get {
          return resultMap["mintErc721"]! as! Bool
        }
        set {
          resultMap.updateValue(newValue, forKey: "mintErc721")
        }
      }
    }
  }

  public final class MintErc1155Mutation: GraphQLMutation {
    /// The raw GraphQL definition of this operation.
    public let operationDefinition: String =
      """
      mutation MintERC1155($workId: String!, $gsPath: String!, $amount: Int!) {
        mintErc1155(
          input: {workId: $workId, gsPath: $gsPath, amount: $amount, useIpfs: true, isAsync: true}
        )
      }
      """

    public let operationName: String = "MintERC1155"

    public var workId: String
    public var gsPath: String
    public var amount: Int

    public init(workId: String, gsPath: String, amount: Int) {
      self.workId = workId
      self.gsPath = gsPath
      self.amount = amount
    }

    public var variables: GraphQLMap? {
      return ["workId": workId, "gsPath": gsPath, "amount": amount]
    }

    public struct Data: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["MutationRoot"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("mintErc1155", arguments: ["input": ["workId": GraphQLVariable("workId"), "gsPath": GraphQLVariable("gsPath"), "amount": GraphQLVariable("amount"), "useIpfs": true, "isAsync": true]], type: .nonNull(.scalar(Bool.self))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(mintErc1155: Bool) {
        self.init(unsafeResultMap: ["__typename": "MutationRoot", "mintErc1155": mintErc1155])
      }

      public var mintErc1155: Bool {
        get {
          return resultMap["mintErc1155"]! as! Bool
        }
        set {
          resultMap.updateValue(newValue, forKey: "mintErc1155")
        }
      }
    }
  }

  public final class SellErc721Mutation: GraphQLMutation {
    /// The raw GraphQL definition of this operation.
    public let operationDefinition: String =
      """
      mutation SellERC721($workId: String!, $ether: Float!) {
        sellErc721(input: {workId: $workId, ether: $ether}) {
          __typename
          ...TokenFragment
        }
      }
      """

    public let operationName: String = "SellERC721"

    public var queryDocument: String {
      var document: String = operationDefinition
      document.append("\n" + TokenFragment.fragmentDefinition)
      return document
    }

    public var workId: String
    public var ether: Double

    public init(workId: String, ether: Double) {
      self.workId = workId
      self.ether = ether
    }

    public var variables: GraphQLMap? {
      return ["workId": workId, "ether": ether]
    }

    public struct Data: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["MutationRoot"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("sellErc721", arguments: ["input": ["workId": GraphQLVariable("workId"), "ether": GraphQLVariable("ether")]], type: .nonNull(.object(SellErc721.selections))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(sellErc721: SellErc721) {
        self.init(unsafeResultMap: ["__typename": "MutationRoot", "sellErc721": sellErc721.resultMap])
      }

      public var sellErc721: SellErc721 {
        get {
          return SellErc721(unsafeResultMap: resultMap["sellErc721"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "sellErc721")
        }
      }

      public struct SellErc721: GraphQLSelectionSet {
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

        public init(address: String, workId: String, tokenId: String, name: String, description: String, imageUrl: String, isOwn: Bool, priceEth: Double? = nil) {
          self.init(unsafeResultMap: ["__typename": "Token", "address": address, "workId": workId, "tokenId": tokenId, "name": name, "description": description, "imageUrl": imageUrl, "isOwn": isOwn, "priceEth": priceEth])
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

  public final class SellErc1155Mutation: GraphQLMutation {
    /// The raw GraphQL definition of this operation.
    public let operationDefinition: String =
      """
      mutation SellERC1155($workId: String!, $ether: Float!) {
        sellErc1155(input: {workId: $workId, ether: $ether, amount: 1}) {
          __typename
          ...TokenFragment
        }
      }
      """

    public let operationName: String = "SellERC1155"

    public var queryDocument: String {
      var document: String = operationDefinition
      document.append("\n" + TokenFragment.fragmentDefinition)
      return document
    }

    public var workId: String
    public var ether: Double

    public init(workId: String, ether: Double) {
      self.workId = workId
      self.ether = ether
    }

    public var variables: GraphQLMap? {
      return ["workId": workId, "ether": ether]
    }

    public struct Data: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["MutationRoot"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("sellErc1155", arguments: ["input": ["workId": GraphQLVariable("workId"), "ether": GraphQLVariable("ether"), "amount": 1]], type: .nonNull(.object(SellErc1155.selections))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(sellErc1155: SellErc1155) {
        self.init(unsafeResultMap: ["__typename": "MutationRoot", "sellErc1155": sellErc1155.resultMap])
      }

      public var sellErc1155: SellErc1155 {
        get {
          return SellErc1155(unsafeResultMap: resultMap["sellErc1155"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "sellErc1155")
        }
      }

      public struct SellErc1155: GraphQLSelectionSet {
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

        public init(address: String, workId: String, tokenId: String, name: String, description: String, imageUrl: String, isOwn: Bool, priceEth: Double? = nil) {
          self.init(unsafeResultMap: ["__typename": "Token", "address": address, "workId": workId, "tokenId": tokenId, "name": name, "description": description, "imageUrl": imageUrl, "isOwn": isOwn, "priceEth": priceEth])
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

  public final class TransferErc721Mutation: GraphQLMutation {
    /// The raw GraphQL definition of this operation.
    public let operationDefinition: String =
      """
      mutation TransferERC721($workId: String!, $toAddress: String!) {
        transferErc721(input: {workId: $workId, toAddress: $toAddress}) {
          __typename
          ...TokenFragment
        }
      }
      """

    public let operationName: String = "TransferERC721"

    public var queryDocument: String {
      var document: String = operationDefinition
      document.append("\n" + TokenFragment.fragmentDefinition)
      return document
    }

    public var workId: String
    public var toAddress: String

    public init(workId: String, toAddress: String) {
      self.workId = workId
      self.toAddress = toAddress
    }

    public var variables: GraphQLMap? {
      return ["workId": workId, "toAddress": toAddress]
    }

    public struct Data: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["MutationRoot"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("transferErc721", arguments: ["input": ["workId": GraphQLVariable("workId"), "toAddress": GraphQLVariable("toAddress")]], type: .nonNull(.object(TransferErc721.selections))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(transferErc721: TransferErc721) {
        self.init(unsafeResultMap: ["__typename": "MutationRoot", "transferErc721": transferErc721.resultMap])
      }

      public var transferErc721: TransferErc721 {
        get {
          return TransferErc721(unsafeResultMap: resultMap["transferErc721"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "transferErc721")
        }
      }

      public struct TransferErc721: GraphQLSelectionSet {
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

        public init(address: String, workId: String, tokenId: String, name: String, description: String, imageUrl: String, isOwn: Bool, priceEth: Double? = nil) {
          self.init(unsafeResultMap: ["__typename": "Token", "address": address, "workId": workId, "tokenId": tokenId, "name": name, "description": description, "imageUrl": imageUrl, "isOwn": isOwn, "priceEth": priceEth])
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

  public final class TransferErc1155Mutation: GraphQLMutation {
    /// The raw GraphQL definition of this operation.
    public let operationDefinition: String =
      """
      mutation TransferERC1155($workId: String!, $toAddress: String!) {
        transferErc1155(input: {workId: $workId, toAddress: $toAddress, amount: 1}) {
          __typename
          ...TokenFragment
        }
      }
      """

    public let operationName: String = "TransferERC1155"

    public var queryDocument: String {
      var document: String = operationDefinition
      document.append("\n" + TokenFragment.fragmentDefinition)
      return document
    }

    public var workId: String
    public var toAddress: String

    public init(workId: String, toAddress: String) {
      self.workId = workId
      self.toAddress = toAddress
    }

    public var variables: GraphQLMap? {
      return ["workId": workId, "toAddress": toAddress]
    }

    public struct Data: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["MutationRoot"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("transferErc1155", arguments: ["input": ["workId": GraphQLVariable("workId"), "toAddress": GraphQLVariable("toAddress"), "amount": 1]], type: .nonNull(.object(TransferErc1155.selections))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(transferErc1155: TransferErc1155) {
        self.init(unsafeResultMap: ["__typename": "MutationRoot", "transferErc1155": transferErc1155.resultMap])
      }

      public var transferErc1155: TransferErc1155 {
        get {
          return TransferErc1155(unsafeResultMap: resultMap["transferErc1155"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "transferErc1155")
        }
      }

      public struct TransferErc1155: GraphQLSelectionSet {
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

        public init(address: String, workId: String, tokenId: String, name: String, description: String, imageUrl: String, isOwn: Bool, priceEth: Double? = nil) {
          self.init(unsafeResultMap: ["__typename": "Token", "address": address, "workId": workId, "tokenId": tokenId, "name": name, "description": description, "imageUrl": imageUrl, "isOwn": isOwn, "priceEth": priceEth])
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

  public final class BulkMintErc721Mutation: GraphQLMutation {
    /// The raw GraphQL definition of this operation.
    public let operationDefinition: String =
      """
      mutation BulkMintERC721($workId: String!, $ether: Float!) {
        bulkMintErc721(input: {workId: $workId, ether: $ether, useIpfs: true})
      }
      """

    public let operationName: String = "BulkMintERC721"

    public var workId: String
    public var ether: Double

    public init(workId: String, ether: Double) {
      self.workId = workId
      self.ether = ether
    }

    public var variables: GraphQLMap? {
      return ["workId": workId, "ether": ether]
    }

    public struct Data: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["MutationRoot"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("bulkMintErc721", arguments: ["input": ["workId": GraphQLVariable("workId"), "ether": GraphQLVariable("ether"), "useIpfs": true]], type: .nonNull(.scalar(Bool.self))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(bulkMintErc721: Bool) {
        self.init(unsafeResultMap: ["__typename": "MutationRoot", "bulkMintErc721": bulkMintErc721])
      }

      public var bulkMintErc721: Bool {
        get {
          return resultMap["bulkMintErc721"]! as! Bool
        }
        set {
          resultMap.updateValue(newValue, forKey: "bulkMintErc721")
        }
      }
    }
  }

  public final class BulkMintErc1155Mutation: GraphQLMutation {
    /// The raw GraphQL definition of this operation.
    public let operationDefinition: String =
      """
      mutation BulkMintERC1155($workId: String!, $amount: Int!, $ether: Float!) {
        bulkMintErc1155(
          input: {workId: $workId, amount: $amount, ether: $ether, useIpfs: true}
        )
      }
      """

    public let operationName: String = "BulkMintERC1155"

    public var workId: String
    public var amount: Int
    public var ether: Double

    public init(workId: String, amount: Int, ether: Double) {
      self.workId = workId
      self.amount = amount
      self.ether = ether
    }

    public var variables: GraphQLMap? {
      return ["workId": workId, "amount": amount, "ether": ether]
    }

    public struct Data: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["MutationRoot"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("bulkMintErc1155", arguments: ["input": ["workId": GraphQLVariable("workId"), "amount": GraphQLVariable("amount"), "ether": GraphQLVariable("ether"), "useIpfs": true]], type: .nonNull(.scalar(Bool.self))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(bulkMintErc1155: Bool) {
        self.init(unsafeResultMap: ["__typename": "MutationRoot", "bulkMintErc1155": bulkMintErc1155])
      }

      public var bulkMintErc1155: Bool {
        get {
          return resultMap["bulkMintErc1155"]! as! Bool
        }
        set {
          resultMap.updateValue(newValue, forKey: "bulkMintErc1155")
        }
      }
    }
  }

  public final class SyncAllTokensMutation: GraphQLMutation {
    /// The raw GraphQL definition of this operation.
    public let operationDefinition: String =
      """
      mutation SyncAllTokens {
        syncAllTokens
      }
      """

    public let operationName: String = "SyncAllTokens"

    public init() {
    }

    public struct Data: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["MutationRoot"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("syncAllTokens", type: .nonNull(.scalar(Bool.self))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(syncAllTokens: Bool) {
        self.init(unsafeResultMap: ["__typename": "MutationRoot", "syncAllTokens": syncAllTokens])
      }

      public var syncAllTokens: Bool {
        get {
          return resultMap["syncAllTokens"]! as! Bool
        }
        set {
          resultMap.updateValue(newValue, forKey: "syncAllTokens")
        }
      }
    }
  }

  public final class SellAllTokenMutation: GraphQLMutation {
    /// The raw GraphQL definition of this operation.
    public let operationDefinition: String =
      """
      mutation SellAllToken($address: String!, $ether: Float!) {
        sellAllTokens(input: {address: $address, ether: $ether})
      }
      """

    public let operationName: String = "SellAllToken"

    public var address: String
    public var ether: Double

    public init(address: String, ether: Double) {
      self.address = address
      self.ether = ether
    }

    public var variables: GraphQLMap? {
      return ["address": address, "ether": ether]
    }

    public struct Data: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["MutationRoot"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("sellAllTokens", arguments: ["input": ["address": GraphQLVariable("address"), "ether": GraphQLVariable("ether")]], type: .nonNull(.scalar(Bool.self))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(sellAllTokens: Bool) {
        self.init(unsafeResultMap: ["__typename": "MutationRoot", "sellAllTokens": sellAllTokens])
      }

      public var sellAllTokens: Bool {
        get {
          return resultMap["sellAllTokens"]! as! Bool
        }
        set {
          resultMap.updateValue(newValue, forKey: "sellAllTokens")
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
        tokens {
          __typename
          ...TokenFragment
        }
        multiTokens {
          __typename
          ...TokenFragment
        }
      }
      """

    public static let possibleTypes: [String] = ["Contract"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("address", type: .nonNull(.scalar(String.self))),
        GraphQLField("name", type: .nonNull(.scalar(String.self))),
        GraphQLField("schema", type: .nonNull(.scalar(Schema.self))),
        GraphQLField("network", type: .nonNull(.scalar(Network.self))),
        GraphQLField("tokens", type: .nonNull(.list(.nonNull(.object(Token.selections))))),
        GraphQLField("multiTokens", type: .nonNull(.list(.nonNull(.object(MultiToken.selections))))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(address: String, name: String, schema: Schema, network: Network, tokens: [Token], multiTokens: [MultiToken]) {
      self.init(unsafeResultMap: ["__typename": "Contract", "address": address, "name": name, "schema": schema, "network": network, "tokens": tokens.map { (value: Token) -> ResultMap in value.resultMap }, "multiTokens": multiTokens.map { (value: MultiToken) -> ResultMap in value.resultMap }])
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

    public var tokens: [Token] {
      get {
        return (resultMap["tokens"] as! [ResultMap]).map { (value: ResultMap) -> Token in Token(unsafeResultMap: value) }
      }
      set {
        resultMap.updateValue(newValue.map { (value: Token) -> ResultMap in value.resultMap }, forKey: "tokens")
      }
    }

    public var multiTokens: [MultiToken] {
      get {
        return (resultMap["multiTokens"] as! [ResultMap]).map { (value: ResultMap) -> MultiToken in MultiToken(unsafeResultMap: value) }
      }
      set {
        resultMap.updateValue(newValue.map { (value: MultiToken) -> ResultMap in value.resultMap }, forKey: "multiTokens")
      }
    }

    public struct Token: GraphQLSelectionSet {
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

      public init(address: String, workId: String, tokenId: String, name: String, description: String, imageUrl: String, isOwn: Bool, priceEth: Double? = nil) {
        self.init(unsafeResultMap: ["__typename": "Token", "address": address, "workId": workId, "tokenId": tokenId, "name": name, "description": description, "imageUrl": imageUrl, "isOwn": isOwn, "priceEth": priceEth])
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

    public struct MultiToken: GraphQLSelectionSet {
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

      public init(address: String, workId: String, tokenId: String, name: String, description: String, imageUrl: String, isOwn: Bool, priceEth: Double? = nil) {
        self.init(unsafeResultMap: ["__typename": "Token", "address": address, "workId": workId, "tokenId": tokenId, "name": name, "description": description, "imageUrl": imageUrl, "isOwn": isOwn, "priceEth": priceEth])
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

  public struct TokenFragment: GraphQLFragment {
    /// The raw GraphQL definition of this fragment.
    public static let fragmentDefinition: String =
      """
      fragment TokenFragment on Token {
        __typename
        address
        workId
        tokenId
        name
        description
        imageUrl
        isOwn
        priceEth
      }
      """

    public static let possibleTypes: [String] = ["Token"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("address", type: .nonNull(.scalar(String.self))),
        GraphQLField("workId", type: .nonNull(.scalar(String.self))),
        GraphQLField("tokenId", type: .nonNull(.scalar(String.self))),
        GraphQLField("name", type: .nonNull(.scalar(String.self))),
        GraphQLField("description", type: .nonNull(.scalar(String.self))),
        GraphQLField("imageUrl", type: .nonNull(.scalar(String.self))),
        GraphQLField("isOwn", type: .nonNull(.scalar(Bool.self))),
        GraphQLField("priceEth", type: .scalar(Double.self)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(address: String, workId: String, tokenId: String, name: String, description: String, imageUrl: String, isOwn: Bool, priceEth: Double? = nil) {
      self.init(unsafeResultMap: ["__typename": "Token", "address": address, "workId": workId, "tokenId": tokenId, "name": name, "description": description, "imageUrl": imageUrl, "isOwn": isOwn, "priceEth": priceEth])
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

    public var workId: String {
      get {
        return resultMap["workId"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "workId")
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

    public var imageUrl: String {
      get {
        return resultMap["imageUrl"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "imageUrl")
      }
    }

    public var isOwn: Bool {
      get {
        return resultMap["isOwn"]! as! Bool
      }
      set {
        resultMap.updateValue(newValue, forKey: "isOwn")
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
  }
}
