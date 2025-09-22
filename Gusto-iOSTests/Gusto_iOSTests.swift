import Testing
import Foundation
@testable import Gusto_iOS

struct Gusto_iOSTests {
  
  @Test func example() async throws {
    struct TestRequest: Requestable {
      var path: String
      var method: HTTPMethod
      var headers: [String : String]?
      var parameters: [String : Any]?
      var body: Data?
      var retry: Int
      var delay: Duration
    }
    
    func checkDuplicateNickName(name: String) async throws {
      do {
        try await NetworkProvider().request(
          TestRequest(
            path: "/users/check-nickname/\(name)",
            method: .get,
            retry: 1,
            delay: .seconds(0.5)
          )
        )
      } catch {
        throw NetworkError.responseError(statusCode: 409)
      }
    }
    do {
      try await checkDuplicateNickName(name: "TEST")
      print("success")
    } catch {
      print("error: \(error)")
    }
  }
  
}
