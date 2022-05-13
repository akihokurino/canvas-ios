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
          nft721Num
          nft1155Num {
            __typename
            workId
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
        public static let possibleTypes: [String] = ["User"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .nonNull(.scalar(String.self))),
            GraphQLField("walletAddress", type: .nonNull(.scalar(String.self))),
            GraphQLField("balance", type: .nonNull(.scalar(Double.self))),
            GraphQLField("nft721Num", type: .nonNull(.scalar(Int.self))),
            GraphQLField("nft1155Num", type: .nonNull(.list(.nonNull(.object(Nft1155Num.selections))))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(id: String, walletAddress: String, balance: Double, nft721Num: Int, nft1155Num: [Nft1155Num]) {
          self.init(unsafeResultMap: ["__typename": "User", "id": id, "walletAddress": walletAddress, "balance": balance, "nft721Num": nft721Num, "nft1155Num": nft1155Num.map { (value: Nft1155Num) -> ResultMap in value.resultMap }])
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

        public var nft721Num: Int {
          get {
            return resultMap["nft721Num"]! as! Int
          }
          set {
            resultMap.updateValue(newValue, forKey: "nft721Num")
          }
        }

        public var nft1155Num: [Nft1155Num] {
          get {
            return (resultMap["nft1155Num"] as! [ResultMap]).map { (value: ResultMap) -> Nft1155Num in Nft1155Num(unsafeResultMap: value) }
          }
          set {
            resultMap.updateValue(newValue.map { (value: Nft1155Num) -> ResultMap in value.resultMap }, forKey: "nft1155Num")
          }
        }

        public struct Nft1155Num: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["Nft1155Balance"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("workId", type: .nonNull(.scalar(String.self))),
              GraphQLField("balance", type: .nonNull(.scalar(Int.self))),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(workId: String, balance: Int) {
            self.init(unsafeResultMap: ["__typename": "Nft1155Balance", "workId": workId, "balance": balance])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
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

  public final class GetWorkQuery: GraphQLQuery {
    /// The raw GraphQL definition of this operation.
    public let operationDefinition: String =
      """
      query GetWork($workId: String!) {
        work(id: $workId) {
          __typename
          id
          asset721 {
            __typename
            address
            tokenId
            imageUrl
          }
          asset1155 {
            __typename
            address
            tokenId
            imageUrl
          }
        }
      }
      """

    public let operationName: String = "GetWork"

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
          GraphQLField("work", arguments: ["id": GraphQLVariable("workId")], type: .nonNull(.object(Work.selections))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(work: Work) {
        self.init(unsafeResultMap: ["__typename": "QueryRoot", "work": work.resultMap])
      }

      public var work: Work {
        get {
          return Work(unsafeResultMap: resultMap["work"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "work")
        }
      }

      public struct Work: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["Work"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .nonNull(.scalar(String.self))),
            GraphQLField("asset721", type: .object(Asset721.selections)),
            GraphQLField("asset1155", type: .object(Asset1155.selections)),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(id: String, asset721: Asset721? = nil, asset1155: Asset1155? = nil) {
          self.init(unsafeResultMap: ["__typename": "Work", "id": id, "asset721": asset721.flatMap { (value: Asset721) -> ResultMap in value.resultMap }, "asset1155": asset1155.flatMap { (value: Asset1155) -> ResultMap in value.resultMap }])
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

        public var asset721: Asset721? {
          get {
            return (resultMap["asset721"] as? ResultMap).flatMap { Asset721(unsafeResultMap: $0) }
          }
          set {
            resultMap.updateValue(newValue?.resultMap, forKey: "asset721")
          }
        }

        public var asset1155: Asset1155? {
          get {
            return (resultMap["asset1155"] as? ResultMap).flatMap { Asset1155(unsafeResultMap: $0) }
          }
          set {
            resultMap.updateValue(newValue?.resultMap, forKey: "asset1155")
          }
        }

        public struct Asset721: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["Asset721"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("address", type: .nonNull(.scalar(String.self))),
              GraphQLField("tokenId", type: .nonNull(.scalar(String.self))),
              GraphQLField("imageUrl", type: .nonNull(.scalar(String.self))),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(address: String, tokenId: String, imageUrl: String) {
            self.init(unsafeResultMap: ["__typename": "Asset721", "address": address, "tokenId": tokenId, "imageUrl": imageUrl])
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
        }

        public struct Asset1155: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["Asset1155"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("address", type: .nonNull(.scalar(String.self))),
              GraphQLField("tokenId", type: .nonNull(.scalar(String.self))),
              GraphQLField("imageUrl", type: .nonNull(.scalar(String.self))),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(address: String, tokenId: String, imageUrl: String) {
            self.init(unsafeResultMap: ["__typename": "Asset1155", "address": address, "tokenId": tokenId, "imageUrl": imageUrl])
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
        }
      }
    }
  }

  public final class IsOwnNftQuery: GraphQLQuery {
    /// The raw GraphQL definition of this operation.
    public let operationDefinition: String =
      """
      query IsOwnNft($workId: String!) {
        ownNft(workId: $workId) {
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
          GraphQLField("ownNft", arguments: ["workId": GraphQLVariable("workId")], type: .nonNull(.object(OwnNft.selections))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(ownNft: OwnNft) {
        self.init(unsafeResultMap: ["__typename": "QueryRoot", "ownNft": ownNft.resultMap])
      }

      public var ownNft: OwnNft {
        get {
          return OwnNft(unsafeResultMap: resultMap["ownNft"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "ownNft")
        }
      }

      public struct OwnNft: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["OwnNft"]

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
          self.init(unsafeResultMap: ["__typename": "OwnNft", "erc721": erc721, "erc1155": erc1155])
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

  public final class CreateNft721Mutation: GraphQLMutation {
    /// The raw GraphQL definition of this operation.
    public let operationDefinition: String =
      """
      mutation CreateNft721($workId: String!, $gsPath: String!, $level: Int!, $point: Int!) {
        createNft721(
          input: {workId: $workId, gsPath: $gsPath, level: $level, point: $point}
        )
      }
      """

    public let operationName: String = "CreateNft721"

    public var workId: String
    public var gsPath: String
    public var level: Int
    public var point: Int

    public init(workId: String, gsPath: String, level: Int, point: Int) {
      self.workId = workId
      self.gsPath = gsPath
      self.level = level
      self.point = point
    }

    public var variables: GraphQLMap? {
      return ["workId": workId, "gsPath": gsPath, "level": level, "point": point]
    }

    public struct Data: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["MutationRoot"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("createNft721", arguments: ["input": ["workId": GraphQLVariable("workId"), "gsPath": GraphQLVariable("gsPath"), "level": GraphQLVariable("level"), "point": GraphQLVariable("point")]], type: .nonNull(.scalar(Bool.self))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(createNft721: Bool) {
        self.init(unsafeResultMap: ["__typename": "MutationRoot", "createNft721": createNft721])
      }

      public var createNft721: Bool {
        get {
          return resultMap["createNft721"]! as! Bool
        }
        set {
          resultMap.updateValue(newValue, forKey: "createNft721")
        }
      }
    }
  }

  public final class CreateNft1155Mutation: GraphQLMutation {
    /// The raw GraphQL definition of this operation.
    public let operationDefinition: String =
      """
      mutation CreateNft1155($workId: String!, $gsPath: String!, $level: Int!, $point: Int!, $amount: Int!) {
        createNft1155(
          input: {workId: $workId, gsPath: $gsPath, level: $level, point: $point, amount: $amount}
        )
      }
      """

    public let operationName: String = "CreateNft1155"

    public var workId: String
    public var gsPath: String
    public var level: Int
    public var point: Int
    public var amount: Int

    public init(workId: String, gsPath: String, level: Int, point: Int, amount: Int) {
      self.workId = workId
      self.gsPath = gsPath
      self.level = level
      self.point = point
      self.amount = amount
    }

    public var variables: GraphQLMap? {
      return ["workId": workId, "gsPath": gsPath, "level": level, "point": point, "amount": amount]
    }

    public struct Data: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["MutationRoot"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("createNft1155", arguments: ["input": ["workId": GraphQLVariable("workId"), "gsPath": GraphQLVariable("gsPath"), "level": GraphQLVariable("level"), "point": GraphQLVariable("point"), "amount": GraphQLVariable("amount")]], type: .nonNull(.scalar(Bool.self))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(createNft1155: Bool) {
        self.init(unsafeResultMap: ["__typename": "MutationRoot", "createNft1155": createNft1155])
      }

      public var createNft1155: Bool {
        get {
          return resultMap["createNft1155"]! as! Bool
        }
        set {
          resultMap.updateValue(newValue, forKey: "createNft1155")
        }
      }
    }
  }

  public final class SellNft721Mutation: GraphQLMutation {
    /// The raw GraphQL definition of this operation.
    public let operationDefinition: String =
      """
      mutation SellNFT721($workId: String!, $ether: Float!) {
        sellNft721(input: {workId: $workId, ether: $ether})
      }
      """

    public let operationName: String = "SellNFT721"

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
          GraphQLField("sellNft721", arguments: ["input": ["workId": GraphQLVariable("workId"), "ether": GraphQLVariable("ether")]], type: .nonNull(.scalar(Bool.self))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(sellNft721: Bool) {
        self.init(unsafeResultMap: ["__typename": "MutationRoot", "sellNft721": sellNft721])
      }

      public var sellNft721: Bool {
        get {
          return resultMap["sellNft721"]! as! Bool
        }
        set {
          resultMap.updateValue(newValue, forKey: "sellNft721")
        }
      }
    }
  }

  public final class SellNft1155Mutation: GraphQLMutation {
    /// The raw GraphQL definition of this operation.
    public let operationDefinition: String =
      """
      mutation SellNFT1155($workId: String!, $ether: Float!) {
        sellNft1155(input: {workId: $workId, ether: $ether})
      }
      """

    public let operationName: String = "SellNFT1155"

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
          GraphQLField("sellNft1155", arguments: ["input": ["workId": GraphQLVariable("workId"), "ether": GraphQLVariable("ether")]], type: .nonNull(.scalar(Bool.self))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(sellNft1155: Bool) {
        self.init(unsafeResultMap: ["__typename": "MutationRoot", "sellNft1155": sellNft1155])
      }

      public var sellNft1155: Bool {
        get {
          return resultMap["sellNft1155"]! as! Bool
        }
        set {
          resultMap.updateValue(newValue, forKey: "sellNft1155")
        }
      }
    }
  }

  public final class TransferNft721Mutation: GraphQLMutation {
    /// The raw GraphQL definition of this operation.
    public let operationDefinition: String =
      """
      mutation TransferNFT721($workId: String!, $toAddress: String!) {
        transferNft721(input: {workId: $workId, toAddress: $toAddress})
      }
      """

    public let operationName: String = "TransferNFT721"

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
          GraphQLField("transferNft721", arguments: ["input": ["workId": GraphQLVariable("workId"), "toAddress": GraphQLVariable("toAddress")]], type: .nonNull(.scalar(Bool.self))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(transferNft721: Bool) {
        self.init(unsafeResultMap: ["__typename": "MutationRoot", "transferNft721": transferNft721])
      }

      public var transferNft721: Bool {
        get {
          return resultMap["transferNft721"]! as! Bool
        }
        set {
          resultMap.updateValue(newValue, forKey: "transferNft721")
        }
      }
    }
  }

  public final class TransferNft1155Mutation: GraphQLMutation {
    /// The raw GraphQL definition of this operation.
    public let operationDefinition: String =
      """
      mutation TransferNFT1155($workId: String!, $toAddress: String!) {
        transferNft1155(input: {workId: $workId, toAddress: $toAddress})
      }
      """

    public let operationName: String = "TransferNFT1155"

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
          GraphQLField("transferNft1155", arguments: ["input": ["workId": GraphQLVariable("workId"), "toAddress": GraphQLVariable("toAddress")]], type: .nonNull(.scalar(Bool.self))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(transferNft1155: Bool) {
        self.init(unsafeResultMap: ["__typename": "MutationRoot", "transferNft1155": transferNft1155])
      }

      public var transferNft1155: Bool {
        get {
          return resultMap["transferNft1155"]! as! Bool
        }
        set {
          resultMap.updateValue(newValue, forKey: "transferNft1155")
        }
      }
    }
  }
}
