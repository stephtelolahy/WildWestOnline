//
//  LogStore.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 28/02/2026.
//

import Foundation
import SwiftUI
import Combine

@MainActor
final class LogStore: ObservableObject {
    
    static let shared = LogStore()
    
    @Published private(set) var logs: [LogEntry] = []
    
    private init() {}
    
    func log(_ message: String, level: LogLevel = .info) {
        let entry = LogEntry(date: Date(), level: level, message: message)
        logs.append(entry)
        print(message)
    }
    
    func clear() {
        logs.removeAll()
    }
}

enum LogLevel: String, CaseIterable, Identifiable {
    case debug = "DEBUG"
    case info = "INFO"
    case warning = "WARNING"
    case error = "ERROR"

    var id: String { rawValue }

    var color: Color {
        switch self {
        case .debug: return .gray
        case .info: return .primary
        case .warning: return .orange
        case .error: return .red
        }
    }
}

struct LogEntry: Identifiable {
    let id = UUID()
    let date: Date
    let level: LogLevel
    let message: String

    var formattedTimestamp: String {
        Self.dateFormatter.string(from: date)
    }

    private static let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "HH:mm:ss.SSS"
        return df
    }()
}
