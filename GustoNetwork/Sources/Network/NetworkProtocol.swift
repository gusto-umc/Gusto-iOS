import Foundation

public protocol NetworkProtocol {
  func request<T>(_ request: Requestable) async throws -> T
  var session: URLSession { get }
}

extension NetworkProtocol {
  internal func validate(_ response: URLResponse) throws(NetworkError) {
    guard let httpResponse = response as? HTTPURLResponse else {
      throw NetworkError.invalidResponse
    }
    guard (200..<300) ~= httpResponse.statusCode else {
      throw NetworkError.responseError(statusCode: httpResponse.statusCode)
    }
  }
}
