//
//  ReducerCompositionTests.swift
//
//  Created by Hugues Stéphano TELOLAHY on 12/10/2025.
//

import Testing
import Redux

struct ReducerCompositionTests {
    @Test func testCombineReducersRunsBoth() {
        var state = GlobalFeature.State(
            counter: CounterFeature.State(count: 5),
            flag: FlagFeature.State(isOn: false)
        )

        var dependencies = Dependencies()
        dependencies.stepClient = .init(step: { 2 })

        // Dispatch global counter action
        let effect1 = GlobalFeature.reducer(&state, .counter(.increment), dependencies)
        #expect(state.counter.count == 7)
        #expect(state.flag.isOn == false)
        #expect(effect1.isGroup())

        // Dispatch global flag action
        let effect2 = GlobalFeature.reducer(&state, .flag(.toggle), dependencies)
        #expect(state.flag.isOn == true)
        #expect(state.counter.count == 7)
        #expect(effect2.isGroup())
    }

    @Test func testPullbackHandlesOnlyMatchingAction() {
        var state = GlobalFeature.State(counter: .init(), flag: .init())
        var dependencies = Dependencies()
        dependencies.stepClient = .init(step: { 1 })

        // Should handle only .counter actions
        let effect1 = GlobalFeature.reducer(&state, .counter(.increment), dependencies)
        #expect(state.counter.count == 1)

        // .flag action should not affect counter
        let effect2 = GlobalFeature.reducer(&state, .flag(.toggle), dependencies)
        #expect(state.counter.count == 1)
        #expect(state.flag.isOn == true)

        #expect(effect1.isGroup())
        #expect(effect2.isGroup())
    }

    @Test func testAsyncEffectRunsCorrectly() async {
        var state = GlobalFeature.State(counter: .init(), flag: .init())
        var dependencies = Dependencies()
        dependencies.stepClient = .init(step: { 1 })

        let effect = GlobalFeature.reducer(&state, .counter(.asyncIncrement), dependencies)

        // Extract async effect and run it manually
        guard case let .group(effects) = effect,
              case let .run(asyncWork) = effects.first
        else {
            Issue.record("Expected async run effect")
            return
        }

        let nextAction = await asyncWork()
        #expect(nextAction == .counter(.incremented(1)))

        // Apply returned action manually to simulate dispatch
        _ = GlobalFeature.reducer(&state, nextAction!, dependencies)
        #expect(state.counter.count == 1)
    }
}

private extension Effect where Action == GlobalFeature.Action {
    func isGroup() -> Bool {
        guard case .group = self else {
            return false
        }
        return true
    }
}
