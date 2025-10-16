//
//  SampleView.swift
//  DesignSystem
//
//  Created by 강동영 on 10/14/25.
//

import SwiftUI

struct SampleView: View {
  var body: some View {
    VStack(alignment: .leading) {
      Text("Hello, World!")
        .pretendard(.black, size: 50)
      Text("Hello, World!")
        .pretendard(.extraBold, size: 48)
      Text("Hello, World!")
        .pretendard(.bold, size: 46)
      Text("Hello, World!")
        .pretendard(.semiBold, size: 44)
      Text("Hello, World!")
        .pretendard(.medium, size: 42)
      Text("Hello, World!")
        .pretendard(.regular, size: 40)
      Text("Hello, World!")
        .pretendard(.light, size: 38)
      Text("Hello, World!")
        .pretendard(.extraLight, size: 36)
      Text("Hello, World!")
        .pretendard(.thin, size: 34)
      
      Text("Hello, World!")
        .pretendard(900, size: 50)
      Text("Hello, World!")
        .pretendard(800, size: 48)
      Text("Hello, World!")
        .pretendard(700, size: 46)
      Text("Hello, World!")
        .pretendard(600, size: 44)
      Text("Hello, World!")
        .pretendard(500, size: 42)
      Text("Hello, World!")
        .pretendard(400, size: 40)
      Text("Hello, World!")
        .pretendard(300, size: 38)
      Text("Hello, World!")
        .pretendard(200, size: 36)
      Text("Hello, World!")
        .pretendard(100, size: 34)
    }
  }
}

#Preview {
  SampleView()
}
