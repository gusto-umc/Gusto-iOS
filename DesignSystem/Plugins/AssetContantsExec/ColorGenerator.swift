//
//  ColorGenerator.swift
//  DesignSystem
//
//  Created by 강동영 on 11/5/25.
//

import Foundation

// MARK: - Color Processing
func generateColorCode(from inputPath: String) throws -> String {
  var code = """
  import Foundation
  import SwiftUI
  
  public extension Color {
  """
  
  var colorNames: [String] = []
  let fileManager = FileManager.default
  
  // .colorset 파일 찾기
  guard let enumerator = fileManager.enumerator(atPath: inputPath) else {
    throw NSError(domain: "ColorGenerator", code: 1, userInfo: [NSLocalizedDescriptionKey: "Cannot enumerate directory"])
  }
  
  while let file = enumerator.nextObject() as? String {
    if file.hasSuffix(".colorset") {
      let colorName = String(file.dropLast(9)) // ".colorset" 제거
      let cleanName = URL(fileURLWithPath: colorName).lastPathComponent
      colorNames.append(cleanName)
    }
  }
  
  colorNames.sort()
  
  for colorName in colorNames {
    let formattedName = formatAssetName(colorName)
    code += "\n  static let \(formattedName) = Color(\"\(colorName)\", bundle: .module)"
    print("📝 Color: \(colorName) -> \(formattedName)")
  }
  
  code += "\n}\n"
  
  print("✅ Generated \(colorNames.count) colors")
  return code
}
