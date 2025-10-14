import SwiftUI
import GustoFont

@main
struct Gusto_iOSApp: App {
  init() {
    FontManager.registerAllFonts()
  }
  
  var body: some Scene {
    WindowGroup {
      ContentView()
    }
  }
}
