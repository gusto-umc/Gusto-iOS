import Foundation

public final class NetworkProtocolImpl: NetworkClient {
  public let session: URLSession
  
  public init(session: URLSession) {
    self.session = session
  }
  
  public func request<T>(_ request: Requestable) async throws -> T {
    let request = try request.makeRequest()
    let (_, response) = try await session.data(for: request)
    try validate(response)
    return () as! T
  }
  public func request<T>(_ request: Requestable) async throws -> T where T: Decodable {
    let request = try request.makeRequest()
    let (data, response) = try await session.data(for: request)
    try validate(response)
    guard !data.isEmpty else {
      throw NetworkError.noData
    }
    return try JSONDecoder().decode(T.self, from: data)
  }
}
