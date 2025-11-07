import SwiftUI
import ComposableArchitecture
import GustoFont

@main
struct Gusto_iOSApp: App {
  init() {
    FontManager.registerAllFonts()
  }
  
  var body: some Scene {
    WindowGroup {
      AppFeatureView(store: Store(initialState: AppFeature.State.tab(TabBarFeature.State()), reducer: {
        AppFeature()
      }))
    }
  }
}


#Preview {
  AppView(store: Store(initialState: AppFeature.State.onboarding(TMPonboardingFeature.State()), reducer: {
    AppFeature()
  }))
}
