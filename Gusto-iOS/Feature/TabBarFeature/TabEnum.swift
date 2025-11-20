
public enum Tab: String, Equatable, CaseIterable {
  case map = "지도"
  case review = "리뷰"
  case list = "리스트"
  case feed = "먹스또"
  case my = "마이"
  
  var iconName: String {
    switch self {
    case .map:
      "map_icon"
    case .review:
      "review_icon"
    case .list:
      "list_icon"
    case .feed:
      "feed_icon"
    case .my:
      "my_icon"
    }
  }
}
