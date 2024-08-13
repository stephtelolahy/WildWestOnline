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
            .discard_previousWeapon_onWeaponPlayed,
            .play_missed_onShot,
            .play_beer_onDamagedLethal
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
        "apacheKid": [
            // "Cards of Diamond played by other players do not affect him"
            .setAttribute_silentCardsDiamonds,
            .setAttribute_maxHealth(3)
        ],
        "belleStar": [
            // "During her turn, cards in play in front of other players have no effect. "
            .setAttribute_silentCardsInPlayDuringTurn,
            .setAttribute_maxHealth(4)
        ],
        "veraCuster": [
            // For a whole round, she gains the same ability of another character in play of her choice until the beginning of her next turn
            // ⚠️ setup round abilities
        ],

        // MARK: - The Valley of Shadows

        "lastCall": [
            // Refill 1 life point even in game last 2 players.
            .brown,
            .heal
        ],
        "tornado": [
            // Each player discards a card from their hand (if possible), then draw 2 cards from the deck
            .brown,
            .drawDeck_all_2_cost1HandCard
        ],
        "backfire": [
            // Count as MISSED!. Player who shot you, is now target of BANG!.
            .brown,
            .init(
                when: .played,
                action: .missed
            ),
            .shoot_reachable
        ],
        "tomahawk": [
            // Bang at distance 2.
            .brown,
            .shoot_atDistanceOf2
        ],
        "aim": [
            // Play with Bang card. If defending player doesn't miss, he loses 2 life points instead
            .brown,
            .play_onBangPlayed,
            .setAttribute_bangDamage_2
        ],
        "faning": [
            // Count as your normal bang per turn. You hit addional player at distance 1 from 1st target(except you).
            .brown,
            .shoot_reachable_bangLimitPerTurn,
            .shoot_neighbour
        ],
        "saved": [
            // Play out your turn. By discarding prevent any player to lose 1 life. In case of save from death, you draw 2 card form hand of saved player or from deck (your choice).
            .brown,
            .play_onOtherDamaged,
            .heal_lastDamaged
        ],
        "bandidos": [
            // Others players may discard 2 cards from hand (1 if he only has one) or loose one life point.
            .brown,
            .damage_others_counterWith2HandCards
        ],
        "poker": [
            // All others players discard a card. If no one discards an Ace card, you can draw 2 cards from the discarded cards.
            .brown,
            .discard_others,
            .drawDiscard_2_ifDiscardedCardsNotAce
        ],
        "lemat": [
            // gun, range 1: In your turn, you may use any card like BANG card.
            .equip,
            .setAttribute_weapon(1),
            .setAttribute_playBangWithAny
        ],
        "shootgun": [
            // gun, range 1: If any player is hit by BANG! card by player with SHOTGUN, that player discard 1 card from hand at his choice.
            .equip,
            .setAttribute_weapon(1),
            .discard_anyHand_onDamagingWithBang
        ],
        "bounty": [
            // Play in front any player. Player who succesfully hit player with BOUNTY with BANG! card, he draw a card.
            .handicap,
            .drawDeck_offender_onDamagedWithBang
        ],
        "rattlesnake": [
            // Play in front any player. At beginnings of that player's turn, he draw: On Spade, he lose 1 life point, otherwise he does nothing.
            .handicap,
            .draw_onTurnStarted,
            .damage_onTurnStarted_ifDrawSpades
        ],
        "tucoFranziskaner": [
            // During his draw phase, he draw 2 extra cards if he has no blue cards in play.
            .drawDeck_2_onTurnStarted_ifHasNoBlueCardsInPlay
        ],
        "coloradoBill": [
            // Eachtime any player play MISSED! against BANG! card from Colorado: Colorado draw: on Spades, MISSED! is ignored and that player lose 1 life points.
            .draw_onMissedBang,
            .damage_target_onMissedBang_ifDrawSpades
        ],
        "evelynShebang": [
            // She may decide not to draw some number of cards in her draw phase. For each card skipped, she shoots a Bang! at a different target in reachable distance.
            // ⚠️ Ask choice
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
