# 📘 ConfigView 사용 가이드

`ConfigView`는 **SwiftUI 뷰의 스타일의 Custom View를 만들기 위한 매크로**입니다.

---

## 🚀 사용법

1. **ConfigView 모듈 임포트**
```swift
import ConfigView
```

2. **뷰에 `@StyleModifier` 적용**

3. **뷰에 `private struct Style` 선언 (스타일 속성 정의)**

4. **`private var config: Style = .init()` 추가**

5. **명시적 `init` 정의 (private 변수 사용 시 필수)**

6. **`#Preview` 대신 `PreviewProvider`에서 프리뷰 작성**

---

## 💻 코드 예제

### ✅ 기본 뷰 (SomeView)

```swift
import SwiftUI
import ConfigView

@StyleModifier
struct SomeView: View {
  let text: String
  
  init(text: String) {
    self.text = text
  }
  
  private var config: Style = .init()
  private struct Style {
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
```

### 👀 프리뷰 (PreviewProvider)

```swift
struct SomeViewPreview: PreviewProvider {
  static var previews: some View {
    SomeView(text: "Test")
      .backgroundColor(.black) // 스타일 커스터마이징
  }
}
```

---

## 🔘 버튼 예제 (SomeButton)

```swift
struct SomeButton: View {
  @State private var activated: Bool = true
  let action1: () -> Void = {}
  
  var body: some View {
    Button {
      activated.toggle()
    } label: {
      if activated {
        SomeView(text: "Test")
      } else {
        SomeView(text: "Test")
          .backgroundColor(.gray) // 동적 스타일 변경
      }
    }
    .disabled(!activated)
  }
}

#Preview {
  SomeButton()
}
```

---

## 📌 요약

- `ConfigView`는 **스타일 커스터마이징을 손쉽게 하기 위한 SwiftUI 매크로**
- `@StyleModifier` + `private struct Style` 조합으로 확장성 있는 스타일 관리
- 프리뷰 시 `PreviewProvider` 활용으로 안정적인 미리보기 지원

