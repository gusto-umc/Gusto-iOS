import ComposableArchitecture
import GustoResources


@Reducer
public struct FeedTabHomeFeature {
  public init() {}
  
  @ObservableState
  public struct State {
    var lastSearchKeyword: String = ""
    var lastSearchTags: [HashTag] = []
    var lastSearchCursorId: Int64? = nil
    var didSearch: Bool = false
    
    var randomFeedList = FeedGridFeature.State()
    var search = FeedTabSearchFieldFeature.State()
    var searchFeedList = FeedGridFeature.State()
    
    var showSearchResult: Bool {
      didSearch && !search.isEmpty
    }
    public init() {}
  }
  
  public enum Action: BindableAction {
    //MARK: UserAction
    case cancel
    case onAppear
    //MARK: InternalAction
    case binding(BindingAction<State>)
    case delegate(Delegate)
    case internalAction(InternalAction)
    //MARK: ChildAction
    case randomFeedList(FeedGridFeature.Action)
    case search(FeedTabSearchFieldFeature.Action)
    case searchFeedList(FeedGridFeature.Action)
    
    public enum Delegate {
      case tabItem(FeedItem)
    }
    public enum InternalAction {
      case appendRandomFeedList([FeedItem])
      case appendSearchFeedList([FeedItem])
      case loadMoreRandomFeed
      case loadMoreSearchFeed
      case search(String, [HashTag], Int64?)
      case updateSearchFeedCursorId(Int64?)
      case updateSearchFeedList([FeedItem])
    }
  }
  
  @Dependency(\.feedAPIClient) var apiClient
  
  public var body: some ReducerOf<Self> {
    BindingReducer()
    Scope(state: \.search, action: \.search) {
      FeedTabSearchFieldFeature()
    }
    Scope(state: \.randomFeedList, action: \.randomFeedList) {
      FeedGridFeature()
    }
    Scope(state: \.searchFeedList, action: \.searchFeedList) {
      FeedGridFeature()
    }
    Reduce { state, action in
      switch action {
        //MARK: UserAction
      case .cancel:
        return state.search.clearFocus().map(Action.search)
        
      case .onAppear:
        return .send(.internalAction(.loadMoreRandomFeed))
        
        //MARK: InternalAction
      case .binding:
        return .none
        
      case .delegate:
        return .none
        
      case let .internalAction(action):
        switch action {
        case let .appendRandomFeedList(list):
          state.randomFeedList.appendFeedList(list)
          return .none
          
        case let .appendSearchFeedList(list):
          state.searchFeedList.appendFeedList(list)
          return .none
          
        case .loadMoreRandomFeed:
          return .run { [apiClient = apiClient] send in
            do {
              let result = try await apiClient.getRandomFeeds()
              await send(.internalAction(.appendRandomFeedList(result)))
            } catch {
              print("error")
              return
            }
          }
          
        case .loadMoreSearchFeed:
          let apiClient = apiClient
          let keyword = state.lastSearchKeyword
          let tags = state.lastSearchTags
          let cursorId = state.lastSearchCursorId
          guard cursorId != nil else { return .none }
          return .run { send in
            do {
              let result = try await apiClient.search(keyword, tags, cursorId)
              await send(.internalAction(.appendSearchFeedList(result.reviews)))
              await send(.internalAction(.updateSearchFeedCursorId(result.cursorId)))
            }
          }
          
        case let .search(keyword, tags, cursorId):
          let apiClient = apiClient
          return .run { send in
            do {
              let result = try await apiClient.search(keyword, tags, cursorId)
              await send(.internalAction(.updateSearchFeedCursorId(result.cursorId)))
              await send(.internalAction(.updateSearchFeedList(result.reviews)))
            } catch let error {
              print(error)
            }
          }
          
        case let .updateSearchFeedCursorId(id):
          state.lastSearchCursorId = id
          return .none
        case let .updateSearchFeedList(list):
          state.searchFeedList.changeFeedList(list)
          return .none
        }
        
        //MARK: ChildACtion
      case .randomFeedList(.delegate(.reachEndOfList)):
        return .send(.internalAction(.loadMoreRandomFeed))
        
      case let .randomFeedList(.delegate(.itemTapped(item))):
        return .send(.delegate(.tabItem(item)))
        
      case .randomFeedList:
        return .none
        
        
      case let .search(.delegate(.submit(keyword, tags, _))):
        state.didSearch = true
        let clearFocus = state.search.clearFocus().map(Action.search)
        guard !state.search.isEmpty else {
          state.didSearch = false
          return .none
        }
        
        state.lastSearchKeyword = keyword
        state.lastSearchTags = tags
        state.lastSearchCursorId = nil
        state.searchFeedList.changeFeedList([])
        
        return .concatenate(
          .merge(
            .send(.internalAction(.search(keyword, tags, nil))),
            clearFocus
          )
        )
        
      case .search:
        return .none
        
        
      case .searchFeedList(.delegate(.reachEndOfList)):
        return .send(.internalAction(.loadMoreSearchFeed))
        
      case let .searchFeedList(.delegate(.itemTapped(item))):
        return .send(.delegate(.tabItem(item)))
        
      case .searchFeedList:
        return .none
        
      }
    }
  }
}
