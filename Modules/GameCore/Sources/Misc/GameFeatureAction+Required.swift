//
//  GameFeatureAction+Required.swift
//  WildWestOnline
//
//

/// Payload accessors for actions whose resolution guarantees the value is set
extension GameFeature.Action {
    var requiredTarget: String {
        guard let targetedPlayer else { fatalError("Missing targetedPlayer") }
        return targetedPlayer
    }

    var requiredCard: String {
        guard let targetedCard else { fatalError("Missing targetedCard") }
        return targetedCard
    }

    var requiredAmount: Int {
        guard let amount else { fatalError("Missing amount") }
        return amount
    }
}

extension GameFeature.State {
    /// Index of the pending damage caused by shooting the given player
    func shotDamageIndex(target: String?) -> Int {
        guard let index = queue.firstIndex(where: {
            $0.triggeredBy.first?.name == .shoot && $0.name == .damage && $0.targetedPlayer == target
        }) else {
            fatalError("Missing .shoot effect on targetedPlayer")
        }

        return index
    }
}
