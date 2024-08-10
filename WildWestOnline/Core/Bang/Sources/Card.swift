// The Swift Programming Language
// https://docs.swift.org/swift-book

/// We are working on a Card Definition Language that will allow people to create new cards,
/// not currently in the game and see how they play.
/// A `card` is just a collection of effects using `Tag system`
///
typealias Card = [CardEffect]

public enum Cards {
    static let all: [String: Card] = [
        // MARK: - Default

        "done": [
            .endTurn,
            .discard_excessHand
        ],
        "default": [
            .setAttribute_weapon_1,
            .setAttribute_startTurnCards_2,
            .setAttribute_bangRequiredMisses_1,
            .setAttribute_bangLimitPerTurn_1,
            .setAttribute_drawCards_1,
            .drawDeck_remainingStartTurnCards_onTurnStarted,
            .startTurn_next_onTurnEnded,
            .eliminate_onDamageLethal,
            .discard_all_onEliminated,
            .endTurn_onEliminated,
            .discard_previousWeapon_onWeaponPlayed,
            .play_missed_onShot,
            .play_beer_onDamagedLethal
        ],

        // MARK: - Bang

        "beer": [
            // "regain one life point. Beer has no effect if there are only 2 players left in the game."
            .brown,
            .heal_ifPlayersAtLeast3
        ],
        "saloon": [
            // "all players in play regain one life point."
            .brown,
            .heal_all
        ],
        "stagecoach": [
            // "Draw two cards from the top of the deck."
            .brown,
            .drawDeck_2
        ],
        "wellsFargo": [
            // "Draw three cards from the top of the deck."
            .brown,
            .drawDeck_3
        ],
        "catBalou": [
            // "Force “any one player” to “discard a card”, regardless of the distance."
            .brown,
            .discard_any
        ],
        "panic": [
            // "Draw a card from a player at distance 1"
            .brown,
            .steal_any_atDistanceOf1
        ],
        "bang": [
            // "reduce other players’s life points"
            .brown,
            .shoot_any_reachable
        ],
        "missed": [
            // "If you are hit by a BANG! you may immediately play a Missed! - even though it is not your turn! - to cancel the shot."
            .brown,
            .missed
        ],
        "gatling": [
            // "shoots to all the other players, regardless of the distance"
            .brown,
            .shoot_others
        ],
        "indians": [
            // "Each player, excluding the one who played this card, may discard a BANG! card, or lose one life point."
            .brown,
            .damage_others_counterWithBang
        ],
        "duel": [
            // "can challenge any other player. The first player failing to discard a BANG! card loses one life point."
            .brown,
            .damage_any_reverseWithBang
        ],
        "generalStore": [
            // "When you play this card, turn as many cards from the deck face up as the players still playing. Starting with you and proceeding clockwise, each player chooses one of those cards and puts it in his hands."
            .brown,
            .reveal_activePlayers,
            .chooseCard_all
        ],
        "barrel": [
            // "allows you to “draw!” when you are the target of a BANG!: - if you draw a Heart card, you are Missed! (just like if you played a Missed! card); - otherwise nothing happens."
            .equip,
            .draw_onShot,
            .missed_onShot_ifDrawHearts
        ],
        "dynamite": [
            // "Play this card in front of you: the Dynamite will stay there for a whole turn. When you start your next turn (you have the Dynamite already in play), before the first phase you must “draw!”: - if you draw a card showing Spades and a number between 2 and 9, the Dynamite explodes! Discard it and lose 3 life points; - otherwise, pass the Dynamite to the player on your left (who will “draw!” on his turn, etc.).",
            .equip,
            .draw_onTurnStarted,
            .pass_next_onTurnStarted_ifNotDrawSpades,
            .damage_3_onTurnStarted_ifDrawSpades,
            .discard_onTurnStarted_ifDrawSpades
        ],
        "schofield": [
            // "can hit targets at a distance of 2."
            .equip,
            .setAttribute_weapon_2
        ],
        "remington": [
            // "can hit targets at a distance of 3."
            .equip,
            .setAttribute_weapon_3
        ],
        "revCarabine": [
            // "can hit targets at a distance of 4."
            .equip,
            .setAttribute_weapon_4
        ],
        "winchester": [
            // "can hit targets at a distance of 5."
            .equip,
            .setAttribute_weapon_5
        ],
        "volcanic": [
            // "can play any number of BANG! cards during your turn but limited to a distance of 1"
            .equip,
            .setAttribute_weapon_1,
            .setAttribute_bangLimitPerTurn_0
        ],
        "scope": [
            // "you see all the other players at a distance decreased by 1"
            .equip,
            .incrementAttribute_magnifying
        ],
        "mustang": [
            // "the distance between other players and you is increased by 1"
            .equip,
            .incrementAttribute_remoteness
        ],
        "jail": [
            // "Play this card in front of any player regardless of the distance: you put him in jail! If you are in jail, you must “draw!” before the beginning of your turn: - if you draw a Heart card, you escape from jail: discard the Jail, and continue your turn as normal; - otherwise discard the Jail and skip your turn"
            .handicap,
            .draw_onTurnStarted,
            .endTurn_onTurnStarted_ifNotDrawHearts,
            .discard_onTurnStarted
        ],
        "willyTheKid": [
            // "he can play any number of BANG! cards during his turn."
            .setAttribute_bangLimitPerTurn_0,
            .setAttribute_maxHealth_4
        ],
        "roseDoolan": [
            // "she is considered to have an Appaloosa card in play at all times; she sees the other players at a distance decreased by 1."
            .incrementAttribute_magnifying,
            .setAttribute_maxHealth_4
        ],
        "paulRegret": [
            // "he is considered to have a Mustang card in play at all times; all other players must add 1 to the distance to him."
            .incrementAttribute_remoteness,
            .setAttribute_maxHealth_3
        ],
        "jourdonnais": [
            // "he is considered to have a Barrel card in play at all times; he can \"draw!\" when he is the target of a BANG!, and on a Heart he is missed. If he has another real Barrel card in play, he can count both of them, giving him two chances to cancel the BANG! before playing a Missed! card."
            .draw_onShot,
            .missed_onShot_ifDrawHearts,
            .setAttribute_maxHealth_4
        ],
        "bartCassidy": [
            // "each time he loses a life point, he immediately draws a card from the deck."
            .drawDeck_onDamaged,
            .setAttribute_maxHealth_4
        ],
        "elGringo": [
            // "each time he loses a life point due to a card played by another player, he draws a random card from the hands of that player (one card for each life point). If that player has no more cards, too bad! Note that Dynamite damages are not caused by any player."
            .steal_offender_onDamaged,
            .setAttribute_maxHealth_3
        ],
        "suzyLafayette": [
            // "as soon as she has no cards in her hand, she draws a card from the draw pile."
            .drawDeck_onHandEmpty,
            .setAttribute_maxHealth_4
        ],
        "sidKetchum": [
            // "at any time, he may discard 2 cards from his hand to regain one life point. If he is willing and able, he can use this ability more than once at a time. But remember: you cannot have more life points than your starting amount!"
            .heal_cost2HandCards,
            .setAttribute_maxHealth_4
        ],
        "vultureSam": [
            // "whenever a character is eliminated from the game, Sam takes all the cards that player had in his hand and in play, and adds them to his hand."
            .steal_all_onOtherEliminated,
            .setAttribute_maxHealth_4
        ],
        "slabTheKiller": [
            // "players trying to cancel his BANG! cards need to play 2 Missed! cards. The Barrel effect, if successfully used, only counts as one Missed!."
            .setAttribute_bangRequiredMisses_2,
            .setAttribute_maxHealth_4
        ],
        "luckyDuke": [
            // "each time he is required to \"draw!\", he flips the top two cards from the deck, and chooses the result he prefers. Discard both cards afterwards."
            .setAttribute_maxHealth_4,
            .setAttribute_drawCards_2
        ],
        "calamityJanet": [
            // "she can use BANG! cards as Missed! cards and vice versa. If she plays a Missed! card as a BANG!, she cannot play another BANG! card that turn (unless she has a Volcanic in play)."
            .setAttribute_bangWithMissed,
            .setAttribute_missedWithBang,
            .setAttribute_maxHealth_4
        ],
        "kitCarlson": [
            // "during the phase 1 of his turn, he looks at the top three cards of the deck: he chooses 2 to draw, and puts the other one back on the top of the deck, face down."
            // ⚠️ override startTurn
            .reveal_startTurnCardsPlus1,
            .chooseCard_startTurnCards,
            .setAttribute_maxHealth_4
        ],
        "blackJack": [
            // "during the phase 1 of his turn, he must show the second card he draws: if it's Heart or Diamonds (just like a \"draw!\", he draws one additional card (without revealing it)."
            // ⚠️ override startTurn
            .showLastDraw_onTurnStarted,
            .drawDeck_onTurnStarted_IfDrawsRed,
            .setAttribute_maxHealth_4
        ],
        "jesseJones": [
            // "during phase 1 of his turn, he may choose to draw the first card from the deck, or randomly from the hand of any other player. Then he draws the second card from the deck."
            .drawDiscard_onTurnStarted,
            .setAttribute_maxHealth_4
        ],
        "pedroRamirez": [
            // "during the phase 1 of his turn, he may choose to draw the first card from the top of the discard pile or from the deck. Then, he draws the second card from the deck."
            // ⚠️ override startTurn
            .steal_any_fromHand_onTurnStarted,
            .setAttribute_maxHealth_4
        ],

        // MARK: - Dodge city

        "punch": [
            // "Acts as a Bang! with a range of one."
            .brown,
            .shoot_atDistanceOf1
        ],
        "dodge": [
            // "Acts as a Missed!, but allows the player to draw a card."
            .brown,
            .missed,
            .drawDeck
        ],
        "springfield": [
            // "The player must discard one additional card, and then the card acts as a Bang! with unlimited range."
            .brown,
            .shoot_any_cost1HandCard
        ],
        "hideout": [
            // "Others view you at distance +1"
            .equip,
            .incrementAttribute_remoteness
        ],
        "binocular": [
            // "you view others at distance -1"
            .equip,
            .incrementAttribute_magnifying
        ],
        "whisky": [
            // "The player must discard one additional card, to heal two health."
            .brown,
            .heal_2_cost1HandCard
        ],
        "tequila": [
            // "The player must discard one additional card, to heal any player one health."
            .brown,
            .heal_any_cost1HandCard
        ],
        "ragTime": [
            // "The player must discard one additional card to steal a card from any other player."
            .brown,
            .steal_any_cost1HandCard
        ],
        "brawl": [
            // "The player must discard one additional card to cause all other players to discard one card."
            .brown,
            .discard_all_cost1HandCard
        ],
        "elenaFuente": [
            // "She may use any card in hand as Missed!."
            .setAttribute_missedWithAny,
            .setAttribute_maxHealth_3
        ],
        "seanMallory": [
            // "He may hold in his hand up to 10 cards."
            .setAttribute_handLimit_10,
            .setAttribute_maxHealth_3
        ],
        "tequilaJoe": [
            // "Each time he plays a Beer, he regains 2 life points instead of 1."
            .heal_onBeerPlayed,
            .setAttribute_maxHealth_4
        ],
        "pixiePete": [
            // "During phase 1 of his turn, he draws 3 cards instead of 2."
            .setAttribute_startTurnCards_3,
            .setAttribute_maxHealth_3
        ],
        "billNoface": [
            // "He draws 1 card, plus 1 card for each wound he has."
            .setAttribute_startTurnCards_1,
            .drawDeck_damage_onTurnStarted,
            .setAttribute_maxHealth_4
        ],
        "gregDigger": [
            // "Each time another player is eliminated, he regains 2 life points."
            .heal_2_onOtherEliminated,
            .setAttribute_maxHealth_4
        ],
        "herbHunter": [
            // "Each time another player is eliminated, he draws 2 extra cards."
            .drawDeck_2_onOtherEliminated,
            .setAttribute_maxHealth_4
        ],
        "mollyStark": [
            // "Each time she uses a card from her hand out of turn, she draw a card."
            .drawDeck_onPlayedCardOutOfTurn,
            .setAttribute_maxHealth_4
        ],
        "joseDelgado": [
            // "Twice in his turn, he may discard a blue card from the hand to draw 2 cards."
            .drawDeck_2_costBlueHandCard,
            .setAttribute_maxHealth_4
        ],
        "chuckWengam": [
            // "During his turn, he may choose to lose 1 life point to draw 2 cards. However, the last life point cannot be lost."
            .drawDeck_2_cost1LifePoint,
            .setAttribute_maxHealth_4
        ],
        "docHolyday": [
            // "Once during his turn, he may discard 2 cards from the hand to shoot a Bang!."
            .shoot_any_reachable_cost2HandCards,
            .setAttribute_maxHealth_4
        ],
        "patBrennan": [
            // "Instead of drawing normally, he may draw only one card in play in front of any one player."
            // ⚠️ override startTurn
            .steal_any_inPlay_onTurnStarted,
            .setAttribute_maxHealth_4
        ],
        "apacheKid": [
            // "Cards of Diamond played by other players do not affect him"
            .setAttribute_silentCardsDiamonds,
            .setAttribute_maxHealth_3
        ],
        "belleStar": [
            // "During her turn, cards in play in front of other players have no effect. "
            .setAttribute_silentCardsInPlayDuringTurn,
            .setAttribute_maxHealth_4
        ]
    ]
}
