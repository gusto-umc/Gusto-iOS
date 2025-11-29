import ComposableArchitecture

@Reducer
public struct FeedTabSearchFieldFeature {
  @ObservableState
  public struct State: Equatable {
    var isActivated: Bool = false
    var searchText: String = ""
    var selectedTags: Set<HashTag> = []
    
    public var isEmpty: Bool {
      searchText.isEmpty && selectedTags.isEmpty
    }
  }
  
  public enum Action: BindableAction {
    case binding(BindingAction<State>)
    case clearFocus
    case hashTagTapped(HashTag)
    case perform
    
    case delegate(Delegate)
    public enum Delegate {
      case submit(String, [HashTag], Int64?)
    }
  }
  
  public var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .binding:
        return .none
      case .clearFocus:
        state.isActivated = false
        return .none
      case .hashTagTapped(let tag):
        if state.selectedTags.contains(tag) {
          state.selectedTags.remove(tag)
        } else {
          state.selectedTags.insert(tag)
        }
        return .none
        
      case .perform:
        return .send(.delegate(.submit(state.searchText, Array(state.selectedTags), nil)))
        
        
      case .delegate:
        return .none
      }
    }
  }
}

extension FeedTabSearchFieldFeature.State {
  mutating func clearFocus() -> Effect<FeedTabSearchFieldFeature.Action> {
    return .run { send in
      await send(.clearFocus)
    }
  }
}
