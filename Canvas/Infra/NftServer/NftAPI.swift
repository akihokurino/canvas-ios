// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

/// NftAPI namespace
public enum NftAPI {
  public final class IsOwnNftQuery: GraphQLQuery {
    /// The raw GraphQL definition of this operation.
    public let operationDefinition: String =
      """
      query IsOwnNft($workId: String!) {
        isOwnNft(address: "0x1341048E3d37046Ca18A09EFB154Ea9771744f41", workId: $workId)
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
          GraphQLField("isOwnNft", arguments: ["address": "0x1341048E3d37046Ca18A09EFB154Ea9771744f41", "workId": GraphQLVariable("workId")], type: .nonNull(.scalar(Bool.self))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(isOwnNft: Bool) {
        self.init(unsafeResultMap: ["__typename": "QueryRoot", "isOwnNft": isOwnNft])
      }

      public var isOwnNft: Bool {
        get {
          return resultMap["isOwnNft"]! as! Bool
        }
        set {
          resultMap.updateValue(newValue, forKey: "isOwnNft")
        }
      }
    }
  }

  public final class CreateNftMutation: GraphQLMutation {
    /// The raw GraphQL definition of this operation.
    public let operationDefinition: String =
      """
      mutation CreateNft($workId: String!, $thumbnailUrl: String!, $level: Int!, $point: Int!) {
        createNft(
          input: {workId: $workId, thumbnailUrl: $thumbnailUrl, level: $level, point: $point}
        )
      }
      """

    public let operationName: String = "CreateNft"

    public var workId: String
    public var thumbnailUrl: String
    public var level: Int
    public var point: Int

    public init(workId: String, thumbnailUrl: String, level: Int, point: Int) {
      self.workId = workId
      self.thumbnailUrl = thumbnailUrl
      self.level = level
      self.point = point
    }

    public var variables: GraphQLMap? {
      return ["workId": workId, "thumbnailUrl": thumbnailUrl, "level": level, "point": point]
    }

    public struct Data: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["MutationRoot"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("createNft", arguments: ["input": ["workId": GraphQLVariable("workId"), "thumbnailUrl": GraphQLVariable("thumbnailUrl"), "level": GraphQLVariable("level"), "point": GraphQLVariable("point")]], type: .nonNull(.scalar(Bool.self))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(createNft: Bool) {
        self.init(unsafeResultMap: ["__typename": "MutationRoot", "createNft": createNft])
      }

      public var createNft: Bool {
        get {
          return resultMap["createNft"]! as! Bool
        }
        set {
          resultMap.updateValue(newValue, forKey: "createNft")
        }
      }
    }
  }
}
