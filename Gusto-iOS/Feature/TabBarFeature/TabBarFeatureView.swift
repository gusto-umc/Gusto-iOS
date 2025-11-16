import ComposableArchitecture
import SwiftUI

struct TabBarFeatureView: View {
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
      .padding(.vertical, 10)
      .background {
        Color.black
      }
    }
    .ignoresSafeArea(edges: [.bottom, .horizontal])
  }
}


#Preview {
  TabBarFeatureView(store: Store(initialState: TabBarFeature.State(), reducer: {
    TabBarFeature()
  }))
}
