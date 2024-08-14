// The Swift Programming Language
// https://docs.swift.org/swift-book

// swiftlint:disable no_magic_numbers

public enum OldCards {
    static let all: [String: [Effect]] = [
        // MARK: - Default
        "default": [
            .startTurn_next_onTurnEnded,
            .eliminate_onDamageLethal,
            .discard_all_onEliminated,
            .endTurn_onEliminated,
            .discard_previousWeapon_onWeaponPlayed
        ],
        "kitCarlson": [
            // "during the phase 1 of his turn, he looks at the top three cards of the deck: he chooses 2 to draw, and puts the other one back on the top of the deck, face down."
            // ⚠️ override startTurn
            .setAttribute_startTurnCards_0,
            .reveal_3_onTurnStarted,
            .chooseCard_2_onTurnStarted,
            .setAttribute_maxHealth(4)
        ],
        "blackJack": [
            // "during the phase 1 of his turn, he must show the second card he draws: if it's Heart or Diamonds (just like a \"draw!\", he draws one additional card (without revealing it)."
            // ⚠️ override startTurn
            .showLastDraw_onTurnStarted,
            .drawDeck_onTurnStarted_IfDrawsRed,
            .setAttribute_maxHealth(4)
        ],
        "jesseJones": [
            // "during phase 1 of his turn, he may choose to draw the first card from the deck, or randomly from the hand of any other player. Then he draws the second card from the deck."
            // ⚠️ override startTurn
            .drawDiscard_onTurnStarted,
            .setAttribute_maxHealth(4)
        ],
        "pedroRamirez": [
            // "during the phase 1 of his turn, he may choose to draw the first card from the top of the discard pile or from the deck. Then, he draws the second card from the deck."
            // ⚠️ override startTurn
            .steal_any_fromHand_onTurnStarted,
            .setAttribute_maxHealth(4)
        ],

        // MARK: - Dodge city

        "patBrennan": [
            // "Instead of drawing normally, he may draw only one card in play in front of any one player."
            // ⚠️ override startTurn
            .steal_any_inPlay_onTurnStarted,
            .setAttribute_maxHealth(4)
        ],
        "veraCuster": [
            // For a whole round, she gains the same ability of another character in play of her choice until the beginning of her next turn
            // ⚠️ setup round abilities
        ],

        // MARK: - The Valley of Shadows
        "tucoFranziskaner": [
            // ⚠️ override startTurn
            // During his draw phase, he draw 2 extra cards if he has no blue cards in play.
            .drawDeck_2_onTurnStarted_ifHasNoBlueCardsInPlay
        ],

        "lemonadeJim": [
            // When another player plays BEER card, he may discard any card to refill 1 life point.
            .heal_onOtherPlayedBeer_cost1HandCard
        ],
        "henryBlock": [
            // Any another player who discards or draw from Henry hand or in front him, is target of BANG.
            .shoot_offender_onCardStolen,
            .shoot_offender_onCardDiscarded
        ],
        "blackFlower": [
            // Once per turn, she can shoot an extra Bang! by discarding a Clubs card.
            .shoot_reachable_oncePerTurn_costClubsHandCard
        ],
        "derSpotBurstRinger": [
            // Once per turn, he can play a Bang! card as Gatling.
            .shoot_others_oncePerTurn_costBangHandCard
        ],
        "escape": [
            // If you are target of card other than BANG! card, you may discard this card to avoid that card's effect.
            // ⚠️ Counter a card effect
        ],
        "Ghost": [
            // Play in front any eliminated player. He return to game without his ability and possibilty to grain or lose any life point. He play as normal player.
            // ⚠️ player without health
        ]
    ]
}
