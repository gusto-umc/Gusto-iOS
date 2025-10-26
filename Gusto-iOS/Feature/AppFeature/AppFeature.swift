import ComposableArchitecture
import SwiftUI
//import Tab1 //탭모듈

public enum Tab: String, Equatable, CaseIterable {
  case map
  case review
  case list
  case feed
  case my
}

@Reducer
public enum AppPath {
  //각 탭의 Path를 연관값으로 들고 있어 접근 가능
  case tab1(Tab1Paths)
  //case feed(FeedPaths)
  //...
}

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

@Reducer
public struct TabBarFeature {
  //스택을 탭이 아닌 TabBar에서 소유
  //!!!: 모든 화면의 모든 store의 action을 이곳에서 처리해야합니다.
  //TODO: 각 탭으로 분리할 수 있으면 좋겠네요
  //각 탭으로 분리를 한다면 이를 위해 Stack을 @Shared로 각 탭Feature에 공유 가능
  //note: 각 탭 별 스택을 사용하지만, 단일 StackState를 사용할 수도 있습니다.
  @ObservableState
  public struct State {
    var selectedTab: Tab = .map
    var tab1Stack: StackState<AppPath.State> = .init()
  }
  public enum Action {
    case selectedTab(Tab)
    case tab1Stack(StackActionOf<AppPath>)
    
    case tmppush
  }
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .selectedTab(let tab):
        state.selectedTab = tab
        return .none
        
      case .tmppush:
        state.tab1Stack.append(.tab1(.탭1의화면1(TMPFeature.State(txt: "테스트"))))
        return .none
        
      case .tab1Stack(.element(id: _, action: .tab1(.탭1의화면1(.delegate(.back))))):
        print("backButtonTapped")
        return .none
        
      default:
        return .none
      }
    }
  }
}
struct TabBarView: View {
  @Bindable var store: StoreOf<TabBarFeature>
  
  var body: some View {
    ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
      TabView(selection: $store.selectedTab.sending(\.selectedTab)) {
        NavigationStack(path: $store.scope(state: \.tab1Stack, action: \.tab1Stack)) {
          Button {
            store.send(.tmppush)
          } label: {
            Text("asdf")
          }
        } destination: { pathStore in
          //코드가 너무 길어져서 뷰 생성을 다른 곳으로 이동
          CentralDestinationRouter(pathStore: pathStore)
        }
        .tag(Tab.map)
        .toolbar(.hidden, for: .tabBar)
        Text("리뷰")
        //...
          .tag(Tab.review)
          .toolbar(.hidden, for: .tabBar)
        Text("리스트")
        //...
          .tag(Tab.list)
          .toolbar(.hidden, for: .tabBar)
        Text("먹스또")
        //...
          .tag(Tab.feed)
          .toolbar(.hidden, for: .tabBar)
        Text("마이")
        //...
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
      .padding(.vertical, 10)
      .background {
        Color.black
      }
    }
    .ignoresSafeArea(edges: [.bottom, .horizontal])
  }
}

struct CentralDestinationRouter<PathState, PathAction>: View {
  let pathStore: Store<PathState, PathAction>
  var body: some View {
    if let pathStore = pathStore as? StoreOf<AppPath> {
      switch pathStore.case {
      case .tab1(let tab1Store):
        if let store = tab1Store.scope(state: \.탭1의화면1, action: \.탭1의화면1) {
          TMPView(store: store)
        } else if let store = tab1Store.scope(state: \.탭1의화면2, action: \.탭1의화면2) {
          TMPView2(store: store)
        } else {
          EmptyView()
        }
      //case .feed(let feedStore):
        //...
      @unknown default:
        EmptyView()
      }
    } else {
      EmptyView()
    }
  }
}







#Preview {
  TabBarView(store: Store(initialState: TabBarFeature.State(), reducer: {
    TabBarFeature()
  }))
}






//MARK: - 탭 모듈

@Reducer
public struct Tab1Paths {
  public init() {}
  @ObservableState
  public enum State {
    case 탭1의화면1(TMPFeature.State)
    case 탭1의화면2(TMPFeature2.State)
  }
  public enum Action {
    case 탭1의화면1(TMPFeature.Action)
    case 탭1의화면2(TMPFeature2.Action)
  }
  public var body: some ReducerOf<Self> {
    Scope(state: \.탭1의화면1, action: \.탭1의화면1) {
      TMPFeature()
    }
    Scope(state: \.탭1의화면2, action: \.탭1의화면2, child: {
      TMPFeature2()
    })
  }
}
//!!!: 모듈화로 접근 제한이 생겨서 다음과 같이 public 선언해도 이니셜라이저 못 찾아서 사용 불가능합니다. 위처럼 명시적으로 생성해야합니다.
//public enum Tab1Paths {
//  case 탭1의화면1(TMPFeature)
//  case 탭1의화면2(TMPFeature)
//}


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
  public init(){}
  @ObservableState
  public struct State {
    public var txt: String
    public init(txt: String) { self.txt = txt }
  }
  public enum Action {
    case delegate(Delegate)
    public enum Delegate {
      case back
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
  @Bindable var store: StoreOf<TMPFeature>
  public init(store: StoreOf<TMPFeature>) {
    self.store = store
  }
  public var body: some View {
    Text(store.txt)
    Button("back") {
      store.send(.delegate(.back))
    }
  }
}
@Reducer
public struct TMPFeature2 {
  public init(){}
  @ObservableState
  public struct State {
    public var txt: String
    public init(txt: String) { self.txt = txt }
  }
  public enum Action {
  }
  public var body: some ReducerOf<Self> {
  }
}
public struct TMPView2: View {
  @Bindable var store: StoreOf<TMPFeature2>
  public init(store: StoreOf<TMPFeature2>) {
    self.store = store
  }
  public var body: some View {
    Text(store.txt)
  }
}
