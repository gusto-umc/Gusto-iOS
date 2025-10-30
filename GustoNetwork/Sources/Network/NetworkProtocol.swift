import Foundation

public protocol NetworkProtocol {
  associatedtype T
  var request: @Sendable (URLSession, Requestable) async throws -> T { get }
  var session: URLSession { get }
}
