import SwiftUI
import KakaoMapsSDK
import MapFeature

@main
struct Gusto_iOSApp: App {
  init() {
    SDKInitializer.InitSDK(appKey: Gusto_iOSApp.kakaoMapNativeKey)
  }
  var body: some Scene {
    WindowGroup {
      ContentView()
    }
  }
}

extension Gusto_iOSApp {
  static let kakaoMapNativeKey: String = {
    guard let url = Bundle.main.object(forInfoDictionaryKey: "kakaoMapNativeKey") as? String else {
      LogManager().log("cannot find kakao native key", category: .error)
      return ""
    }
    return url
  }()
}
