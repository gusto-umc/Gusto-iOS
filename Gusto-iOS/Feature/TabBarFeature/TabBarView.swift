import SwiftUI
import ComposableArchitecture
import GustoResources

extension TabBarFeatureView {
  struct TabBarView: View {
    let store: StoreOf<TabBarFeature>
    
    var body: some View {
      HStack {
        ForEach(Tab.allCases, id: \.self) { tab in
          Spacer()
          TabBarItemView(store: store, tab: tab)
        }
        Spacer()
      }
      .padding(.top, Constants.Paddings.tabBarItemUpPadding)
      .padding(.bottom, Constants.Paddings.tabBarItemDownPadding)
      .background {
        let const = Constants.Colors.tabBarShadow
        Color.white
          .shadow(color: const.color, radius: const.radius, y: const.y)
      }
    }
  }
}

extension TabBarFeatureView.TabBarView {
  private enum Constants {
    enum Paddings {
      static let tabBarItemUpPadding: CGFloat = 12
      static let tabBarItemDownPadding: CGFloat = 34
    }
    enum Colors {
      static let tabBarShadow: (color: Color, radius: CGFloat, y: CGFloat) = (Color.black1.opacity(0.1), 8, 4)
    }
  }
}

#Preview {
  TabBarFeatureView.TabBarView(store: Store(initialState: TabBarFeature.State(), reducer: {
    TabBarFeature()
  }))
}
