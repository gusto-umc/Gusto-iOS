import ComposableArchitecture
import SwiftUI
import Foundation

enum Tab: String, Equatable, CaseIterable {
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
      case .onboarding(.successLogin):
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
struct TabBarFeature {
  @ObservableState
  struct State {
    var selectedTab: Tab = .map
    var tab1: Tab1Feature.State = .init()
    var tab2: Tab2Feature.State = .init()
  }
  enum Action {
    case selectedTab(Tab)
    case tab1(Tab1Feature.Action)
    case tab2(Tab2Feature.Action)
  }
  var body: some ReducerOf<Self> {
    Scope(state: \.tab1, action: \.tab1) {
      Tab1Feature()
    }
    Scope(state: \.tab2, action: \.tab2) {
      Tab2Feature()
    }
    Reduce { state, action in
      switch action {
      case .selectedTab(let tab):
        state.selectedTab = tab
        return .none
      case let .tab1(.delegate(.deepLink(link))):
        //탭 간 깊은 화면 전환
        //link == "/my/setting/changeName(user: 1e341)"
        return .none
      case .tab2(.delegate(.deepLink(let link))):
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
    case successLogin
  }
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .successLogin:
        return .none
      }
    }
  }
}
struct TMPonboardingView: View {
  let store: StoreOf<TMPonboardingFeature>
  var body: some View {
    Button("finish signUp") {
      store.send(.successLogin)
    }
  }
}

@Reducer
struct Tab1Feature {
  @ObservableState
  struct State {
    var path = StackState<Path.Tab1.State>()
  }
  enum Action {
    case path(StackActionOf<Path.Tab1>)
    case append(Path.Tab1.State)
    case delegate(Delegate)
    enum Delegate {
      case deepLink(String)
    }
  }
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .append(let nextState):
        state.path.append(nextState)
        return .none
      default:
        return .none
      }
    }
    .forEach(\.path, action: \.path)
  }
}

 // !!!: destination관리하는 Path를 전역으로 둘 것인지 tab별로 별도관리할 것인지
//전역관리
extension Path {
  @Reducer
  enum Onboarding {
    case onboarding(TMPonboardingFeature)
  }
}
extension Path {
  @Reducer
  enum Tab1 {
    case one(OneFeature)
    case two(TwoFeature)
    //...
  }
}

//탭 별로 관리한다면 각 탭의 루트뷰에서 별도로 Path 관리
struct Tab4RootView: View {
  @Bindable var store: StoreOf<Tab1Feature>
  var body: some View {
    NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
      
    } destination: { store in
      switch store.case {
      case .one(let store):
        oneview(store: store)
      default: EmptyView()
      }
    }
  }
  
  @Reducer
  enum Path {
    case one(OneFeature)
    case two(TwoFeature)
  }
}

struct Tab1View: View {
  @Bindable var store: StoreOf<Tab1Feature>
  struct Constant {
    var leftInRectanglePadding: CGFloat = 32
    var Fonasdt: Font = .body
  }
  
  var body: some View {
    NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
      Button("1") {
//        store.send(.delegate(.deepLink("2번탭/3화면(name)")))
        store.send(.append(.one(OneFeature.State(text: "1234"))))
      }
    } destination: { store in
      switch store.case {
      case .one(let store):
        oneview(store: store)
      default:
        EmptyView()
      }
    }
  }
}
#Preview("예시") {
  Tab1View(store: Store(initialState: Tab1Feature.State(), reducer: {
    Tab1Feature()
  }))
}

@Reducer struct Tab2Feature {
  struct State {}
  enum Action {
    case delegate(Delegate)
    enum Delegate {
      case deepLink(String)
    }
  }
  var body: some ReducerOf<Self> {
    Reduce {state, action in
      switch action {
      default:
        return .none
      }
    }
  }
}
@Reducer struct OneFeature {
  @ObservableState
  struct State {
    var text: String
  }
  enum Action {
    case asdf
  }
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      default:
        return .none
      }
    }
  }
}
@Reducer struct TwoFeature {
  struct State {}
  enum Action {}
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      return .none
    }
  }
}

struct oneview: View {
  let store: StoreOf<OneFeature>
  
  var body: some View {
    Text(store.text)
  }
}

// MARK: - ViewDestination의 중앙 처리

struct CentralDestinationRouter<PathState, PathAction>: View {
  let pathStore: Store<PathState, PathAction>
  @Dependency(\.log) var logger
  var body: some View {
    //모든 destination 이곳에 선언
    //런타임 캐스팅이 필요(중요포인트: 컴파일 에러가 아님)
    if let tab1Store = pathStore as? StoreOf<Path.Tab1> {
      switch tab1Store.case {
      case .one(let oneFeature):
        oneview(store: oneFeature)
      default:
        logger.log("tab1Store default", category: .warning)
        EmptyView()
      }
    } else {
      logger.log("타입 변환 실패", category: .warning)
      EmptyView()
    }
  }
}

struct Tab1CenteralizeView: View {
  @Bindable var store: StoreOf<Tab1Feature>
  
  var body: some View {
    NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
      Button {
        store.send(.append(.one(OneFeature.State(text: "5252"))))
      } label: {
        Text("1")
      }
    } destination: { nextStore in
      CentralDestinationRouter(pathStore: nextStore)
    }
  }
}

#Preview("central") {
  Tab1CenteralizeView(store: Store(initialState: Tab1Feature.State(), reducer: {
    Tab1Feature()
  }))
}
