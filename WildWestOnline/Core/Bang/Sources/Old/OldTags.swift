// swiftlint:disable:this file_name
//  Tags.swift
//
//
//  Created by Stephano Hugues TELOLAHY on 02/08/2024.
//
// swiftlint:disable identifier_name no_magic_numbers

/// Defining Tags
/// ℹ️ Naming = {action}_{argValue}_on{Event}_if{Condition}
///
///

extension Effect {
    // MARK: - Collectible - Equipment

    static var discard_excessHand_onTurnEnded: Effect {
        .init(
            when: .played,
            action: .discard,
            selectors: [
                .repeat(.excessHand),
                .chooseCard()
            ]
        )
    }

    static var startTurn_next_onTurnEnded: Effect {
        .init(
            when: .turnEnded,
            action: .startTurn,
            selectors: [
                .target(.next)
            ]
        )
    }

    static var eliminate_onDamageLethal: Effect {
        .init(
            when: .damagedLethal,
            action: .eliminate
        )
    }

    static var discard_all_onEliminated: Effect {
        .init(
            when: .eliminated,
            action: .discard,
            selectors: [
                .card(.all)
            ]
        )
    }

    static var endTurn_onEliminated: Effect {
        .init(
            when: .eliminated,
            action: .endTurn,
            selectors: [
                .if(.actorTurn)
            ]
        )
    }

    static var discard_previousWeapon_onWeaponPlayed: Effect {
        .init(
            when: .cardPlayedWithAttr(.weapon),
            action: .discard,
            selectors: [
                .card(.inPlayWithAttr(.weapon))
            ]
        )
    }
}
