import Foundation
import Dependencies
public enum HTTPMethod: String {
  case get = "GET"
  case post = "POST"
  case put = "PUT"
  case delete = "DELETE"
  case patch = "PATCH"
}
public enum NetworkError: Error {
  case invalidURL
  case requestFailed(Error)
  case invalidResponse
  case responseError(statusCode: Int)
  case noData
  case decodingFailed(Error)
  case unknown
}

public protocol Requestable {
  var path: String { get }
  var method: HTTPMethod { get }
  var headers: [String: String]? { get }
  var parameters: [String: Any]? { get }
  var body: Data? { get }
  
  var retry: Int { get set }
  var delay: Duration { get set }
}

public class NetworkProvider {
  @Dependency(\.log) var log
  private let session: URLSession
  static let baseURL: String = {
    guard let url = Bundle.main.object(forInfoDictionaryKey: "BASE_URL") as? String else {
      LogManager().log("cannot find base url", category: .error)
      return ""
    }
    return url
  }()
  init(session: URLSession = .shared) {
    self.session = session
  }
  /// Return값 없는 API
  ///  - Parameter request:
  ///  - Returns: Void
  public func request(_ request: Requestable) async throws {
    let currentRequest = request
    var lastError: Error?
    
    for attempt in 0...currentRequest.retry {
      do {
        guard let url = URL(string: Self.baseURL + currentRequest.path),
              !Self.baseURL.isEmpty else {
          throw NetworkError.invalidURL
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = currentRequest.method.rawValue
        currentRequest.headers?.forEach { urlRequest.addValue($1, forHTTPHeaderField: $0) }
        
        if let parameters = currentRequest.parameters, currentRequest.method == .get {
          var components = URLComponents(url: url, resolvingAgainstBaseURL: false)!
          components.queryItems = parameters.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
          urlRequest.url = components.url
        } else if let parameters = currentRequest.parameters {
          urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: [])
          urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        } else if let body = currentRequest.body {
          urlRequest.httpBody = body
          urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        let (_, response) = try await session.data(for: urlRequest)
        log.log("Attempt \(attempt + 1)/\(currentRequest.retry + 1) for \(request.path)-\(request.parameters.map(\.description) ?? "")", category: .trace)
        
        guard let httpResponse = response as? HTTPURLResponse else {
          log.log("responseError for \(request.path)-\(request.parameters.map(\.description) ?? ""): invalid HTTP response", category: .network)
          throw NetworkError.invalidResponse
        }
        guard (200...299).contains(httpResponse.statusCode) else {
          log.log("responseError for \(request.path)-\(request.parameters.map(\.description) ?? ""): \(httpResponse.statusCode)", category: .network)
          throw NetworkError.responseError(statusCode: httpResponse.statusCode)
        }
        return
      } catch {
        lastError = error
        if attempt < currentRequest.retry {
          log.log("Retry \(attempt + 1) failed for \(currentRequest.path): \(error). Waiting \(currentRequest.delay) before retry.", category: .trace)
          try await Task.sleep(for: currentRequest.delay)
        } else {
          log.log("All retries exhausted for \(currentRequest.path): \(error).", category: .network)
          throw error
        }
      }
    }
    
    throw lastError ?? NetworkError.unknown
  }
  
  /// 리턴 값 있는 API
  /// - Parameter request:
  /// - Returns: Decodable
  public func request<T: Decodable>(_ request: Requestable) async throws -> T {
    let currentRequest = request
    var lastError: Error?
    
    for attempt in 0...currentRequest.retry {
      do {
        guard let url = URL(string: Self.baseURL + currentRequest.path),
              !Self.baseURL.isEmpty else {
          throw NetworkError.invalidURL
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = currentRequest.method.rawValue
        currentRequest.headers?.forEach { urlRequest.addValue($1, forHTTPHeaderField: $0) }
        
        if let parameters = currentRequest.parameters, currentRequest.method == .get {
          var components = URLComponents(url: url, resolvingAgainstBaseURL: false)!
          components.queryItems = parameters.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
          urlRequest.url = components.url
        } else if let parameters = currentRequest.parameters {
          urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: [])
          urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        } else if let body = currentRequest.body {
          urlRequest.httpBody = body
          urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        log.log("Attempt \(attempt + 1)/\(currentRequest.retry + 1) for \(request.path)-\(request.parameters.map(\.description) ?? "")", category: .trace)
        
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
      } catch {
        lastError = error
        if attempt < currentRequest.retry {
          log.log("Retry \(attempt + 1) failed for \(currentRequest.path): \(error). Waiting \(currentRequest.delay) before retry.", category: .trace)
          try await Task.sleep(for: currentRequest.delay)
        } else {
          log.log("All retries exhausted for \(currentRequest.path): \(error).", category: .network)
          throw error
        }
      }
    }
    
    
    //error
    throw lastError ?? NetworkError.unknown
  }
}
