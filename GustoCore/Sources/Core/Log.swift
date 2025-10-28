import Foundation
import OSLog
import Dependencies

public final class LogManager: Sendable {
  public enum LogCategory: String {
    case trace = "🔍"
    case info = "ℹ️"
    case warning = "⚠️"
    case error = "❌"
    
    func emoji() -> String {
      rawValue
    }
  }
  private let logger: Logger
  public init() {
    OSLog.initialize()
    let osLog = OSLog(subsystem: "\(Bundle.main.bundlePath)", category: "Log")
    logger = Logger(osLog)
  }
  public func log(_ str: String, category: LogCategory = .info) {
    switch category {
    case .trace:
      logger.debug("\(category.emoji()) \(str))")
    case .info:
      logger.info("\(category.emoji()) \(str)")
    case .warning:
      logger.warning("\(category.emoji()) \(str))")
    case .error:
      logger.error("\(category.emoji()) \(str))")
    }
  }
}

extension LogManager: DependencyKey {
  public static let liveValue: LogManager = {
    LogManager()
  }()
}

extension DependencyValues {
  public var log: LogManager {
    get {self[LogManager.self]}
    set {self[LogManager.self] = newValue}
  }
}
