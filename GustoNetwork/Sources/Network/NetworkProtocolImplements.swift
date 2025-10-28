import Foundation
import Dependencies
import GustoCore
public class VoidNetworkImpl: NetworkProtocol {
  @Dependency(\.log) var log
  private let session: URLSession
  public init(session: URLSession = .shared) {
    self.session = session
  }
  /// Return값 없는 API
  ///  - Parameter request: Requestable
  ///  - Returns: Void
  public func request(_ request: Requestable) async throws {
    guard let url = URL(string: baseURL + request.path),
          !baseURL.isEmpty else {
      throw NetworkError.invalidURL
    }
    let urlRequest = try makeRequest(url: url, with: request)
    let (_, response) = try await session.data(for: urlRequest)
    guard let httpResponse = response as? HTTPURLResponse else {
      log.log("responseError for \(request.path)-\(request.parameters.map(\.description) ?? ""): invalid HTTP response", category: .network)
      throw NetworkError.invalidResponse
    }
    guard (200...299).contains(httpResponse.statusCode) else {
      log.log("responseError for \(request.path)-\(request.parameters.map(\.description) ?? ""): \(httpResponse.statusCode)", category: .network)
      throw NetworkError.responseError(statusCode: httpResponse.statusCode)
    }
    return
  }
}
public class ReturnedNetworkImpl: NetworkProtocol {
  @Dependency(\.log) var log
  private let session: URLSession
  public init(session: URLSession = .shared) {
    self.session = session
  }
  /// 리턴 값 있는 API
  /// - Parameter request: Requestable
  /// - Returns: Decodable
  public func request<T: Decodable>(_ request: Requestable) async throws -> T {
    guard let url = URL(string: baseURL + request.path),
          !baseURL.isEmpty else {
      throw NetworkError.invalidURL
    }
    let urlRequest = try makeRequest(url: url, with: request)
    let (data, response) = try await session.data(for: urlRequest)
    guard let httpResponse = response as? HTTPURLResponse else {
      log.log("responseError for \(request.path)-\(request.parameters.map(\.description) ?? ""): invalid HTTP response", category: .network)
      throw NetworkError.invalidResponse
    }
    guard (200...299).contains(httpResponse.statusCode) else {
      log.log("responseError for \(request.path)-\(request.parameters.map(\.description) ?? ""): \(httpResponse.statusCode)", category: .network)
      throw NetworkError.responseError(statusCode: httpResponse.statusCode)
    }
    
    guard !data.isEmpty else {
      throw NetworkError.noData
    }
    
    do {
      let decodedObject = try JSONDecoder().decode(T.self, from: data)
      log.log("Success for: \(request.path)", category: .info)
      return decodedObject
    } catch {
      log.log("Decoding Faile for \(request.path), \(String(describing: T.self)): \(error.localizedDescription)", category: .warning)
      throw NetworkError.decodingFailed(error)
    }
  }
}
