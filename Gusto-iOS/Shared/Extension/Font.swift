import SwiftUI

extension Font {
  enum Pretendard {
    case black, bold, extraBold, extraLight, light, medium, regular, semiBold, thin
    
    var value: String {
      switch self {
      default:
        return "Pretendard-\(self)"
      }
    }
  }
  
  static func pretendard(_ type: Pretendard, size: CGFloat) -> Font {
    return .custom(type.value, size: size)
  }
  static func pretendard(_ weight: Int, size: CGFloat) -> Font {
    switch weight {
    case 100:
      return .custom(Pretendard.thin.value, size: size)
    case 200:
      return .custom(Pretendard.extraLight.value, size: size)
    case 300:
      return .custom(Pretendard.light.value, size: size)
    case 400:
      return .custom(Pretendard.regular.value, size: size)
    case 500:
      return .custom(Pretendard.medium.value, size: size)
    case 600:
      return .custom(Pretendard.semiBold.value, size: size)
    case 700:
      return .custom(Pretendard.bold.value, size: size)
    case 800:
      return .custom(Pretendard.extraBold.value, size: size)
    case 900:
      return .custom(Pretendard.black.value, size: size)
    default:
      return .custom(Pretendard.regular.value, size: size)
    }
  }
}
