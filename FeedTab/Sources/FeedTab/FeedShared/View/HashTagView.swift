import SwiftUI
import GustoResources
import GustoFont

public struct HashTagView: View {
  let tag: HashTag
  let selected: Bool
  public var body: some View {
    Text("# \(tag.text)")
      .lineLimit(1)
      .foregroundStyle(Constants.Colors.textColor)
      .padding(.vertical, 4)
      .padding(.horizontal, 8)
      .background {
        RoundedRectangle(cornerRadius: 13)
          .fill(selected ? Constants.Colors.selectedColor : .clear)
          .stroke(Constants.Colors.rectColor, lineWidth: 1)
          .foregroundStyle(Constants.Colors.rectColor)
      }
  }
}

extension HashTagView {
  private enum Constants {
    enum Colors {
      static let textColor: Color = .white
      static let rectColor: Color = .subM
      static let selectedColor: Color = .subM
    }
    enum Fonts {
      static let textFont: (font: Pretendard, size: CGFloat) = (.medium, 15)
    }
  }
}

#Preview {
  ZStack {
    Color.gray.opacity(0.6)
    HStack {
      HashTagView(tag: .warm, selected: true)
      HashTagView(tag: .warm, selected: false)
    }
  }
}
