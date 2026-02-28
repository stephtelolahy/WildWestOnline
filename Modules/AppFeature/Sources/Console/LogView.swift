//
//  LogView.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 28/02/2026.
//

import SwiftUI

struct LogView: View {
    
    @ObservedObject var store: LogStore = .shared
    
    @State private var selectedLevels: Set<LogLevel> = Set(LogLevel.allCases)
    
    var filteredLogs: [LogEntry] {
        store.logs.filter { selectedLevels.contains($0.level) }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            
            // Toolbar
            HStack {
                ForEach(LogLevel.allCases) { level in
                    Button(action: {
                        toggle(level)
                    }) {
                        Text(level.rawValue)
                            .font(.caption)
                            .padding(6)
                            .background(selectedLevels.contains(level) ? level.color.opacity(0.2) : Color.clear)
                            .cornerRadius(6)
                    }
                }
                
                Spacer()
                
                Button("Clear") {
                    store.clear()
                }
                .font(.caption)
            }
            .padding(8)
            .background(Color(.systemGray6))
            
            Divider()
            
            // Console
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 4) {
                        ForEach(filteredLogs) { log in
                            HStack(alignment: .top, spacing: 6) {
                                Text(log.formattedTimestamp)
                                    .foregroundColor(.secondary)
                                
                                Text("[\(log.level.rawValue)]")
                                    .foregroundColor(log.level.color)
                                
                                Text(log.message)
                                    .foregroundColor(log.level.color)
                                    .textSelection(.enabled)
                                
                                Spacer()
                            }
                            .font(.system(size: 12, weight: .regular, design: .monospaced))
                            .id(log.id)
                        }
                    }
                    .padding(8)
                }
                .background(Color.black.opacity(0.95))
                .onChange(of: filteredLogs.count) { _ in
                    if let last = filteredLogs.last {
                        withAnimation(.easeOut(duration: 0.2)) {
                            proxy.scrollTo(last.id, anchor: .bottom)
                        }
                    }
                }
            }
        }
    }
    
    private func toggle(_ level: LogLevel) {
        if selectedLevels.contains(level) {
            selectedLevels.remove(level)
        } else {
            selectedLevels.insert(level)
        }
    }
}
