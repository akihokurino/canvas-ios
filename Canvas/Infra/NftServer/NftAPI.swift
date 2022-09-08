// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

/// NftAPI namespace
public enum NftAPI {
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
            address
            tokenId
            imageUrl
          }
          erc1155 {
            __typename
            address
            tokenId
            imageUrl
          }
        }
      }
      """

    public let operationName: String = "GetMintedToken"

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
              GraphQLField("address", type: .nonNull(.scalar(String.self))),
              GraphQLField("tokenId", type: .scalar(String.self)),
              GraphQLField("imageUrl", type: .scalar(String.self)),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(address: String, tokenId: String? = nil, imageUrl: String? = nil) {
            self.init(unsafeResultMap: ["__typename": "Token", "address": address, "tokenId": tokenId, "imageUrl": imageUrl])
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

          public var tokenId: String? {
            get {
              return resultMap["tokenId"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "tokenId")
            }
          }

          public var imageUrl: String? {
            get {
              return resultMap["imageUrl"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "imageUrl")
            }
          }
        }

        public struct Erc1155: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["Token"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("address", type: .nonNull(.scalar(String.self))),
              GraphQLField("tokenId", type: .scalar(String.self)),
              GraphQLField("imageUrl", type: .scalar(String.self)),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(address: String, tokenId: String? = nil, imageUrl: String? = nil) {
            self.init(unsafeResultMap: ["__typename": "Token", "address": address, "tokenId": tokenId, "imageUrl": imageUrl])
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

          public var tokenId: String? {
            get {
              return resultMap["tokenId"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "tokenId")
            }
          }

          public var imageUrl: String? {
            get {
              return resultMap["imageUrl"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "imageUrl")
            }
          }
        }
      }
    }
  }

  public final class IsOwnNftQuery: GraphQLQuery {
    /// The raw GraphQL definition of this operation.
    public let operationDefinition: String =
      """
      query IsOwnNft($workId: String!) {
        isOwnNft(workId: $workId) {
          __typename
          erc721
          erc1155
        }
      }
      """

    public let operationName: String = "IsOwnNft"

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
          GraphQLField("isOwnNft", arguments: ["workId": GraphQLVariable("workId")], type: .nonNull(.object(IsOwnNft.selections))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(isOwnNft: IsOwnNft) {
        self.init(unsafeResultMap: ["__typename": "QueryRoot", "isOwnNft": isOwnNft.resultMap])
      }

      public var isOwnNft: IsOwnNft {
        get {
          return IsOwnNft(unsafeResultMap: resultMap["isOwnNft"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "isOwnNft")
        }
      }

      public struct IsOwnNft: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["IsOwn"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("erc721", type: .nonNull(.scalar(Bool.self))),
            GraphQLField("erc1155", type: .nonNull(.scalar(Bool.self))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(erc721: Bool, erc1155: Bool) {
          self.init(unsafeResultMap: ["__typename": "IsOwn", "erc721": erc721, "erc1155": erc1155])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var erc721: Bool {
          get {
            return resultMap["erc721"]! as! Bool
          }
          set {
            resultMap.updateValue(newValue, forKey: "erc721")
          }
        }

        public var erc1155: Bool {
          get {
            return resultMap["erc1155"]! as! Bool
          }
          set {
            resultMap.updateValue(newValue, forKey: "erc1155")
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
        sellErc721(input: {workId: $workId, ether: $ether})
      }
      """

    public let operationName: String = "SellERC721"

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
          GraphQLField("sellErc721", arguments: ["input": ["workId": GraphQLVariable("workId"), "ether": GraphQLVariable("ether")]], type: .nonNull(.scalar(Bool.self))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(sellErc721: Bool) {
        self.init(unsafeResultMap: ["__typename": "MutationRoot", "sellErc721": sellErc721])
      }

      public var sellErc721: Bool {
        get {
          return resultMap["sellErc721"]! as! Bool
        }
        set {
          resultMap.updateValue(newValue, forKey: "sellErc721")
        }
      }
    }
  }

  public final class SellErc1155Mutation: GraphQLMutation {
    /// The raw GraphQL definition of this operation.
    public let operationDefinition: String =
      """
      mutation SellERC1155($workId: String!, $ether: Float!) {
        sellErc1155(input: {workId: $workId, ether: $ether, amount: 1})
      }
      """

    public let operationName: String = "SellERC1155"

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
          GraphQLField("sellErc1155", arguments: ["input": ["workId": GraphQLVariable("workId"), "ether": GraphQLVariable("ether"), "amount": 1]], type: .nonNull(.scalar(Bool.self))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(sellErc1155: Bool) {
        self.init(unsafeResultMap: ["__typename": "MutationRoot", "sellErc1155": sellErc1155])
      }

      public var sellErc1155: Bool {
        get {
          return resultMap["sellErc1155"]! as! Bool
        }
        set {
          resultMap.updateValue(newValue, forKey: "sellErc1155")
        }
      }
    }
  }

  public final class TransferErc721Mutation: GraphQLMutation {
    /// The raw GraphQL definition of this operation.
    public let operationDefinition: String =
      """
      mutation TransferERC721($workId: String!, $toAddress: String!) {
        transferErc721(input: {workId: $workId, toAddress: $toAddress})
      }
      """

    public let operationName: String = "TransferERC721"

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
          GraphQLField("transferErc721", arguments: ["input": ["workId": GraphQLVariable("workId"), "toAddress": GraphQLVariable("toAddress")]], type: .nonNull(.scalar(Bool.self))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(transferErc721: Bool) {
        self.init(unsafeResultMap: ["__typename": "MutationRoot", "transferErc721": transferErc721])
      }

      public var transferErc721: Bool {
        get {
          return resultMap["transferErc721"]! as! Bool
        }
        set {
          resultMap.updateValue(newValue, forKey: "transferErc721")
        }
      }
    }
  }

  public final class TransferErc1155Mutation: GraphQLMutation {
    /// The raw GraphQL definition of this operation.
    public let operationDefinition: String =
      """
      mutation TransferERC1155($workId: String!, $toAddress: String!) {
        transferErc1155(input: {workId: $workId, toAddress: $toAddress, amount: 1})
      }
      """

    public let operationName: String = "TransferERC1155"

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
          GraphQLField("transferErc1155", arguments: ["input": ["workId": GraphQLVariable("workId"), "toAddress": GraphQLVariable("toAddress"), "amount": 1]], type: .nonNull(.scalar(Bool.self))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(transferErc1155: Bool) {
        self.init(unsafeResultMap: ["__typename": "MutationRoot", "transferErc1155": transferErc1155])
      }

      public var transferErc1155: Bool {
        get {
          return resultMap["transferErc1155"]! as! Bool
        }
        set {
          resultMap.updateValue(newValue, forKey: "transferErc1155")
        }
      }
    }
  }
}
