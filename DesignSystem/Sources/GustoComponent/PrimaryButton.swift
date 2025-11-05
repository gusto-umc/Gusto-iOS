//
//  PrimaryButton.swift
//  DesignSystem
//
//  Created by 강동영 on 10/16/25.
//

import SwiftUI
import GustoResources

public struct PrimaryButton: View {
  private let action: @MainActor () -> Void
  private let config: Config
  
  public var body: some View {
    Button {
      action()
    } label: {
      Text(config.titleKey)
        .frame(maxWidth: .infinity, maxHeight: 48)
        .font(.system(size: config.fontSize, weight: config.fontWeight))
        .foregroundStyle(config.titleColor)
        .background(
          RoundedRectangle(cornerRadius: config.cornerRadius)
            .fill(config.backgroundColor)
        )
    }
  }
  
  public init(
    _ config: Config,
    action: @escaping @MainActor () -> Void = {}
  ) {
    self.config = config
    self.action = action
  }
}

public extension PrimaryButton {
  struct Config {
    fileprivate let titleKey: String
    fileprivate let cornerRadius: CGFloat
    fileprivate let fontSize: CGFloat
    fileprivate let fontWeight: Font.Weight
    fileprivate let titleColor: Color
    fileprivate let backgroundColor: Color
    
    public init(
      title: String,
      cornerRadius: CGFloat = 16,
      fontSize: CGFloat = 16,
      fontWeight: Font.Weight = .bold,
      titleColor: Color = .white,
      backgroundColor: Color = .mainC
    ) {
      self.titleKey = title
      self.cornerRadius = cornerRadius
      self.fontSize = fontSize
      self.fontWeight = fontWeight
      self.titleColor = titleColor
      self.backgroundColor = backgroundColor
    }
  }
}
