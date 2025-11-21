import SwiftUI
import GustoFont
import GustoResources

struct TabBarItemView: View {
  let tab: Tab
  let isSelected: Bool
  let action: () -> Void
  
  var body: some View {
    Button {
      action()
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
      .foregroundStyle(isSelected ? Constants.Colors.tabBarSelectedColor : Constants.Colors.tabBarUnselectedColor)
    }
  }
}

extension TabBarItemView {
  private enum Constants {
    enum Paddings {
      static let tabBarBetweenImageAndTextPadding: CGFloat = 4
    }
    enum Sizes {
      static let tabBarImageWidth: CGFloat = 32
      static let tabBarImageHeight: CGFloat = 32
    }
    enum Colors {
      static let tabBarSelectedColor = Color.mainC
      static let tabBarUnselectedColor = Color.grayNavi
    }
    struct Fonts {
      static let tabBarText: (font: Pretendard, size: CGFloat) = (.black, 10)
    }
  }
}

#Preview {
  HStack {
    VStack {
      ForEach(Tab.allCases, id: \.self) {
        TabBarItemView(tab: $0, isSelected: false, action: {})
      }
    }
    VStack {
      ForEach(Tab.allCases, id: \.self) {
        TabBarItemView(tab: $0, isSelected: true, action: {})
      }
    }
  }
}
