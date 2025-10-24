import ComposableArchitecture
import SwiftUI
import Foundation

//MARK: - 탭 모듈 레이어
protocol TabState {}
protocol TabAction {}


@Reducer
struct SomeTab {
  @ObservableState
  struct State {
    var paths = StackState<any TabState>()
  }
  enum Action {
    case paths(StackAction<any TabState, any TabAction>)
    case appends(any TabState)
  }
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .appends(let a):
        state.paths.append(a)
        return .none
      default:
        return .none
      }
    }
  }
}

@Reducer
internal struct SomeTabPaths {
  @ObservableState
  enum State: TabState {
    case one(isolFeature.State)
    case two(isolFeature.State)
    case shared(TabState)
  }
  enum Action: TabAction {
    case one(isolFeature.Action)
    case two(isolFeature.Action)
    case shared(TabAction)
  }
  var body: some ReducerOf<Self> {
    Scope(state: \.one, action: \.one) {
      isolFeature()
    }
    Scope(state: \.two, action: \.two) {
      isolFeature()
    }
  }
}

@Reducer
public struct SharedFeature {
  public struct State {}
  public enum Action {
    case buttonTapped
  }
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .buttonTapped:
        print("SharedButton Tapped")
        return .none
      }
    }
  }
}
struct SharedView: View {
  let store: StoreOf<SharedFeature>
  
  var body: some View {
    Button("Shared") {
      store.send(.buttonTapped)
    }
  }
}
@Reducer
struct isolFeature {
  @ObservableState
  struct State {
    var txt: String
  }
  enum Action {}
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {}
    }
  }
}
struct isolView: View {
  let store: StoreOf<isolFeature>
  
  var body: some View {
    Text(store.txt)
  }
}
struct SomeTabView2: View {
  @Bindable var store: StoreOf<SomeTab>
  @Dependency(\.router) var sharedPathRouter
  var body: some View {
    NavigationStackStore(store.scope(state: \.paths, action: \.paths)) {
      Button("shared") {
//        store.send(.appends(SomeTabPaths.State.shared(<#T##any TabState#>)))
//        store.send(.appends(SomeTabPaths.State.shared(store.state.sharedPath.State.share1(SharedFeature.State()))))
      }
      Button("one") {
        let oneState = SomeTabPaths.State.one(.init(txt: "one"))
        store.send(.appends(oneState))
        print("Button one tapped, appending: \(oneState)")
      }
    } destination: { store in
      let _ = print("destination: \(String(describing: type(of: store)))")
      switch store {
      //!!!: 이곳에서 적절한 타입과 매칭이 실패
      default:
        EmptyView()
      }
    }
  }
}

#Preview {
  SomeTabView2(store: Store(initialState: SomeTab.State(), reducer: {
    SomeTab()
  }))
}

enum small {
  case one, two, three
  
}


