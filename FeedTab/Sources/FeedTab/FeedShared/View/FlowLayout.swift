import SwiftUI
struct FlowLayout: Layout {
  var horizontalSpacing: CGFloat = 8
  var verticalSpacing: CGFloat = 8
  
  func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
    var width: CGFloat = 0
    var height: CGFloat = 0
    var rowHeight: CGFloat = 0
    
    let maxWidth = proposal.width ?? 0
    
    for subview in subviews {
      let size = subview.sizeThatFits(.unspecified)
      
      // 줄바꿈 처리
      if width + size.width > maxWidth {
        width = 0
        height += rowHeight + verticalSpacing
        rowHeight = 0
      }
      
      width += size.width + horizontalSpacing
      rowHeight = max(rowHeight, size.height)
    }
    
    return CGSize(width: maxWidth, height: height + rowHeight)
  }
  
  func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
    var x = bounds.minX
    var y = bounds.minY
    var rowHeight: CGFloat = 0
    
    for subview in subviews {
      let size = subview.sizeThatFits(.unspecified)
      
      // 줄바꿈 처리
      if x + size.width > bounds.maxX {
        x = bounds.minX
        y += rowHeight + verticalSpacing
        rowHeight = 0
      }
      
      subview.place(at: CGPoint(x: x, y: y), proposal: proposal)
      x += size.width + horizontalSpacing
      rowHeight = max(rowHeight, size.height)
    }
  }
}

