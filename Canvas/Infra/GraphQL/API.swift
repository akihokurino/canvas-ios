// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

/// GraphQL namespace
public enum GraphQL {
  public final class RegisterFmcTokenMutation: GraphQLMutation {
    /// The raw GraphQL definition of this operation.
    public let operationDefinition: String =
      """
      mutation RegisterFMCToken($token: String!, $device: String!) {
        registerFCMToken(input: {token: $token, device: $device})
      }
      """

    public let operationName: String = "RegisterFMCToken"

    public var token: String
    public var device: String

    public init(token: String, device: String) {
      self.token = token
      self.device = device
    }

    public var variables: GraphQLMap? {
      return ["token": token, "device": device]
    }

    public struct Data: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Mutation"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("registerFCMToken", arguments: ["input": ["token": GraphQLVariable("token"), "device": GraphQLVariable("device")]], type: .nonNull(.scalar(Bool.self))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(registerFcmToken: Bool) {
        self.init(unsafeResultMap: ["__typename": "Mutation", "registerFCMToken": registerFcmToken])
      }

      public var registerFcmToken: Bool {
        get {
          return resultMap["registerFCMToken"]! as! Bool
        }
        set {
          resultMap.updateValue(newValue, forKey: "registerFCMToken")
        }
      }
    }
  }
}
