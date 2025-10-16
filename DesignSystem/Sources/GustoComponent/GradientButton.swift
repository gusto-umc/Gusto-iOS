//
//  GradientButton.swift
//  DesignSystem
//
//  Created by 강동영 on 10/16/25.
//

import SwiftUI

public struct GradientButton: View {
  private let action: @MainActor () -> Void
  private let config: Config
  
  public var body: some View {
    Button {
      action()
    } label: {
      Text(config.titleKey)
        .frame(maxWidth: .infinity, maxHeight: 48)
        .font(.system(size: config.fontSize, weight: config.fontWeight))
        .foregroundStyle(.white)
        .background(
          LinearGradient(
            colors: [.orange, .pink.opacity(0.8)],
            startPoint: .leading,
            endPoint: .trailing
          )
          .clipShape(RoundedRectangle(cornerRadius: 10))
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

public extension GradientButton {
  // 컬러 추가 후 변경 예정
  struct Config {
    fileprivate let titleKey: String
    fileprivate let cornerRadius: CGFloat = 10
    fileprivate let fontSize: CGFloat = 16
    fileprivate let fontWeight: Font.Weight = .bold
    fileprivate let backgroundColor: [Color] = [.orange, .pink.opacity(0.8)]
    
    public init(title: String) {
      self.titleKey = title
    }
  }
}
