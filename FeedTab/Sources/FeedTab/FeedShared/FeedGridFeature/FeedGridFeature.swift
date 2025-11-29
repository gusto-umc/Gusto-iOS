import ComposableArchitecture

@Reducer
public struct FeedGridFeature {
  @ObservableState
  public struct State {
    var feedList: [FeedItem] = []
  }
  public enum Action {
    case appendFeedList([FeedItem])
    case endOfList
    case tabItem(FeedItem)
    case updateFeedList([FeedItem])
    
    case delegate(Delegate)
    public enum Delegate {
      case itemTapped(FeedItem)
      case reachEndOfList
    }
  }
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case let .appendFeedList(list):
        state.feedList.append(contentsOf: list)
        return .none
      case .endOfList:
        return .send(.delegate(.reachEndOfList))
      case let .tabItem(item):
        return .send(.delegate(.itemTapped(item)))
      case let .updateFeedList(list):
        state.feedList = list
        return .none
        
      case .delegate:
        return .none
      }
    }
  }
}

extension FeedGridFeature.State {
  mutating func changeFeedList(_ feedList: [FeedItem]) {
    self.feedList = feedList
  }
  mutating func appendFeedList(_ feedList: [FeedItem]) {
    self.feedList.append(contentsOf: feedList)
  }
}
