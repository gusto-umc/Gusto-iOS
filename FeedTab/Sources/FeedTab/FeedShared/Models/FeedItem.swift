public struct FeedItem: Identifiable, Equatable, Sendable {
  public let id: Int64
  public let images: String
  
  public init(reviewId: Int64, images: String) {
    self.id = reviewId
    self.images = images
  }
}
