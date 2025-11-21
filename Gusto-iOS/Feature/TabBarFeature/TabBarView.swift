import SwiftUI
import GustoResources

struct TabBarView: View {
  @Binding var selectedTab: Tab
  
  var body: some View {
    HStack {
      ForEach(Tab.allCases, id: \.self) { tab in
        Spacer()
        TabBarItemView(
          tab: tab,
          isSelected: tab == selectedTab,
          action: { selectedTab = tab }
        )
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
}

extension TabBarView {
  private enum Constants {
    enum Paddings {
      static let tabBarItemUpPadding: CGFloat = 12
      static let tabBarItemDownPadding: CGFloat = 34
    }
    enum Colors {
      static let tabBarShadow = Color.black1.opacity(0.1)
    }
  }
}

#Preview {
  @Previewable @State var selectedTab: Tab = .map
  TabBarView(selectedTab: $selectedTab)
}
