import Foundation

public enum ReviewEndpoints: Sendable {
  case deleteReview(reviewId: Int64)
  case fetch(reviewId: Int64)
  case update(reviewId: Int64)
  case create
  case like(reviewId: Int64)
  case search(keyword: String?, hasgTags: [Int64]?, cursorId: Int?)
  case reviewsByOther(nickname: String, lastReviewId: Int64?, size: Int)
  case randomFeed
  case timelineView(lastReviewId: Int64?, size: Int)
  case calview(lastReviewDate: String?, size: Int)
  case instaview(lastReviewId: Int64?, size: Int)
  case feedDetail(reviewId: Int64)
  case unlike(reviewId: Int64)
  
  public var path: String {
    return switch self {
    case .deleteReview(let reviewId):
      "/reviews/\(reviewId)"
    case .fetch(let reviewId):
      "/reviews/\(reviewId)"
    case .update(let reviewId):
      "/reviews/\(reviewId)"
    case .create:
      "/reviews"
    case .like(let reviewId):
      "/reviews/\(reviewId)/like"
    case .search(let keyword, let hashTags, let cursorId):
      {
        let params: [String?] = [
          keyword.map {"keyword=\($0)"},
          hashTags.map{"hashTags=\($0.map{String($0)}.joined(separator: ","))"},
          cursorId.map{"cursorId=\($0)"}
        ]
        return "/feeds/search?" + params.compactMap{$0}.joined(separator: "&")
      }()
    case .reviewsByOther(let nickname, let lastReviewId, let size):
      "/reviews?nickName=\(nickname)\(lastReviewId != nil ? "&reviewId=\(lastReviewId!)" : "")&size=\(size)"
    case .randomFeed:
      "/feeds"
    case .timelineView(let lastReviewId, let size):
      "/reviews/timelineView?\(lastReviewId != nil ? "reviewId=\(lastReviewId!)&" : "")size=\(size)"
    case .calview(let lastReviewDate, let size):
      "/reviews/calView?\(lastReviewDate != nil ? "lastReviewDate=\(lastReviewDate!)&" : "")size=\(size)"
    case .instaview(let lastReviewId, let size):
      "/reviews/instaView?\(lastReviewId != nil ? "lastReviewId=\(lastReviewId!)&" : ""))"
    case .feedDetail(let reviewId):
      "/feeds/\(reviewId)"
    case .unlike(let reviewId):
      "reviews/\(reviewId)/unlike"
    }
  }
}
