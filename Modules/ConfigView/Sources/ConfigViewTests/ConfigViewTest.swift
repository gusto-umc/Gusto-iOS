import XCTest
import SwiftSyntax
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import ConfigViewMacros

final class StyleModifierTests: XCTestCase {
  func testStyleModifier() throws {
    assertMacroExpansion(
            """
            @StyleModifier
            struct TestView: View {
                private var config: Style = .init()
                struct Style {
                    var textColor: Color = .black
                    var fontt: Font = .body
                }
                var body: some View {
                    Text("asdf")
                        .foregroundStyle(config.textColor)
                }
            }
            """,
            expandedSource: """
            struct TestView: View {
                private var config: Style = .init()
                struct Style {
                    var textColor: Color = .black
                    var fontt: Font = .body
                }
                var body: some View {
                    Text("asdf")
                        .foregroundStyle(config.textColor)
                }
            }
            
            extension TestView {
                func textColor(_ value: Color) -> Self {
                    var mutableSelf = self
                    mutableSelf.config.textColor = value
                    return mutableSelf
                }
                func fontt(_ value: Font) -> Self {
                    var mutableSelf = self
                    mutableSelf.config.fontt = value
                    return mutableSelf
                }
            }
            """,
            macros: ["StyleModifier": StyleModifierMacro.self]
    )
  }
}
