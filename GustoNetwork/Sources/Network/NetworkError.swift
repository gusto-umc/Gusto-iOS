public enum NetworkError: Error {
  case invalidURL
  case requestFailed(Error)
  case invalidResponse
  case responseError(statusCode: Int)
  case noData
  case decodingFailed(Error)
  case unknown
}
