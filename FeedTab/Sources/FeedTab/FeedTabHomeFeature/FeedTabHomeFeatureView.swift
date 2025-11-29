import ComposableArchitecture
import SwiftUI
import GustoResources
import GustoComponent

public struct FeedTabHomeFeatureView: View {
  @Bindable var store: StoreOf<FeedTabHomeFeature>
  @State private var tagListSize: CGSize = .zero
  @State private var searchBoxFrame: Anchor<CGRect>? = nil
  public init(store: StoreOf<FeedTabHomeFeature>) {
    self.store = store
  }
  
  public var body: some View {
    VStack(spacing: 0) {
      FeedTabSearchFieldFeatureView(store: store.scope(state: \.search, action: \.search))
        .background {
          BackgroundOnSearching(store: store)
        }
        .anchorPreference(key: SearchBoxKey.self, value: .bounds, transform: {$0})
        .onPreferenceChange(SearchBoxKey.self) { value in
          searchBoxFrame = value
        }
      
      FeedListView(store: store, tagListSize: $tagListSize, searchBoxFrame: $searchBoxFrame)
        .onPreferenceChange(TagListSize.self, perform: { value in
          tagListSize = value
        })
    }
    .onAppear {
      store.send(.onAppear)
    }
  }
  
  private struct BackgroundOnSearching: View {
    let store: StoreOf<FeedTabHomeFeature>
    var body: some View {
      if store.search.isActivated {
        Constants.Colors.searchingOverlay
          .ignoresSafeArea()
          .onTapGesture {
            store.send(.cancel)
          }
      }
    }
  }
  private struct FeedListView: View {
    let store: StoreOf<FeedTabHomeFeature>
    @Binding var tagListSize: CGSize
    @Binding var searchBoxFrame: Anchor<CGRect>?
    
    var body: some View {
      Group {
        if !store.didSearch {
          //검색하지 않았을 경우 랜덤피드
          FeedGridFeatureView(
            store: store.scope(state: \.randomFeedList, action: \.randomFeedList),
            config: .init()
          )
        } else {
          //검색했을 경우 검색 결과
          FeedGridFeatureView(
            store: store.scope(state: \.searchFeedList, action: \.searchFeedList),
            config: .init()
          )
        }
      }
      .padding(.horizontal, Constants.Spacing.feedListHorizontalPadding)
      .overlay {
        BackgroundOnSearching(store: store)
      }
      .overlay {
        //검색창 선택 시 태그 선택하는 화면
        if store.search.isActivated {
          GeometryReader { proxy in
            if let calculator = PositionCalculator.calculate(
              searchBoxFrame: searchBoxFrame,
              tagListSize: tagListSize,
              in: proxy
            ) {
              TagListView(store: store.scope(state: \.search, action: \.search))
                .position(calculator.position)
                .padding(.horizontal, calculator.horizontalPadding)
            }
          }
        }
      }
    }
  }
  
  private struct TagListView: View {
    let store: StoreOf<FeedTabSearchFieldFeature>
    
    var body: some View {
      FlowLayout(
        horizontalSpacing: Constants.Paddings.tagListHorizontalPadding,
        verticalSpacing: Constants.Paddings.tagListVerticalPadding
      ) {
        ForEach(HashTag.allCases, id: \.self) { tag in
          Button {
            store.send(.hashTagTapped(tag))
          } label: {
            HashTagView(tag: tag, selected: store.selectedTags.contains(tag))
          }
        }
      }
      .background {
        GeometryReader { proxy in
          Color.clear
            .preference(key: TagListSize.self, value: proxy.size)
        }
      }
    }
    
    private enum Constants {
      enum Paddings {
        static let tagListHorizontalPadding: CGFloat = 12
        static let tagListVerticalPadding: CGFloat = 12
      }
    }
  }
  
  private struct PositionCalculator {
    let searchBoxRect: CGRect
    let tagListSize: CGSize
    let horizontalPadding: CGFloat
    let verticalOffset: CGFloat
    var position: CGPoint {
      CGPoint(
        x: searchBoxRect.minX + tagListSize.width / 2,
        y: searchBoxRect.maxY + tagListSize.height / 2 + verticalOffset
      )
    }
    
    static func calculate(
      searchBoxFrame: Anchor<CGRect>?,
      tagListSize: CGSize,
      in proxy: GeometryProxy,
      horizontalPadding: CGFloat = FeedTabHomeFeatureView.Constants.Spacing.tagListHorizontalPadding,
      verticalOffset: CGFloat = FeedTabHomeFeatureView.Constants.Spacing.tagListVerticalOffset
    ) -> PositionCalculator? {
      guard let frame = searchBoxFrame else { return nil }
      return PositionCalculator(
        searchBoxRect: proxy[frame],
        tagListSize: tagListSize,
        horizontalPadding: horizontalPadding,
        verticalOffset: verticalOffset
      )
    }
  }
}

extension FeedTabHomeFeatureView {
  enum Constants {
    enum Spacing {
      static let feedListHorizontalPadding: CGFloat = 8
      static let tagListHorizontalPadding: CGFloat = 35
      static let tagListVerticalOffset: CGFloat = -8
    }
    enum Colors {
      static let searchingOverlay: Color = Color.black1.opacity(0.6)
    }
  }
}

extension FeedTabHomeFeatureView {
  struct SearchBoxKey: PreferenceKey {
    typealias Value = Anchor<CGRect>?
    static let defaultValue: Value = nil
    
    static func reduce(value: inout Value, nextValue: () -> Value) {
      value = nextValue()
    }
  }
  struct TagListSize: PreferenceKey {
    typealias Value = CGSize
    static let defaultValue: Value = .zero
    static func reduce(value: inout Value, nextValue: () -> Value) {
      if nextValue() == .zero {
        return
      }
      value = nextValue()
    }
  }
  
}


#Preview {
  FeedTabHomeFeatureView(store: Store(initialState: FeedTabHomeFeature.State(), reducer: {
    FeedTabHomeFeature()
  }))
}


