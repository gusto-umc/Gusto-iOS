//
//  File.swift
//  DesignSystem
//
//  Created by 강동영 on 11/4/25.
//

import Foundation
import PackagePlugin

@main
struct AssetConstants: BuildToolPlugin {
  func createBuildCommands(context: PackagePlugin.PluginContext, target: any PackagePlugin.Target) async throws -> [PackagePlugin.Command] {
    guard let target = target as? SourceModuleTarget else {
      return []
    }
    
    return try target.sourceFiles(withSuffix: "xcassets").map { assetCatalog in
      let base = assetCatalog.url.deletingPathExtension().lastPathComponent
      let input = assetCatalog.url
      let output = context.pluginWorkDirectoryURL.appending(path: "DesignSystem+\(base).swift")
      
      print("💬 base: \(base), input: \(input), output: \(output)")
      return .buildCommand(displayName: "Generating constants for \(base)",
                           executable: try context.tool(named: "AssetContantsExec").url,
                           arguments: [input.path(), output.path()],
                           inputFiles: [input],
                           outputFiles: [output])
    }
  }
}
