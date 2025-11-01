import ComposableArchitecture

@Reducer
public struct TabBarFeature {
  @ObservableState
  public struct State {
    var selectedTab: Tab = .map
  }
  public enum Action {
    case selectedTab(Tab)
  }
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .selectedTab(let tab):
        state.selectedTab = tab
        return .none
      default:
        return .none
      }
    }
  }
}
