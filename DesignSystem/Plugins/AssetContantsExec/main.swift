//
//  main.swift
//  DesignSystem
//
//  Created by 강동영 on 11/4/25.
//

import Foundation

// MARK: - Arguments Parsing
let arguments = ProcessInfo().arguments
if arguments.count < 3 {
  print("❌ Missing arguments: Expected input and output paths")
  exit(1)
}

// arguments[0]: 실행 파일 경로 (무시)
// arguments[1]: 처리 중인 에셋 카탈로그 경로
// arguments[2]: 생성된 코드에 대해 플러그인이 제공하는 경로
let (input, output) = (arguments[1], arguments[2])
print("💬 input: \(input), output: \(output)")

// MARK: - Asset Type Detection
let inputURL = URL(fileURLWithPath: input)
let assetType = inputURL.deletingPathExtension().lastPathComponent

let detectedType = AssetType.detect(from: assetType)

// MARK: - Main Execution
do {
  let generatedCode: String
  
  switch detectedType {
  case .color:
    print("🎨 Detected Color xcassets")
    generatedCode = try generateColorCode(from: input)
  case .image:
    print("🖼️ Detected Image xcassets")
    generatedCode = try generateImageCode(from: input)
  case .unknown:
    print("⚠️ Unknown asset type: \(assetType)")
    print("   Processing as Image by default")
    throw AssetPluginError.unknown
  }
  
  try generatedCode.write(to: URL(fileURLWithPath: output), atomically: true, encoding: .utf8)
  print("✅ Successfully generated: \(output)")
  
} catch {
  print("❌ Error: \(error)")
  exit(1)
}
