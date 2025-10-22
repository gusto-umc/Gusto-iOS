import ComposableArchitecture
import SwiftUI
import Foundation

public enum Tab: String, Equatable, CaseIterable {
  case map
  case review
  case list
  case feed
  case my
}

public enum Path {}
@Reducer
struct AppFeature {
  @ObservableState
  enum State {
    case onboarding(TMPonboardingFeature.State)
    case tab(TabBarFeature.State)
  }
  enum Action {
    case onboarding(TMPonboardingFeature.Action)
    case tab(TabBarFeature.Action)
  }
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
        //로그인 성공 시 tab으로 이동
      case .onboarding(.delegate(.successLogin)):
        state = .tab(TabBarFeature.State())
        return .none
      default:
        return .none
      }
    }
    .ifCaseLet(\.onboarding, action: \.onboarding) {
      TMPonboardingFeature()
    }
    .ifCaseLet(\.tab, action: \.tab) {
      TabBarFeature()
    }
  }
}

@Reducer
public struct TabBarFeature {
  @ObservableState
  public struct State {
    var selectedTab: Tab = .map
    var tab1: TMPFeature.State = .init(txt: "1")
    var tab2: TMPFeature.State = .init(txt: "2")
  }
  public enum Action {
    case selectedTab(Tab)
    case tab1(TMPFeature.Action)
    case tab2(TMPFeature.Action)
  }
  public var body: some ReducerOf<Self> {
    Scope(state: \.tab1, action: \.tab1) {
      TMPFeature()
    }
    Scope(state: \.tab2, action: \.tab2) {
      TMPFeature()
    }
    Reduce { state, action in
      switch action {
      case .selectedTab(let tab):
        state.selectedTab = tab
        return .none
      case .tab1(.delegate(.routing(let link))):
        //탭 간 깊은 화면 전환
        //link == "/my/setting/changeName(user: 1e341)"
        return .none
      case .tab2(.delegate):
        return .none
      default:
        return .none
      }
    }
  }
}

struct AppView: View {
  let store: StoreOf<AppFeature>
  
  var body: some View {
    switch store.state {
    case .onboarding:
      IfLetStore(store.scope(state: \.onboarding, action: \.onboarding)) { onboardingStore in
        TMPonboardingView(store: onboardingStore)
      }
    case .tab:
      IfLetStore(store.scope(state: \.tab, action: \.tab)) { tabBarStore in
        TabBarView(store: tabBarStore)
      }
    }
  }
}

struct TabBarView: View {
  @Bindable var store: StoreOf<TabBarFeature>
  
  var body: some View {
    ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
      TabView(selection: $store.selectedTab.sending(\.selectedTab)) {
        Text("지도")
          .tag(Tab.map)
          .toolbar(.hidden, for: .tabBar)
        Text("리뷰")
          .tag(Tab.review)
          .toolbar(.hidden, for: .tabBar)
        Text("리스트")
          .tag(Tab.list)
          .toolbar(.hidden, for: .tabBar)
        Text("먹스또")
          .tag(Tab.feed)
          .toolbar(.hidden, for: .tabBar)
        Text("마이")
          .tag(Tab.my)
          .toolbar(.hidden, for: .tabBar)
      }

      HStack {
        ForEach(Tab.allCases, id: \.self) { tab in
          Spacer()
          Button {
            store.send(.selectedTab(tab))
          } label: {
            Text(tab.rawValue)
          }
        }
        Spacer()
      }
      .padding(.bottom, 10)
    }
    .ignoresSafeArea(edges: [.bottom, .horizontal])
  }
}
#Preview {
  AppView(store: Store(initialState: AppFeature.State.onboarding(TMPonboardingFeature.State()), reducer: {
    AppFeature()
  }))
}



//MARK: - 빌드하기 위한 임시 코드
@Reducer
struct TMPonboardingFeature {
  struct State {}
  enum Action {
    case delegate(Delegate)
  }
  public enum Delegate {
    case successLogin
  }
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .delegate:
        return .none
      }
    }
  }
}
struct TMPonboardingView: View {
  let store: StoreOf<TMPonboardingFeature>
  var body: some View {
    Button("finish signUp") {
      store.send(.delegate(.successLogin))
    }
  }
}

