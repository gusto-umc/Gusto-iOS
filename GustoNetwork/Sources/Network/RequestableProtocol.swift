import Foundation

public protocol Requestable {
  var path: String { get }
  var method: HTTPMethod { get }
  var headers: [String: String]? { get }
  var parameters: [String: Any]? { get }
  var body: Data? { get }
}

extension Requestable {
  private var baseURL: String {
    guard let url = Bundle.main.object(forInfoDictionaryKey: "BASE_URL") as? String else {
      fatalError("BASE_URL is not set in Info.plist")
    }
    return url
  }
  
  public func makeRequest() throws(NetworkError) -> URLRequest {
    guard let url = URL(string: baseURL + self.path) else {
      throw NetworkError.invalidURL
    }
    var urlRequest = URLRequest(url: URL(string: baseURL + self.path)!)
    urlRequest.httpMethod = self.method.rawValue
    self.headers?.forEach { urlRequest.addValue($1, forHTTPHeaderField: $0) }
    
    if let parameters = self.parameters, self.method == .get {
      guard var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
        throw NetworkError.invalidURL
      }
      components.queryItems = parameters.map{ URLQueryItem(name: $0.key, value: "\($0.value)") }
      urlRequest.url = components.url
      return urlRequest
    } else if let parameters = self.parameters {
      do {
        urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters)
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        return urlRequest
      } catch let error {
        throw NetworkError.decodingFailed(error)
      }
    } else if let body = self.body {
      urlRequest.httpBody = body
      urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
      return urlRequest
    } else {
      return urlRequest
    }
  }
}
