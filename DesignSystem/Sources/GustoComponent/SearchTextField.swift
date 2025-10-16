//
//  SearchTextField.swift
//  DesignSystem
//
//  Created by 강동영 on 10/16/25.
//

import SwiftUI

public struct SearchTextField: View {
  @Binding var searchText: String
  private let config: Config
  
  private var propt: Text {
    Text(config.placeholder)
      .foregroundStyle(.gray) // color 교체 예정 gray_3: #A6A6A6
      .font(.system(size: 12))
  }
  
  public var body: some View {
    HStack {
      TextField(
        "Search Text",
        text: $searchText,
        prompt: propt
      )
      .padding(.leading, 16)
      .foregroundColor(.black)
      .font(.system(size: 16))
      
      
      Image(systemName: config.iconName)
        .padding(.trailing, 10)
        .foregroundColor(config.themeColor)
        .font(.system(size: 20))
      
    }
    .frame(height: 44)
    .background(Color.white)
    .cornerRadius(8)
    .overlay(
      RoundedRectangle(cornerRadius: 5)
        .stroke(config.themeColor, lineWidth: 1)
    )
  }
  
  public init(searchText: Binding<String>, config: Self.Config) {
    self._searchText = searchText
    self.config = config
  }
}

public extension SearchTextField {
  struct Config {
    public let placeholder: String
    public let themeColor: Color
    public let iconName: String
    
    public init(
      placeholder: String,
      themeColor: Color,
      iconName: String = "magnifyingglass"
    ) {
      self.placeholder = placeholder
      self.themeColor = themeColor
      self.iconName = iconName
    }
  }
}

#Preview {
  @Previewable @State var searchText = ""
  return SearchTextField(
    searchText: $searchText,
    config: .init(placeholder: "맛집 검색", themeColor: .pink)
  )
  .background(Color.white)
}
