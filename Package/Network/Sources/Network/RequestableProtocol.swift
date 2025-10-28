import Foundation

public protocol Requestable {
  var path: String { get }
  var method: HTTPMethod { get }
  var headers: [String: String]? { get }
  var parameters: [String: Any]? { get }
  var body: Data? { get }
}
public protocol RetryRequestable: Requestable {
  var retry: Int { get set }
  var delay: Duration { get set }
}

