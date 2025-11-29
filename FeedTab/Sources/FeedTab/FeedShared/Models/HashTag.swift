
public enum HashTag: Int64, Codable, Hashable, CaseIterable, Sendable {
  case clear = 1, warm, insta, cool, cute, big, mood, chip
  
  var text: String {
    switch self {
    case .clear: return "깨끗함"
    case .warm: return "따뜻함"
    case .insta: return "인스타"
    case .cool: return "쾌적"
    case .cute: return "귀여워"
    case .big: return "넓음"
    case .mood: return "분위기"
    case .chip: return "가성비"
    }
  }
}

