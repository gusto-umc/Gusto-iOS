import Foundation
import OSLog
import ComposableArchitecture

final class LogManager: Sendable {
  enum LogCategory: String {
    case trace = "🔍"
    case info = "ℹ️"
    case warning = "⚠️"
    case error = "❌"
    case cache = "💻"
    case network = "🌐"
    
    func emoji() -> String {
      rawValue
    }
  }
  private let logger: Logger
  init() {
    OSLog.initialize()
    let osLog = OSLog(subsystem: "\(Bundle.main.bundlePath)", category: "Log")
    logger = Logger(osLog)
  }
  func log(_ str: String, category: LogCategory = .info) {
    Task {
      switch category {
      case .trace:
        logger.debug("\(category.emoji()) \(str))")
      case .info:
        logger.info("\(category.emoji()) \(str)")
      case .warning:
        logger.warning("\(category.emoji()) \(str))")
      case .error:
        logger.error("\(category.emoji()) \(str))")
      case .cache:
        logger.info("\(category.emoji()) \(str))")
      case .network:
        logger.info("\(category.emoji()) \(str))")
      }
    }
  }
}

extension LogManager: DependencyKey {
  static let liveValue: LogManager = {
    LogManager()
  }()
}

extension DependencyValues {
  var log: LogManager {
    get {self[LogManager.self]}
    set {self[LogManager.self] = newValue}
  }
}
