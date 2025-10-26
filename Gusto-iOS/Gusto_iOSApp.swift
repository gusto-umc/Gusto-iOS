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
      AppView(store: Store(initialState: AppFeature.State.onboarding(TMPonboardingFeature.State()), reducer: {
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
