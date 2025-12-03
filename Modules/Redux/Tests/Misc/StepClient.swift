//
//  StepClient.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 03/12/2025.
//
import Redux

struct StepClient {
    var step: () -> Int
}

extension Dependencies {
    var stepClient: StepClient {
        get { self[StepClientKey.self] }
        set { self[StepClientKey.self] = newValue }
    }
}

private struct StepClientKey: DependencyKey {
    nonisolated(unsafe) static let defaultValue: StepClient = .noop
}

private extension StepClient {
    static var noop: Self {
        .init(
            step: { 0 }
        )
    }
}
