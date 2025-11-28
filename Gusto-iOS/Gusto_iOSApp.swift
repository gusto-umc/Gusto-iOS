import SwiftUI
import ComposableArchitecture
import KakaoMapsSDK
import MapFeature
import GustoFont

@main
struct Gusto_iOSApp: App {
  init() {
    FontManager.registerAllFonts()
    SDKInitializer.InitSDK(appKey: Gusto_iOSApp.kakaoMapNativeKey)
  }
  var body: some Scene {
    WindowGroup {
      AppFeatureView(store: Store(initialState: AppFeature.State.tab(TabBarFeature.State()), reducer: {
        AppFeature()
      }))
    }
  }
}

extension Gusto_iOSApp {
  static let kakaoMapNativeKey: String = {
    guard let url = Bundle.main.object(forInfoDictionaryKey: "kakaoMapNativeKey") as? String else {
      print("cannot find kakao native key")
      return ""
    }
    return url
  }()
}
