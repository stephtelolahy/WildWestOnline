// The Swift Programming Language
// https://docs.swift.org/swift-book

public enum OldCards {
    static let all: [String: [Effect]] = [
        // MARK: - Default
        "default": [
            .discard_excessHand_onTurnEnded,
            .startTurn_next_onTurnEnded,
            .eliminate_onDamageLethal,
            .discard_all_onEliminated,
            .endTurn_onEliminated,
            .discard_previousWeapon_onWeaponPlayed
        ],
    ]
}
