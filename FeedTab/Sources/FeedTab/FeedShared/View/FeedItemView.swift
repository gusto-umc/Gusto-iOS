import SwiftUI

struct FeedItemView: View {
  let item: FeedItem
  
  var body: some View {
    AsyncImage(url: URL(string: item.images)) { image in
      image
        .resizable()
        .scaledToFit()
        .padding(1)
        .background(.white)
    } placeholder: {
      ProgressView()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .aspectRatio(1, contentMode: .fit)
    }
  }
}

#Preview {
  ZStack {
    Color.blue
    FeedItemView(item: .init(reviewId: 1, images: "https://picsum.photos/400/400"))
      .frame(width: 120, height: 120)
  }
}
