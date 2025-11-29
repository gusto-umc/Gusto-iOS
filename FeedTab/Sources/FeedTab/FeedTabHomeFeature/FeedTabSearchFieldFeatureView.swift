import SwiftUI
import ComposableArchitecture
import GustoComponent

public struct FeedTabSearchFieldFeatureView: View {
  @Bindable var store: StoreOf<FeedTabSearchFieldFeature>
  @FocusState private var isActivated
  
  public var body: some View {
    GustoComponent.SearchTextField(
      searchText: $store.searchText,
      config: .init(
        placeholder: "맛집 및 해시태그 검색",
        themeColor: Constants.Colors.searchFieldColor
      )
    )
    .padding(.leading, Constants.Paddings.searchFieldLeftPadding)
    .padding(.trailing, Constants.Paddings.searchFieldRightPadding)
    .padding(.top, Constants.Paddings.searchFieldUpPadding)
    .padding(.bottom, Constants.Paddings.searchFieldDownPadding)
    .focused($isActivated)
    .bind($isActivated, to: $store.isActivated)
    .onSubmit {
      store.send(.perform)
    }
  }
}

extension FeedTabSearchFieldFeatureView {
  private enum Constants {
    enum Paddings {
      static let searchFieldUpPadding: CGFloat = 24
      static let searchFieldLeftPadding: CGFloat = 24
      static let searchFieldRightPadding: CGFloat = 24
      static let searchFieldDownPadding: CGFloat = 36
    }
    enum Colors {
      static let searchFieldColor: Color = Color.subM
    }
  }
}

#Preview {
  FeedTabSearchFieldFeatureView(store: Store(initialState: FeedTabSearchFieldFeature.State(), reducer: {
    FeedTabSearchFieldFeature()
  }))
}
