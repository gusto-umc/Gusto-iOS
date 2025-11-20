import ComposableArchitecture
import SwiftUI
import GustoFont
import GustoResources

struct TabBarFeatureView: View {
  @Bindable var store: StoreOf<TabBarFeature>
  var body: some View {
    ZStack(alignment: .bottom) {
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
            VStack(spacing: Constants.Paddings.tabBarBetweenImageAndTextPadding) {
              Image(tab.iconName)
                .renderingMode(.template)
                .resizable()
                .frame(
                  width: Constants.Sizes.tabBarImageWidth,
                  height: Constants.Sizes.tabBarImageHeight
                )
              Text(tab.tabName)
                .pretendard(Constants.Fonts.tabBarText.font, size: Constants.Fonts.tabBarText.size)
            }
            .foregroundStyle(store.selectedTab == tab ? Constants.Colors.tabBarSelectedColor : Constants.Colors.tabBarUnselectedColor)
          }
        }
        Spacer()
      }
      .padding(.top, Constants.Paddings.tabBarItemUpPadding)
      .padding(.bottom, Constants.Paddings.tabBarItemDownPadding)
      .background {
        Color.white
          .shadow(color: Constants.Colors.tabBarShadow, radius: 8, y: -4)
      }
    }
    .ignoresSafeArea(edges: [.bottom, .horizontal])
  }
}

extension TabBarFeatureView {
  private enum Constants {
    enum Paddings {
      static let tabBarItemUpPadding: CGFloat = 12
      static let tabBarItemDownPadding: CGFloat = 34
      static let tabBarBetweenImageAndTextPadding: CGFloat = 4
    }
    enum Sizes {
      static let tabBarImageWidth: CGFloat = 32
      static let tabBarImageHeight: CGFloat = 32
    }
    enum Colors {
      static let tabBarShadow = Color.black1.opacity(0.1)
      static let tabBarSelectedColor = Color.mainC
      static let tabBarUnselectedColor = Color.grayNavi
    }
    @MainActor
    enum Fonts {
      static let tabBarText: (font: Pretendard, size: CGFloat) = (.black, 10)
    }
  }
}

#Preview {
  TabBarFeatureView(store: Store(initialState: TabBarFeature.State(), reducer: {
    TabBarFeature()
  }))
}
