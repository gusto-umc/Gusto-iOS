//
//  Contents.swift
//  DesignSystem
//
//  Created by 강동영 on 11/5/25.
//

import Foundation

// MARK: - Image Processing
struct Contents: Decodable {
  let images: [Image]
}

struct Image: Decodable {
  let filename: String?
}

func generateImageCode(from inputPath: String) throws -> String {
  var code = """
  import Foundation
  import SwiftUI

  public extension Image {
  """

  var imageNames: [String] = []
  let fileManager = FileManager.default

  // .imageset 파일 찾기 (재귀적으로 탐색)
  guard let enumerator = fileManager.enumerator(atPath: inputPath) else {
    throw NSError(domain: "ImageGenerator", code: 1, userInfo: [NSLocalizedDescriptionKey: "Cannot enumerate directory"])
  }

  while let file = enumerator.nextObject() as? String {
    if file.hasSuffix(".imageset") {
      // JSON 파싱
      let contentsJsonURL = URL(fileURLWithPath: "\(inputPath)/\(file)/Contents.json")

      do {
        let jsonData = try Data(contentsOf: contentsJsonURL)
        let assetCatalogContents = try JSONDecoder().decode(Contents.self, from: jsonData)
        let hasImage = assetCatalogContents.images.contains { $0.filename != nil }

        if hasImage {
          let imageName = String(file.dropLast(9)) // ".imageset" 제거
          let cleanName = URL(fileURLWithPath: imageName).lastPathComponent
          imageNames.append(cleanName)
        }
      } catch {
        print("⚠️ Failed to parse \(file): \(error)")
      }
    }
  }

  imageNames.sort()

  for imageName in imageNames {
    let formattedName = formatAssetName(imageName)
    code += "\n  static let \(formattedName) = Image(\"\(imageName)\", bundle: .module)"
    print("📝 Image: \(imageName) -> \(formattedName)")
  }

  code += "\n}\n"

  print("✅ Generated \(imageNames.count) images")
  return code
}
