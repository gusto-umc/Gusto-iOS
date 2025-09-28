import SwiftUI
import ConfigView

@StyleModifier
struct SomeView: View {
  let text: String
  init(text: String) {
    self.text = text
  }
  private var config: Style = .init()
  struct Style {
    var textColor: Color = .black
    var backgroundColor: Color = .blue
  }
  
  var body: some View {
    Text(text)
      .foregroundStyle(config.textColor)
      .padding()
      .background {
        config.backgroundColor
      }
  }
}

struct DefaultButtonPreview: PreviewProvider {
  static var previews: some View {
    SomeView(text: "test")
      .backgroundColor(.black)
  }
}

struct SomeButton: View {
  @State private var activated: Bool = true
  let action1: ()->Void = {}
  var body: some View {
    Button {
      activated.toggle()
    } label: {
      if activated {
        SomeView(text: "test")
      } else {
        SomeView(text: "test")
          .backgroundColor(.gray)
      }
    }
    .disabled(!activated)
  }
}

#Preview {
  SomeButton()
}
