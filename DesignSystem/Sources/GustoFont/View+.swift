import SwiftUI

public extension View {
  func pretendard(_ type: Pretendard, size: CGFloat) -> some View {
    return self.font(.custom(type.value, size: size))
  }
  
  func pretendard(_ weight: Int, size: CGFloat) -> some View {
    let type = Pretendard(rawValue: weight) ?? .regular
    return self.pretendard(type, size: size)
  }
}

public enum Pretendard: Int, CaseIterable {
  case black = 900
  case extraBold = 800
  case bold = 700
  case semiBold = 600
  case medium = 500
  case regular = 400
  case light = 300
  case extraLight = 200
  case thin = 100
  
  var value: String {
    switch self {
    default:
      return "Pretendard-\(self.displayName)"
    }
  }
  
  private var displayName: String {
    let name = String(describing: self)
    // lowerCamelCase → UpperCamelCase 변환
    return name.prefix(1).uppercased() + name.dropFirst()
  }
}
