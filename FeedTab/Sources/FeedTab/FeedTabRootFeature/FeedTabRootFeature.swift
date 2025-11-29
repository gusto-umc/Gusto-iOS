import ComposableArchitecture

@Reducer
public struct FeedTabRootFeature {
  public init() {}
  @ObservableState
  public struct State {
    var stackState: StackState<FeedPaths.State> = .init([FeedPaths.State.home(.init())])
    
    public init() {}
  }
  public enum Action {
    case stackAction(StackActionOf<FeedPaths>)
    
    case internalAction(InternalAction)
    public enum InternalAction {
      case append(FeedPaths.State)
    }
  }
  
  @Dependency(\.feedAPIClient) var apiClient
  
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case let .stackAction(.element(id: _, action: .home(.delegate(.tabItem(item))))):
//        let apiClient = apiClient
//        return .run { send in
//          do {
//            let result =  try await apiClient.getDetailReview(item.id)
//            let detailState = FeedPaths.State.detail(.init(feedDetail: result))
//            await send(.internalAction(.append(detailState)))
//          } catch let error {
//            print(error)
//          }
//        }
        return .none
        
      case .stackAction:
        return .none
        
        
      case let .internalAction(.append(nextState)):
        state.stackState.append(nextState)
        return .none
      }
    }
    .forEach(\.stackState, action: \.stackAction)
  }
}

import SwiftUI
public struct FeedTabRootView: View {
  @Bindable var store: StoreOf<FeedTabRootFeature>
  public init(store: StoreOf<FeedTabRootFeature>) {
    self.store = store
  }
  public var body: some View {
    NavigationStack(path: $store.scope(state: \.stackState, action: \.stackAction)) {
    } destination: { nextStore in
      Group {
        switch nextStore.case {
        case .home(let homeStore):
          FeedTabHomeFeatureView(store: homeStore)
//        case .detail(let detailStore):
//          EmptyView()
        }
      }
      .toolbarVisibility(.hidden, for: .navigationBar)
    }

  }
}

#Preview {
  FeedTabRootView(store: Store(initialState: FeedTabRootFeature.State(), reducer: {
    FeedTabRootFeature()
  }))
}
