import GustoNetwork
import Foundation
import Dependencies

public struct FeedRequestable: Requestable {
  public var path: String
  public var method: GustoNetwork.HTTPMethod
  public var headers: [String : String]?
  public var parameters: [String : Any]?
  public var body: Data?
  
  enum Endpoint {
    case detail(Int64)
    case random
    case search(String, [HashTag], Int64?)
    
    var getRequest: FeedRequestable {
      switch self {
      case let .detail(id):
        return FeedRequestable(
          path: "/feeds/\(id)",
          method: .get
        )
      case .random:
        return FeedRequestable(
          path: "/feeds",
          method: .get
        )
      case let .search(keyword, tag, cursor):
        var parameters: [String: Any] = [
          "keyword": keyword,
          "hashTags": tag.map({$0.rawValue})
        ]
        if let cursor = cursor {
          parameters["cursor"] = cursor
        }
        return FeedRequestable(
          path: "/feeds/search",
          method: .get,
          parameters: parameters
        )
      }
    }
  }
}

public struct FeedAPIClient: Sendable {
  public var getRandomFeeds: @Sendable () async throws -> [FeedItem]
  public var getDetailReview: @Sendable (Int64) async throws -> FeedDetail
  public var search: @Sendable (String, [HashTag], Int64?) async throws -> FeedSearchResponse
}

extension FeedAPIClient: DependencyKey {
  public static var liveValue: FeedAPIClient {
    @Dependency(\.apiClient) var apiClient
    return FeedAPIClient(
      getRandomFeeds: {
        []
      },
      getDetailReview: { id in
        let request: any Requestable = FeedRequestable.Endpoint.detail(id).getRequest
        return try await apiClient.request(request)
      },
      search: { (string, tag, cursorId) in
        let request: any Requestable = FeedRequestable.Endpoint.search(string, tag, cursorId).getRequest
        return try await apiClient.request(request)
      }
    )
  }
  public static var testValue: FeedAPIClient { previewValue }
  public static var previewValue: FeedAPIClient {
    @Dependency(\.apiClient) var apiClient
    return FeedAPIClient(
      getRandomFeeds: {
        (1...20).map { _ in FeedItem(reviewId: Int64.random(in: Int64.min...Int64.max), images: "https://picsum.photos/200/200") }
      },
      getDetailReview: { id in
        let jsonString =
"""
        {
          "storeId": 1,
          "storeName": "구스또 파스타",
          "address": "서울특별시 은평구",
          "nickName": "blue",
          "profileImage": "https://picsum.photos/200/200",
          "likeCnt": 12,
          "likeCheck": false,
          "images": [
            "https://picsum.photos/400/400",
            "https://picsum.photos/400/400"
          ],
          "menuName": "음식, 맛있는 음식, 메뉴",
          "hashTags": "2,1",
          "taste": 3,
          "spiciness": 3,
          "mood": 3,
          "toilet": 3,
          "parking": 3,
          "comment": "etwtwe"
        }
"""
        let detail = try! JSONDecoder().decode(FeedDetail.self, from: Data(jsonString.utf8))
        return detail
      },
      search: { (_, _, id) in
        try? await Task.sleep(for: .seconds(0.5))
        if id ?? 0 < 100 {
          return .init(
            reviews: (1...20).map { i in FeedItem(reviewId: (id ?? 0) + i, images: "https://picsum.photos/200/200") },
            hasNext: true,
            cursorId: (id ?? 0) + 20
          )
        } else {
          return .init(
            reviews: (1...5).map { i in FeedItem(reviewId: (id ?? 0) + i, images: "https://picsum.photos/200/200")},
            hasNext: false,
            cursorId: nil
          )
        }
      }
    )
  }
}

extension DependencyValues {
  public var feedAPIClient: FeedAPIClient {
    get { self[FeedAPIClient.self] }
    set { self[FeedAPIClient.self] = newValue }
  }
}

private enum NetworkClientKey: DependencyKey {
  public static let liveValue: any NetworkClient = NetworkProtocolImpl(session: .shared)
}

extension DependencyValues {
  public var apiClient: any NetworkClient {
    get { self[NetworkClientKey.self] }
    set { self[NetworkClientKey.self] = newValue }
  }
}
