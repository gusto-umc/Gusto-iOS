//
//  OnboardFeatureView.swift
//  Gusto-iOS
//
//  Created by 김민우 on 11/22/25.
//
import SwiftUI
import ComposableArchitecture


struct OnboardFeatureView: View {
    @State var store: StoreOf<OnboardFeature>
    
    var body: some View {
        Text("OnboardFeatureView입니다.")
    }
}
