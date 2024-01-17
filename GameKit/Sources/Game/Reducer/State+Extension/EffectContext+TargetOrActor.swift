//
//  EffectContext+TargetOrActor.swift
//
//
//  Created by Hugues Telolahy on 13/11/2023.
//

extension EffectContext {
    func targetOrActor() -> String {
        target ?? actor
    }

    func getTarget() -> String {
        guard let player = target else {
            fatalError("missing target")
        }
        return player
    }
}
