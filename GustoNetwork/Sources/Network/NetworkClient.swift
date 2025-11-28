import Foundation

public protocol NetworkClient: Sendable {
  func request<T>(_ request: Requestable) async throws -> T
  var session: URLSession { get }
}

extension NetworkClient {
  internal func validate(_ response: URLResponse) throws(NetworkError) {
    guard let httpResponse = response as? HTTPURLResponse else {
      throw NetworkError.invalidResponse
    }
    guard (200..<300) ~= httpResponse.statusCode else {
      throw NetworkError.responseError(statusCode: httpResponse.statusCode)
    }
  }
}
