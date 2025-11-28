import ComposableArchitecture

@Reducer
public struct TabBarFeature {
  @ObservableState
  public struct State {
    var selectedTab: Tab = .map
  }
  public enum Action: BindableAction {
    case binding(BindingAction<State>)
    case selectedTab(Tab)
  }
  public var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .binding:
        return .none
      case .selectedTab(let tab):
        state.selectedTab = tab
        return .none
      @unknown default:
        return .none
      }
    }
  }
}
