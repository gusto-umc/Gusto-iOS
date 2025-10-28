import Foundation
import GustoCore

public protocol NetworkProtocol { }

extension NetworkProtocol {
  internal var baseURL: String {
    guard let url = Bundle.main.object(forInfoDictionaryKey: "BASE_URL") as? String else {
      LogManager().log("cannot find base url", category: .error)
      return ""
    }
    return url
  }
  
  internal func makeRequest(url: URL, with request: Requestable) throws -> URLRequest {
    var urlRequest = URLRequest(url: url)
    urlRequest.httpMethod = request.method.rawValue
    request.headers?.forEach { urlRequest.addValue($1, forHTTPHeaderField: $0) }
    
    if let parameters = request.parameters, request.method == .get {
      guard var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
        LogManager().log("initializing URLComponents was failed", category: .error)
        throw NetworkError.invalidURL
      }
      components.queryItems = parameters.map{ URLQueryItem(name: $0.key, value: "\($0.value)") }
      urlRequest.url = components.url
      return urlRequest
    } else if let parameters = request.parameters {
      do {
        urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters)
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        return urlRequest
      } catch let error {
        LogManager().log("Coding HTTP Body was failed")
        throw NetworkError.decodingFailed(error)
      }
    } else if let body = request.body {
      urlRequest.httpBody = body
      urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
      return urlRequest
    } else {
      LogManager().log("unknown request matching error", category: .error)
      throw NetworkError.unknown
    }
  }
}
