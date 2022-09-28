// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

/// CanvasAPI namespace
public enum CanvasAPI {
  public final class ListWorkQuery: GraphQLQuery {
    /// The raw GraphQL definition of this operation.
    public let operationDefinition: String =
      """
      query ListWork($page: Int!, $limit: Int!) {
        works(page: $page, limit: $limit) {
          __typename
          edges {
            __typename
            node {
              __typename
              ...WorkFragment
            }
          }
          pageInfo {
            __typename
            totalCount
            hasNextPage
          }
        }
      }
      """

    public let operationName: String = "ListWork"

    public var queryDocument: String {
      var document: String = operationDefinition
      document.append("\n" + WorkFragment.fragmentDefinition)
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
          GraphQLField("works", arguments: ["page": GraphQLVariable("page"), "limit": GraphQLVariable("limit")], type: .nonNull(.object(Work.selections))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(works: Work) {
        self.init(unsafeResultMap: ["__typename": "Query", "works": works.resultMap])
      }

      public var works: Work {
        get {
          return Work(unsafeResultMap: resultMap["works"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "works")
        }
      }

      public struct Work: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["WorkConnection"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("edges", type: .nonNull(.list(.nonNull(.object(Edge.selections))))),
            GraphQLField("pageInfo", type: .nonNull(.object(PageInfo.selections))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(edges: [Edge], pageInfo: PageInfo) {
          self.init(unsafeResultMap: ["__typename": "WorkConnection", "edges": edges.map { (value: Edge) -> ResultMap in value.resultMap }, "pageInfo": pageInfo.resultMap])
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

        public var pageInfo: PageInfo {
          get {
            return PageInfo(unsafeResultMap: resultMap["pageInfo"]! as! ResultMap)
          }
          set {
            resultMap.updateValue(newValue.resultMap, forKey: "pageInfo")
          }
        }

        public struct Edge: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["WorkEdge"]

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
            self.init(unsafeResultMap: ["__typename": "WorkEdge", "node": node.resultMap])
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
            public static let possibleTypes: [String] = ["Work"]

            public static var selections: [GraphQLSelection] {
              return [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLFragmentSpread(WorkFragment.self),
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

              public var workFragment: WorkFragment {
                get {
                  return WorkFragment(unsafeResultMap: resultMap)
                }
                set {
                  resultMap += newValue.resultMap
                }
              }
            }
          }
        }

        public struct PageInfo: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["PageInfo"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("totalCount", type: .nonNull(.scalar(Int.self))),
              GraphQLField("hasNextPage", type: .nonNull(.scalar(Bool.self))),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(totalCount: Int, hasNextPage: Bool) {
            self.init(unsafeResultMap: ["__typename": "PageInfo", "totalCount": totalCount, "hasNextPage": hasNextPage])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          public var totalCount: Int {
            get {
              return resultMap["totalCount"]! as! Int
            }
            set {
              resultMap.updateValue(newValue, forKey: "totalCount")
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
      }
    }
  }

  public final class ListFrameByWorkQuery: GraphQLQuery {
    /// The raw GraphQL definition of this operation.
    public let operationDefinition: String =
      """
      query ListFrameByWork($workId: ID!) {
        work(id: $workId) {
          __typename
          frames {
            __typename
            ...FrameFragment
          }
        }
      }
      """

    public let operationName: String = "ListFrameByWork"

    public var queryDocument: String {
      var document: String = operationDefinition
      document.append("\n" + FrameFragment.fragmentDefinition)
      return document
    }

    public var workId: GraphQLID

    public init(workId: GraphQLID) {
      self.workId = workId
    }

    public var variables: GraphQLMap? {
      return ["workId": workId]
    }

    public struct Data: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Query"]

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
        self.init(unsafeResultMap: ["__typename": "Query", "work": work.resultMap])
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
            GraphQLField("frames", type: .nonNull(.list(.nonNull(.object(Frame.selections))))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(frames: [Frame]) {
          self.init(unsafeResultMap: ["__typename": "Work", "frames": frames.map { (value: Frame) -> ResultMap in value.resultMap }])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var frames: [Frame] {
          get {
            return (resultMap["frames"] as! [ResultMap]).map { (value: ResultMap) -> Frame in Frame(unsafeResultMap: value) }
          }
          set {
            resultMap.updateValue(newValue.map { (value: Frame) -> ResultMap in value.resultMap }, forKey: "frames")
          }
        }

        public struct Frame: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["Frame"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLFragmentSpread(FrameFragment.self),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(id: GraphQLID, workId: GraphQLID, orgImageUrl: String, resizedImageUrl: String, imageGsPath: String) {
            self.init(unsafeResultMap: ["__typename": "Frame", "id": id, "workId": workId, "orgImageUrl": orgImageUrl, "resizedImageUrl": resizedImageUrl, "imageGsPath": imageGsPath])
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

            public var frameFragment: FrameFragment {
              get {
                return FrameFragment(unsafeResultMap: resultMap)
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

  public final class ListFrameQuery: GraphQLQuery {
    /// The raw GraphQL definition of this operation.
    public let operationDefinition: String =
      """
      query ListFrame($page: Int!, $limit: Int!) {
        frames(page: $page, limit: $limit) {
          __typename
          edges {
            __typename
            node {
              __typename
              ...FrameFragment
            }
          }
          pageInfo {
            __typename
            totalCount
            hasNextPage
          }
        }
      }
      """

    public let operationName: String = "ListFrame"

    public var queryDocument: String {
      var document: String = operationDefinition
      document.append("\n" + FrameFragment.fragmentDefinition)
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
          GraphQLField("frames", arguments: ["page": GraphQLVariable("page"), "limit": GraphQLVariable("limit")], type: .nonNull(.object(Frame.selections))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(frames: Frame) {
        self.init(unsafeResultMap: ["__typename": "Query", "frames": frames.resultMap])
      }

      public var frames: Frame {
        get {
          return Frame(unsafeResultMap: resultMap["frames"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "frames")
        }
      }

      public struct Frame: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["FrameConnection"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("edges", type: .nonNull(.list(.nonNull(.object(Edge.selections))))),
            GraphQLField("pageInfo", type: .nonNull(.object(PageInfo.selections))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(edges: [Edge], pageInfo: PageInfo) {
          self.init(unsafeResultMap: ["__typename": "FrameConnection", "edges": edges.map { (value: Edge) -> ResultMap in value.resultMap }, "pageInfo": pageInfo.resultMap])
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

        public var pageInfo: PageInfo {
          get {
            return PageInfo(unsafeResultMap: resultMap["pageInfo"]! as! ResultMap)
          }
          set {
            resultMap.updateValue(newValue.resultMap, forKey: "pageInfo")
          }
        }

        public struct Edge: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["FrameEdge"]

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
            self.init(unsafeResultMap: ["__typename": "FrameEdge", "node": node.resultMap])
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
            public static let possibleTypes: [String] = ["Frame"]

            public static var selections: [GraphQLSelection] {
              return [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLFragmentSpread(FrameFragment.self),
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(id: GraphQLID, workId: GraphQLID, orgImageUrl: String, resizedImageUrl: String, imageGsPath: String) {
              self.init(unsafeResultMap: ["__typename": "Frame", "id": id, "workId": workId, "orgImageUrl": orgImageUrl, "resizedImageUrl": resizedImageUrl, "imageGsPath": imageGsPath])
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

              public var frameFragment: FrameFragment {
                get {
                  return FrameFragment(unsafeResultMap: resultMap)
                }
                set {
                  resultMap += newValue.resultMap
                }
              }
            }
          }
        }

        public struct PageInfo: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["PageInfo"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("totalCount", type: .nonNull(.scalar(Int.self))),
              GraphQLField("hasNextPage", type: .nonNull(.scalar(Bool.self))),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(totalCount: Int, hasNextPage: Bool) {
            self.init(unsafeResultMap: ["__typename": "PageInfo", "totalCount": totalCount, "hasNextPage": hasNextPage])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          public var totalCount: Int {
            get {
              return resultMap["totalCount"]! as! Int
            }
            set {
              resultMap.updateValue(newValue, forKey: "totalCount")
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

  public struct WorkFragment: GraphQLFragment {
    /// The raw GraphQL definition of this fragment.
    public static let fragmentDefinition: String =
      """
      fragment WorkFragment on Work {
        __typename
        id
        videoUrl
        frames(limit: 3) {
          __typename
          id
          workId
          orgImageUrl
          resizedImageUrl
          imageGsPath
        }
      }
      """

    public static let possibleTypes: [String] = ["Work"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("videoUrl", type: .nonNull(.scalar(String.self))),
        GraphQLField("frames", arguments: ["limit": 3], type: .nonNull(.list(.nonNull(.object(Frame.selections))))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(id: GraphQLID, videoUrl: String, frames: [Frame]) {
      self.init(unsafeResultMap: ["__typename": "Work", "id": id, "videoUrl": videoUrl, "frames": frames.map { (value: Frame) -> ResultMap in value.resultMap }])
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

    public var frames: [Frame] {
      get {
        return (resultMap["frames"] as! [ResultMap]).map { (value: ResultMap) -> Frame in Frame(unsafeResultMap: value) }
      }
      set {
        resultMap.updateValue(newValue.map { (value: Frame) -> ResultMap in value.resultMap }, forKey: "frames")
      }
    }

    public struct Frame: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Frame"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("workId", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("orgImageUrl", type: .nonNull(.scalar(String.self))),
          GraphQLField("resizedImageUrl", type: .nonNull(.scalar(String.self))),
          GraphQLField("imageGsPath", type: .nonNull(.scalar(String.self))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: GraphQLID, workId: GraphQLID, orgImageUrl: String, resizedImageUrl: String, imageGsPath: String) {
        self.init(unsafeResultMap: ["__typename": "Frame", "id": id, "workId": workId, "orgImageUrl": orgImageUrl, "resizedImageUrl": resizedImageUrl, "imageGsPath": imageGsPath])
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

      public var orgImageUrl: String {
        get {
          return resultMap["orgImageUrl"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "orgImageUrl")
        }
      }

      public var resizedImageUrl: String {
        get {
          return resultMap["resizedImageUrl"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "resizedImageUrl")
        }
      }

      public var imageGsPath: String {
        get {
          return resultMap["imageGsPath"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "imageGsPath")
        }
      }
    }
  }

  public struct FrameFragment: GraphQLFragment {
    /// The raw GraphQL definition of this fragment.
    public static let fragmentDefinition: String =
      """
      fragment FrameFragment on Frame {
        __typename
        id
        workId
        orgImageUrl
        resizedImageUrl
        imageGsPath
      }
      """

    public static let possibleTypes: [String] = ["Frame"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("workId", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("orgImageUrl", type: .nonNull(.scalar(String.self))),
        GraphQLField("resizedImageUrl", type: .nonNull(.scalar(String.self))),
        GraphQLField("imageGsPath", type: .nonNull(.scalar(String.self))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(id: GraphQLID, workId: GraphQLID, orgImageUrl: String, resizedImageUrl: String, imageGsPath: String) {
      self.init(unsafeResultMap: ["__typename": "Frame", "id": id, "workId": workId, "orgImageUrl": orgImageUrl, "resizedImageUrl": resizedImageUrl, "imageGsPath": imageGsPath])
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

    public var orgImageUrl: String {
      get {
        return resultMap["orgImageUrl"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "orgImageUrl")
      }
    }

    public var resizedImageUrl: String {
      get {
        return resultMap["resizedImageUrl"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "resizedImageUrl")
      }
    }

    public var imageGsPath: String {
      get {
        return resultMap["imageGsPath"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "imageGsPath")
      }
    }
  }
}
