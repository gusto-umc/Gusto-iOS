import Foundation
import GustoLogger

public protocol NetworkProtocol {
  associatedtype T
  var request: @Sendable (Requestable) async throws -> T { get }
}
