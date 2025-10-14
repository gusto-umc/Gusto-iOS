import SwiftUI
import ComposableArchitecture

@main
struct Gusto_iOSApp: App {
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
