import ComposableArchitecture
import SwiftUI

struct TabBarFeatureView: View {
  @Bindable var store: StoreOf<TabBarFeature>
  
  var body: some View {
    ZStack(alignment: .bottom) {
      TabView(selection: $store.selectedTab) {
        Text("지도")
          .tag(Tab.map)
          .toolbarVisibility(.hidden, for: .tabBar)
        Text("리뷰")
          .tag(Tab.review)
          .toolbarVisibility(.hidden, for: .tabBar)
        Text("리스트")
          .tag(Tab.list)
          .toolbarVisibility(.hidden, for: .tabBar)
        Text("먹스또")
          .tag(Tab.feed)
          .toolbarVisibility(.hidden, for: .tabBar)
        Text("마이")
          .tag(Tab.my)
          .toolbarVisibility(.hidden, for: .tabBar)
      }
      
      TabBarView(store: store)
    }
    .ignoresSafeArea(edges: [.bottom, .horizontal])
  }
}

#Preview {
  TabBarFeatureView(store: Store(initialState: TabBarFeature.State(), reducer: {
    TabBarFeature()
  }))
}

