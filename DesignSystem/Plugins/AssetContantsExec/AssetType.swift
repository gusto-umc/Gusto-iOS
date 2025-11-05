//
//  AssetType.swift
//  DesignSystem
//
//  Created by 강동영 on 11/5/25.
//

import Foundation

enum AssetPluginError: Error {
  case unknown
}
enum AssetType {
  case color
  case image
  case unknown
  
  static func detect(from name: String) -> AssetType {
    if name.lowercased().contains("color") {
      return .color
    } else if name.lowercased().contains("image") {
      return .image
    } else {
      return .unknown
    }
  }
}

// MARK: - Naming Helper Functions
func formatAssetName(_ name: String) -> String {
  var result = name
  
  // 1. postfix "Color" 제거 (대소문자 무관)
  if result.lowercased().hasSuffix("color") {
    result = String(result.dropLast(5))
  }
  
  // 1. postfix "Image" 제거 (대소문자 무관)
  if result.lowercased().hasSuffix("image") {
    result = String(result.dropLast(5))
  }
  
  // 2. 특수문자(공백, -, &, 등)를 기준으로 단어 분리
  let components = result.components(separatedBy: CharacterSet.alphanumerics.inverted)

  // 3. 빈 문자열만 필터링 (숫자는 유지)
  let filtered = components.filter { !$0.isEmpty }

  if filtered.isEmpty { return name } // 변환 실패시 원본 반환
  
  // 4. lowerCamelCase 적용
  let camelCased = filtered.enumerated().map { index, component in
    // 숫자만 있는 경우 그대로 유지
    if component.allSatisfy({ $0.isNumber }) {
      return component
    }
    
    if index == 0 {
      return component.lowercased()
    } else {
      return component.prefix(1).uppercased() + component.dropFirst().lowercased()
    }
  }.joined()
  
  return camelCased
}
