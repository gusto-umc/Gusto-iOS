import ComposableArchitecture
import SwiftUI

//MARK: - App모듈
//import SomeTab
//import SomeTab2 ...
@Reducer
struct SharedPath {
  public enum State: TabState {
    case share1(SharedFeature.State)
  }
  public enum Action: TabAction {
    case share1(SharedFeature.Action)
  }
  public var body: some ReducerOf<Self> {
    Scope(state: \.share1, action: \.share1) {
      SharedFeature()
    }
  }
}

@Reducer
struct AppPathReducer {
  struct State {
    var tab1: SomeTab.State = .init()
  }
  enum Action {
    case tab1(SomeTab.Action)
  }
  var body: some ReducerOf<Self> {
    Scope(state: \.tab1, action: \.tab1) {
      SomeTab()
    }
    Reduce { state, action in
      switch action {
      case .tab1(.appends(let tabState)):
        state.tab1.paths.append(tabState)
        return .none
      default:
        return .none
      }
    }
  }
}


#Preview {
  SomeTabView2(store: Store(initialState: SomeTab.State(), reducer: {
    SomeTab()
  }))
}

struct SharedPathRouter {
  struct SharedState: TabState {
    var state: SharedPath.State
  }
  enum SharedAction: TabAction {
    case action(SharedPath.Action)
  }
  
  func wrapState(_ state: SharedPath.State) -> SharedState {
    SharedState(state: state)
  }
  func wrapAction(_ action: SharedPath.Action) -> SharedAction {
    .action(action)
  }
  
  @MainActor @ViewBuilder
  func destination(store: Store<SharedState, SharedAction>) -> some View {
    SwitchStore(store) { state in
      CaseLet(\SharedPath.State.share1, action: SharedPath.Action.share1) { store in
        SharedView(store: store)
      }
    }
  }
}
extension SharedPathRouter: DependencyKey {
  static let liveValue: SharedPathRouter = {
    SharedPathRouter()
  }()
}

extension DependencyValues {
  var router: SharedPathRouter {
    get {self[SharedPathRouter.self]}
    set {self[SharedPathRouter.self] = newValue}
  }
}