@Reducer
public struct TMPFeature {
  @ObservableState
  public struct State {
    var txt: String
  }
  public enum Action {
    case delegate(Delegate)
    //NOTE: delegate 내부 라우팅
    public enum Delegate {
      case back
      case routing(Any)
    }
    //NOTE: 별도 라우팅
    case routing(Routing)
    public enum Routing {
      case routing(Any)
    }
  }
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .delegate(let delegate):
        switch delegate {
        case .back:
          return .none
        case .routing:
          return .none
        default:
          return .none
        }
      default:
        break
      }
      return .none
    }
  }
}
public struct TMPView: View {
  let store: StoreOf<TMPFeature>

  public var body: some View {
    Text(store.txt)
  }
}

//MARK: - 탭 별 Path 관리
@Reducer
public struct 탭1루트피쳐 {
  @ObservableState
  public struct State {
    var path = StackState<Paths.State>()
  }
  public enum Action {
    case path(StackActionOf<Paths>)
    case append(Paths.State)
    case delegate(Delegate)
    
    case onAppear
    
    public enum Delegate {
      case deepLink(Any)
      case logout
      case login
    }
  }
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .append(let nextPathState):
        state.path.append(nextPathState)
        return .none
      default:
        return .none
      }
    }
    .forEach(\.path, action: \.path)
  }
  
  @Reducer
  public enum Paths {
    case 탭1의화면1(TMPFeature)
    case 탭1의화면2(TMPFeature)
  }
}


//MARK: - 탭 별 destination 관리
public struct 탭1루트뷰: View {
  @Bindable var store: StoreOf<탭1루트피쳐>
  private struct Constant {
    var leftInRectanglePadding: CGFloat = 32
    var Fonasdt: Font = .body
  }
  
  public var body: some View {
    NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
      Button("1") {
        store.send(.append(.탭1의화면1(TMPFeature.State(txt: "TEST"))))
      }
    } destination: { store in
      switch store.case {
      case .탭1의화면1(let store):
        TMPView(store: store)
      default:
        EmptyView()
      }
    }
  }
}

#Preview("예시") {
  탭1루트뷰(store: Store(initialState: 탭1루트피쳐.State(), reducer: {
    탭1루트피쳐()
  }))
}
 // !!!: destination관리하는 Path를 전역으로 둔다면 이렇게
//전역관리
extension Path {
  @Reducer
  enum Onboarding {
    case onboarding(TMPonboardingFeature)
  }
}
extension Path {
  @Reducer
  public enum Tab1 {
    case one(TMPFeature)
    case two(TMPFeature)
    //...
  }
}

// MARK: - ViewDestination의 중앙 처리

struct CentralDestinationRouter<PathState, PathAction>: View {
  let pathStore: Store<PathState, PathAction>
  @Dependency(\.log) var logger
  var body: some View {
    if let tab1Store = pathStore as? StoreOf<탭1루트피쳐.Paths> {
      switch tab1Store.case {
      case .탭1의화면1(let nextStore):
        TMPView(store: nextStore)
      default:
        let _ = logger.log("tab1Store default", category: .warning)
      }
    } else if let tab1Store = pathStore as? StoreOf<Path.Tab1> {
      switch tab1Store.case {
      case .one(let nextFeature):
        TMPView(store: nextFeature)
      default:
        let _ = logger.log("tab1Store default", category: .warning)
        EmptyView()
      }
    } else {
      let _ = logger.log("타입 변환 실패", category: .warning)
      EmptyView()
    }
  }
}

struct Tab1CenteralizeView: View {
  @Bindable var store: StoreOf<탭1루트피쳐>
  
  var body: some View {
    NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
      Button {
        store.send(.append(.탭1의화면1(TMPFeature.State(txt: "Central"))))
      } label: {
        Text("append")
      }
    } destination: { nextStore in
      CentralDestinationRouter(pathStore: nextStore)
    }
  }
}

#Preview("central") {
  Tab1CenteralizeView(store: Store(initialState: 탭1루트피쳐.State(), reducer: {
    탭1루트피쳐()
  }))
}
