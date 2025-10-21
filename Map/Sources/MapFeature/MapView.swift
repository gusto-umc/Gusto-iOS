//
//  MapView.swift
//  Map
//
//  Created by 강동영 on 10/16/25.
//

import SwiftUI
import ComposableArchitecture
import KakaoMapsSDK

public struct MapView: View {
  public var body: some View {
    GustoMapRepresentable()
  }
  
  public init() {}
}

#Preview {
  MapView()
}
