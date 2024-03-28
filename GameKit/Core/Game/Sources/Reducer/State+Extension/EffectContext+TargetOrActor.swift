//
//  EffectContext+TargetOrActor.swift
//
//
//  Created by Hugues Telolahy on 13/11/2023.
//

extension EffectContext {
    func targetOrActor() -> String {
        resolvingTarget ?? sourceActor
    }

    func getTarget() -> String {
        guard let player = resolvingTarget else {
            fatalError("missing target")
        }
        return player
    }
}
