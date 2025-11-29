import ComposableArchitecture
import SwiftUI
public struct FeedGridFeatureView: View {
  let store: StoreOf<FeedGridFeature>
  let config: Config
  
  @State private var scrollPosition: ScrollPosition = .init(idType: FeedItem.ID.self)
  @Namespace private var topAnchor
  
  public init(store: StoreOf<FeedGridFeature>, config: Config) {
    self.store = store
    self.config = config
  }
  
  private var columns: [GridItem] {
    Array(repeating: GridItem(.flexible(), spacing: config.horizontalPadding), count: config.countOfColumn)
  }
  public var body: some View {
    ScrollViewReader { scrollProxy in
      ScrollView {
        LazyVGrid(
          columns: columns,
          alignment: .center,
          spacing: config.verticalPadding
        ) {
          ForEach(store.feedList) { item in
            Button {
              store.send(.tabItem(item))
            } label: {
              FeedItemView(item: item)
                .onAppear {
                  if item == store.feedList.last {
                    store.send(.endOfList)
                  }
                }
            }
            .id(item.id)
          }
        }
        .id(topAnchor)
      }
      .scrollPosition($scrollPosition, anchor: .top)
    }
  }
}

extension FeedGridFeatureView {
  public struct Config {
    let countOfColumn: Int
    let horizontalPadding: CGFloat
    let verticalPadding: CGFloat
    
    public init(countOfColumn: Int = 3, horizontalPadding: CGFloat = 0, verticalPadding: CGFloat = 0) {
      self.countOfColumn = countOfColumn
      self.horizontalPadding = horizontalPadding
      self.verticalPadding = verticalPadding
    }
  }
}
