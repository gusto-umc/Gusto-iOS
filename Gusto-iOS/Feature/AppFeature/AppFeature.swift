import ComposableArchitecture
import SwiftUI

@Reducer
struct AppFeature {
  @ObservableState
  enum State {
    case tab(TabBarFeature.State)
  }
  enum Action {
    case tab(TabBarFeature.Action)
  }
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      default:
        return .none
      }
    }
    .ifCaseLet(\.tab, action: \.tab) {
      TabBarFeature()
    }
  }
}
