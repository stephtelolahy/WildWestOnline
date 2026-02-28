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

    @Environment(\.dismiss) private var dismiss

    var filteredLogs: [LogEntry] {
        store.logs.filter { selectedLevels.contains($0.level) }
    }

    var body: some View {
        NavigationStack {
            ScrollViewReader { proxy in
                logsList(proxy: proxy)
            }
            .navigationTitle("Logs")
#if os(iOS) || os(tvOS) || os(visionOS)
            .navigationBarTitleDisplayMode(.inline)
#endif
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    filterMenu()

                    Button(role: .destructive) {
                        store.clear()
                    } label: {
                        Image(systemName: "xmark.bin")
                    }
                }
            }
        }
    }

    private func scrollToLast(_ proxy: ScrollViewProxy) {
        if let last = filteredLogs.last {
            withAnimation(.easeOut(duration: 0.2)) {
                proxy.scrollTo(last.id, anchor: .bottom)
            }
        }
    }

    @ViewBuilder
    private func filterMenu() -> some View {
        Menu {
            ForEach(LogLevel.allCases) { level in
                Button {
                    toggle(level)
                } label: {
                    Label(
                        level.rawValue,
                        systemImage: selectedLevels.contains(level)
                        ? "checkmark.circle.fill"
                        : "circle"
                    )
                }
            }
        } label: {
            Label("Filter", systemImage: "slider.horizontal.3")
        }
    }

    @ViewBuilder
    private func logsList(proxy: ScrollViewProxy) -> some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 4) {
                ForEach(filteredLogs) { log in
                    LogRow(log: log)
                        .id(log.id)
                }
            }
            .padding(8)
        }
        .onChange(of: filteredLogs.count) { _ in
            scrollToLast(proxy)
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

private struct LogRow: View {
    let log: LogEntry

    var body: some View {
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
    }
}

#Preview {
    LogView()
}
