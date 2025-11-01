import SwiftUI
import ComposableArchitecture

struct AppFeatureView: View {
  let store: StoreOf<AppFeature>
  
  var body: some View {
    switch store.state {
    case .tab:
      IfLetStore(store.scope(state: \.tab, action: \.tab)) { tabBarStore in
        TabBarFeatureView(store: tabBarStore)
      }
    }
  }
}
