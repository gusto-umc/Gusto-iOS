
public struct FeedDetail: Codable {
  let storeId: Int64
  let storeName: String
  let address: String
  let nickName: String
  let profileImage: String
  let likeCount: Int
  let likeCheck: Bool
  let images: [String]
  let menuName: [String]
  let hashTags: [HashTag]
  let taste: Int
  let spiciness: Int?
  let mood: Int?
  let toilet: Int?
  let parking: Int?
  let comment: String?
  
  enum CodingKeys: String, CodingKey {
    case storeId
    case storeName
    case address
    case nickName
    case profileImage
    case likeCount = "likeCnt"
    case likeCheck
    case images
    case menuName
    case hashTags
    case taste
    case spiciness
    case mood
    case toilet
    case parking
    case comment
  }
  public init(from decoder: any Decoder) throws {
    
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.storeId = try container.decode(Int64.self, forKey: .storeId)
    self.storeName = try container.decode(String.self, forKey: .storeName)
    self.address = try container.decode(String.self, forKey: .address)
    self.nickName = try container.decode(String.self, forKey: .nickName)
    self.profileImage = try container.decode(String.self, forKey: .profileImage)
    self.likeCount = try container.decode(Int.self, forKey: .likeCount)
    self.likeCheck = try container.decode(Bool.self, forKey: .likeCheck)
    self.images = try container.decode([String].self, forKey: .images)
    let menuStrings = try container.decodeIfPresent(String.self, forKey: .menuName)
    var menus = [String]()
    menuStrings?.split(separator: ", ").forEach{menus.append(String($0))}
    self.menuName = menus
    let hashTag = try container.decode(String.self, forKey: .hashTags)
    var tags: [HashTag] = []
    hashTag
      .split(separator: ",")
      .forEach { tag in
        let tag = String(tag)
        if let uint = Int64(tag),
           let hashTag = HashTag(rawValue: uint) {
          tags.append(hashTag)
        }
      }
    self.hashTags = tags
    self.taste = try container.decode(Int.self, forKey: .taste)
    self.spiciness = try container.decodeIfPresent(Int.self, forKey: .spiciness)
    self.mood = try container.decodeIfPresent(Int.self, forKey: .mood)
    self.toilet = try container.decodeIfPresent(Int.self, forKey: .toilet)
    self.parking = try container.decodeIfPresent(Int.self, forKey: .parking)
    self.comment = try container.decodeIfPresent(String.self, forKey: .comment)
  }
}
