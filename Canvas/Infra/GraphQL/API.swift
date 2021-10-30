// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

/// GraphQL namespace
public enum GraphQL {
  public final class ListThumbnailQuery: GraphQLQuery {
    /// The raw GraphQL definition of this operation.
    public let operationDefinition: String =
      """
      query ListThumbnail($page: Int!, $limit: Int!) {
        thumbnails(page: $page, limit: $limit) {
          __typename
          ...ThumbnailFragment
        }
      }
      """

    public let operationName: String = "ListThumbnail"

    public var queryDocument: String {
      var document: String = operationDefinition
      document.append("\n" + ThumbnailFragment.fragmentDefinition)
      return document
    }

    public var page: Int
    public var limit: Int

    public init(page: Int, limit: Int) {
      self.page = page
      self.limit = limit
    }

    public var variables: GraphQLMap? {
      return ["page": page, "limit": limit]
    }

    public struct Data: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Query"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("thumbnails", arguments: ["page": GraphQLVariable("page"), "limit": GraphQLVariable("limit")], type: .nonNull(.list(.nonNull(.object(Thumbnail.selections))))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(thumbnails: [Thumbnail]) {
        self.init(unsafeResultMap: ["__typename": "Query", "thumbnails": thumbnails.map { (value: Thumbnail) -> ResultMap in value.resultMap }])
      }

      public var thumbnails: [Thumbnail] {
        get {
          return (resultMap["thumbnails"] as! [ResultMap]).map { (value: ResultMap) -> Thumbnail in Thumbnail(unsafeResultMap: value) }
        }
        set {
          resultMap.updateValue(newValue.map { (value: Thumbnail) -> ResultMap in value.resultMap }, forKey: "thumbnails")
        }
      }

      public struct Thumbnail: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["Thumbnail"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLFragmentSpread(ThumbnailFragment.self),
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

          public var thumbnailFragment: ThumbnailFragment {
            get {
              return ThumbnailFragment(unsafeResultMap: resultMap)
            }
            set {
              resultMap += newValue.resultMap
            }
          }
        }
      }
    }
  }

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

  public struct ThumbnailFragment: GraphQLFragment {
    /// The raw GraphQL definition of this fragment.
    public static let fragmentDefinition: String =
      """
      fragment ThumbnailFragment on Thumbnail {
        __typename
        id
        workId
        imageUrl
        work {
          __typename
          id
          videoUrl
        }
      }
      """

    public static let possibleTypes: [String] = ["Thumbnail"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("workId", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("imageUrl", type: .nonNull(.scalar(String.self))),
        GraphQLField("work", type: .nonNull(.object(Work.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(id: GraphQLID, workId: GraphQLID, imageUrl: String, work: Work) {
      self.init(unsafeResultMap: ["__typename": "Thumbnail", "id": id, "workId": workId, "imageUrl": imageUrl, "work": work.resultMap])
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

    public var workId: GraphQLID {
      get {
        return resultMap["workId"]! as! GraphQLID
      }
      set {
        resultMap.updateValue(newValue, forKey: "workId")
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
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("videoUrl", type: .nonNull(.scalar(String.self))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: GraphQLID, videoUrl: String) {
        self.init(unsafeResultMap: ["__typename": "Work", "id": id, "videoUrl": videoUrl])
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

      public var videoUrl: String {
        get {
          return resultMap["videoUrl"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "videoUrl")
        }
      }
    }
  }
}
