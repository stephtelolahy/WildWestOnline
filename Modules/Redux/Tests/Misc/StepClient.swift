//
//  StepClient.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 03/12/2025.
//
import Redux

struct StepClient: Sendable {
    var step: @Sendable () -> Int
}

extension Dependencies {
    var stepClient: StepClient {
        get { self[StepClientKey.self] }
        set { self[StepClientKey.self] = newValue }
    }
}

private struct StepClientKey: DependencyKey {
    static let defaultValue: StepClient = .noop
}

private extension StepClient {
    static let noop: Self = .init(
        step: { 0 }
    )
}
