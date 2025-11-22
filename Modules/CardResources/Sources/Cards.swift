//
//  Cards.swift
//
//  Created by Hugues Telolahy on 28/10/2024.
//
// swiftlint:disable file_length line_length
import GameFeature

/// BANG! THE BULLET
/// https://bang.dvgiochi.com/cardslist.php?id=2#q_result
public enum Cards {
    public static let all: [Card] = [
        .endTurn,
        .discardMissedOnShot,
        .discardBeerOnDamagedLethal,
        .discardExcessHandOnTurnEnded,
        .draw2CardsOnTurnStarted,
        .nextTurnOnTurnEnded,
        .eliminateOnDamageLethal,
        .endGameOnEliminated,
        .discardAllCardsOnEliminated,
        .nextTurnOnEliminated,
        .draw3CardsOnEliminating,
        .discardEquipedWeaponOnPrePlayed,
        .stagecoach,
        .wellsFargo,
        .beer,
        .saloon,
        .catBalou,
        .panic,
        .generalStore,
        .bang,
        .missed,
        .gatling,
        .indians,
        .duel,
        .schofield,
        .remington,
        .revCarabine,
        .winchester,
        .volcanic,
        .scope,
        .mustang,
        .barrel,
        .dynamite,
        .jail,
        .willyTheKid,
        .roseDoolan,
        .paulRegret,
        .bartCassidy,
        .elGringo,
        .suzyLafayette,
        .jourdonnais,
        .sidKetchum,
        .vultureSam,
        .luckyDuke,
        .blackJack,
        .pedroRamirez,
        .jesseJones,
        .kitCarlson,
        .slabTheKiller,
        .calamityJanet,
    ]
}

private extension Card {
    static var endTurn: Self {
        .init(
            name: .endTurn,
            type: .ability,
            description: "End turn",
            effects: [
                .init(
                    trigger: .cardPrePlayed,
                    action: .endTurn
                )
            ]
        )
    }

    static var discardMissedOnShot: Self {
        .init(
            name: .discardMissedOnShot,
            type: .ability,
            description: "Discard counter card on shot",
            effects: [
                .init(
                    trigger: .shot,
                    action: .counterShot,
                    selectors: [
                        .repeat(.contextMissedPerShoot),
                        .chooseOne(.costCard([.canCounterShot]))
                    ]
                )
            ]
        )
    }

    static var discardBeerOnDamagedLethal: Self {
        .init(
            name: .discardBeerOnDamagedLethal,
            type: .ability,
            description: "When you lose your last life point, you are eliminated and your game is over, unless you immediately play a Beer",
            effects: [
                .init(
                    trigger: .damagedLethal,
                    action: .heal,
                    amount: 1,
                    selectors: [
                        .applyIf(.minimumPlayers(3)),
                        .chooseOne(.costCard([.named(.beer)]))
                    ]
                )
            ]
        )
    }

    static var discardExcessHandOnTurnEnded: Self {
        .init(
            name: .discardExcessHandOnTurnEnded,
            type: .ability,
            description: "Once you do not want to or cannot play any more cards, then you must discard from your hand any cards exceeding your hand-size limit",
            effects: [
                .init(
                    trigger: .turnEnded,
                    action: .discardHand,
                    selectors: [
                        .repeat(.playerExcessHandSize),
                        .chooseOne(.targetCard([.isFromHand]))
                    ]
                )
            ]
        )
    }

    static var nextTurnOnTurnEnded: Self {
        .init(
            name: .nextTurnOnTurnEnded,
            type: .ability,
            description: "Start next player's turn",
            effects: [
                .init(
                    trigger: .turnEnded,
                    action: .startTurn,
                    selectors: [
                        .setTarget(.nextPlayer)
                    ]
                )
            ]
        )
    }

    static var draw2CardsOnTurnStarted: Self {
        .init(
            name: .draw2CardsOnTurnStarted,
            type: .ability,
            description: "Draw two cards at the beginning of your turn",
            effects: [
                .init(
                    trigger: .turnStarted,
                    action: .addContextCardsPerTurn,
                    amount: 2
                ),
                .init(
                    trigger: .turnStarted,
                    action: .drawDeck,
                    selectors: [
                        .repeat(.contextCardsPerTurn)
                    ]
                )
            ]
        )
    }

    static var eliminateOnDamageLethal: Self {
        .init(
            name: .eliminateOnDamagedLethal,
            type: .ability,
            description: "When you lose your last life point, you are eliminated and your game is over",
            effects: [
                .init(
                    trigger: .damagedLethal,
                    action: .eliminate,
                    selectors: [
                        .require(.isHealthZero)
                    ]
                )
            ]
        )
    }

    static var endGameOnEliminated: Self {
        .init(
            name: .endGameOnEliminated,
            type: .ability,
            description: "End game when last player is eliminated",
            effects: [
                .init(
                    trigger: .eliminated,
                    action: .endGame,
                    selectors: [
                        .applyIf(.isGameOver)
                    ]
                )
            ]
        )
    }

    static var discardAllCardsOnEliminated: Self {
        .init(
            name: .discardAllCardsOnEliminated,
            type: .ability,
            description: "Discard all cards when eliminated",
            effects: [
                .init(
                    trigger: .eliminated,
                    action: .discardInPlay,
                    selectors: [
                        .setCard(.allInPlay)
                    ]
                ),
                .init(
                    trigger: .eliminated,
                    action: .discardHand,
                    selectors: [
                        .setCard(.allInHand)
                    ]
                )
            ]
        )
    }

    static var nextTurnOnEliminated: Self {
        .init(
            name: .nextTurnOnEliminated,
            type: .ability,
            description: "End turn when eliminated",
            effects: [
                .init(
                    trigger: .eliminated,
                    action: .startTurn,
                    selectors: [
                        .applyIf(.isCurrentTurn),
                        .setTarget(.nextPlayer)
                    ]
                )
            ]
        )
    }

    static var draw3CardsOnEliminating: Self {
        .init(
            name: .draw3CardsOnEliminating,
            type: .ability,
            description: "Draw 3 cards on eliminating an opponent",
            effects: [
                .init(
                    trigger: .eliminating,
                    action: .drawDeck,
                    selectors: [
                        .setTarget(.currentPlayer),
                        .repeat(.fixed(3))
                    ]
                )
            ]
        )
    }

    static var discardEquipedWeaponOnPrePlayed: Self {
        .init(
            name: .discardEquipedWeaponOnPrePlayed,
            type: .ability,
            description: "Discard your currently equipped weapon before equipping another one.",
            effects: [
                .init(
                    trigger: .weaponPrePlayed,
                    action: .discardInPlay,
                    selectors: [
                        .setCard(.equippedWeapon)
                    ]
                ),
            ]
        )
    }

    static var stagecoach: Self {
        .init(
            name: .stagecoach,
            type: .collectible,
            description: "Draw two cards from the top of the deck.",
            effects: [
                .playOnPrePlayed,
                .init(
                    trigger: .cardPlayed,
                    action: .drawDeck,
                    selectors: [
                        .repeat(.fixed(2))
                    ]
                )
            ]
        )
    }

    static var wellsFargo: Self {
        .init(
            name: .wellsFargo,
            type: .collectible,
            description: "Draw three cards from the top of the deck.",
            effects: [
                .playOnPrePlayed,
                .init(
                    trigger: .cardPlayed,
                    action: .drawDeck,
                    selectors: [
                        .repeat(.fixed(3))
                    ]
                )
            ]
        )
    }

    static var beer: Self {
        .init(
            name: .beer,
            type: .collectible,
            description: "Regain one life point. Beer has no effect if there are only 2 players left in the game.",
            effects: [
                .init(
                    trigger: .cardPrePlayed,
                    action: .play,
                    selectors: [
                        .require(.minimumPlayers(3))
                    ]
                ),
                .init(
                    trigger: .cardPlayed,
                    action: .heal,
                    amount: 1
                )
            ]
        )
    }

    static var saloon: Self {
        .init(
            name: .saloon,
            type: .collectible,
            description: "All players in play regain one life point.",
            effects: [
                .init(
                    trigger: .cardPrePlayed,
                    action: .play
                ),
                .init(
                    trigger: .cardPlayed,
                    action: .heal,
                    amount: 1,
                    selectors: [
                        .setTarget(.woundedPlayers)
                    ]
                )
            ]
        )
    }

    static var catBalou: Self {
        .init(
            name: .catBalou,
            type: .collectible,
            description: "Force “any one player” to “discard a card”, regardless of the distance.",
            effects: [
                .init(
                    trigger: .cardPrePlayed,
                    action: .play,
                    selectors: [
                        .chooseOne(.targetPlayer([.hasCards])),
                        .chooseOne(.targetCard())
                    ]
                ),
                .init(
                    trigger: .cardPlayed,
                    action: .discardHand,
                    selectors: [
                        .applyIf(.targetedCardFromHand)
                    ]
                ),
                .init(
                    trigger: .cardPlayed,
                    action: .discardInPlay,
                    selectors: [
                        .applyIf(.targetedCardFromInPlay)
                    ]
                )
            ]
        )
    }

    static var panic: Self {
        .init(
            name: .panic,
            type: .collectible,
            description: "Draw a card from a player at distance 1",
            effects: [
                .init(
                    trigger: .cardPrePlayed,
                    action: .play,
                    selectors: [
                        .chooseOne(.targetPlayer([.atDistance(1), .hasCards])),
                        .chooseOne(.targetCard())
                    ]
                ),
                .init(
                    trigger: .cardPlayed,
                    action: .stealHand,
                    selectors: [
                        .applyIf(.targetedCardFromHand)
                    ]
                ),
                .init(
                    trigger: .cardPlayed,
                    action: .stealInPlay,
                    selectors: [
                        .applyIf(.targetedCardFromInPlay)
                    ]
                )
            ]
        )
    }

    static var generalStore: Self {
        .init(
            name: .generalStore,
            type: .collectible,
            description: "When you play this card, turn as many cards from the deck face up as the players still playing. Starting with you and proceeding clockwise, each player chooses one of those cards and puts it in his hands.",
            effects: [
                .playOnPrePlayed,
                .init(
                    trigger: .cardPlayed,
                    action: .discover,
                    selectors: [
                        .repeat(.activePlayerCount)
                    ]
                ),
                .init(
                    trigger: .cardPlayed,
                    action: .drawDiscovered,
                    selectors: [
                        .setTarget(.activePlayers),
                        .chooseOne(.discoverCard)
                    ]
                )
            ]
        )
    }

    static var bang: Self {
        .init(
            name: .bang,
            type: .collectible,
            description: "reduce other players’s life points",
            effects: [
                .init(
                    trigger: .cardPrePlayed,
                    action: .play,
                    selectors: [
                        .require(.playLimitThisTurn(1)),
                        .chooseOne(.targetPlayer([.reachable]))
                    ]
                ),
                .init(
                    trigger: .cardPlayed,
                    action: .shoot
                )
            ]
        )
    }

    static var missed: Self {
        .init(
            name: .missed,
            type: .collectible,
            description: "If you are hit by a BANG! you may immediately play a Missed! - even though it is not your turn! - to cancel the shot.",
            effects: [
                .init(
                    trigger: .permanent,
                    action: .counterShot
                )
            ]
        )
    }

    static var gatling: Self {
        .init(
            name: .gatling,
            type: .collectible,
            description: "shoots to all the other players, regardless of the distance",
            effects: [
                .playOnPrePlayed,
                .init(
                    trigger: .cardPlayed,
                    action: .shoot,
                    selectors: [
                        .setTarget(.otherPlayers)
                    ]
                )
            ]
        )
    }

    static var indians: Self {
        .init(
            name: .indians,
            type: .collectible,
            description: "Each player, excluding the one who played this card, may discard a BANG! card, or lose one life point.",
            effects: [
                .playOnPrePlayed,
                .init(
                    trigger: .cardPlayed,
                    action: .damage,
                    amount: 1,
                    selectors: [
                        .setTarget(.otherPlayers),
                        .chooseOne(.counterCard([.named(.bang)]))
                    ]
                )
            ]
        )
    }

    static var duel: Self {
        .init(
            name: .duel,
            type: .collectible,
            description: "can challenge any other player. The first player failing to discard a BANG! card loses one life point.",
            effects: [
                .init(
                    trigger: .cardPrePlayed,
                    action: .play,
                    selectors: [
                        .chooseOne(.targetPlayer())
                    ]
                ),
                .init(
                    trigger: .cardPlayed,
                    action: .damage,
                    amount: 1,
                    selectors: [
                        .chooseOne(.redirectCard([.named(.bang)]))
                    ]
                )
            ]
        )
    }

    static var schofield: Self {
        .init(
            name: .schofield,
            type: .collectible,
            description: "can hit targets at a distance of 2.",
            effects: .weapon(range: 2)
        )
    }

    static var remington: Self {
        .init(
            name: .remington,
            type: .collectible,
            description: "can hit targets at a distance of 3.",
            effects: .weapon(range: 3)
        )
    }

    static var revCarabine: Self {
        .init(
            name: .revCarabine,
            type: .collectible,
            description: "can hit targets at a distance of 4.",
            effects: .weapon(range: 4)
        )
    }

    static var winchester: Self {
        .init(
            name: .winchester,
            type: .collectible,
            description: "can hit targets at a distance of 5.",
            effects: .weapon(range: 5)
        )
    }

    static var volcanic: Self {
        .init(
            name: .volcanic,
            type: .collectible,
            description: "can play any number of BANG! cards during your turn but limited to a distance of 1",
            effects: .weapon(range: 1) + [
                .init(
                    trigger: .prePlayingCard(named: .bang),
                    action: .addContextIgnoreLimitPerTurn,
                    amount: .unlimited
                )
            ]
        )
    }

    static var scope: Self {
        .init(
            name: .scope,
            type: .collectible,
            description: "you see all the other players at a distance decreased by 1",
            effects: [
                .equipOnPrePlayed,
                .init(
                    trigger: .cardEquiped,
                    action: .increaseMagnifying,
                    amount: 1
                ),
                .init(
                    trigger: .cardDiscarded,
                    action: .increaseMagnifying,
                    amount: -1
                )
            ]
        )
    }

    static var mustang: Self {
        .init(
            name: .mustang,
            type: .collectible,
            description: "the distance between other players and you is increased by 1",
            effects: [
                .equipOnPrePlayed,
                .init(
                    trigger: .cardEquiped,
                    action: .increaseRemoteness,
                    amount: 1
                ),
                .init(
                    trigger: .cardDiscarded,
                    action: .increaseRemoteness,
                    amount: -1
                )
            ]
        )
    }

    static var barrel: Self {
        .init(
            name: .barrel,
            type: .collectible,
            description: "allows you to “draw!” when you are the target of a BANG!: - if you draw a Heart card, you are Missed! (just like if you played a Missed! card); - otherwise nothing happens.",
            effects: [
                .equipOnPrePlayed,
                .init(
                    trigger: .shot,
                    action: .draw
                ),
                .init(
                    trigger: .shot,
                    action: .counterShot,
                    selectors: [
                        .applyIf(.drawnCardMatches(.regexHearts))
                    ]
                )
            ]
        )
    }

    static var dynamite: Self {
        .init(
            name: .dynamite,
            type: .collectible,
            description: "Play this card in front of you: the Dynamite will stay there for a whole turn. When you start your next turn (you have the Dynamite already in play), before the first phase you must “draw!”: - if you draw a card showing Spades and a number between 2 and 9, the Dynamite explodes! Discard it and lose 3 life points; - otherwise, pass the Dynamite to the player on your left (who will “draw!” on his turn, etc.).",
            effects: [
                .equipOnPrePlayed,
                .init(
                    trigger: .turnStarted,
                    action: .draw
                ),
                .init(
                    trigger: .turnStarted,
                    action: .passInPlay,
                    selectors: [
                        .applyIf(.not(.drawnCardMatches(.regex2To9Spades))),
                        .setCard(.played),
                        .setTarget(.nextPlayer)
                    ]
                ),
                .init(
                    trigger: .turnStarted,
                    action: .damage,
                    amount: 3,
                    selectors: [
                        .applyIf(.drawnCardMatches(.regex2To9Spades)),
                        .onComplete([
                            .init(
                                trigger: .turnStarted,
                                action: .discardInPlay,
                                selectors: [
                                    .setCard(.played)
                                ]
                            )
                        ])
                    ]
                )
            ]
        )
    }

    static var jail: Self {
        .init(
            name: .jail,
            type: .collectible,
            description: "Play this card in front of any player regardless of the distance: you put him in jail! If you are in jail, you must “draw!” before the beginning of your turn: - if you draw a Heart card, you escape from jail: discard the Jail, and continue your turn as normal; - otherwise discard the Jail and skip your turn",
            effects: [
                .init(
                    trigger: .cardPrePlayed,
                    action: .handicap,
                    selectors: [
                        .chooseOne(.targetPlayer())
                    ]
                ),
                .init(
                    trigger: .turnStarted,
                    action: .draw
                ),
                .init(
                    trigger: .turnStarted,
                    action: .endTurn,
                    selectors: [
                        .applyIf(.not(.drawnCardMatches(.regexHearts)))
                    ]
                ),
                .init(
                    trigger: .turnStarted,
                    action: .discardInPlay,
                    selectors: [
                        .setCard(.played)
                    ]
                )
            ]
        )
    }

    static var willyTheKid: Self {
        .init(
            name: .willyTheKid,
            type: .figure,
            description: "he can play any number of BANG! cards during his turn.",
            effects: [
                .maxHealth(4),
                .init(
                    trigger: .prePlayingCard(named: .bang),
                    action: .addContextIgnoreLimitPerTurn,
                    amount: .unlimited
                )
            ]
        )
    }

    static var roseDoolan: Self {
        .init(
            name: .roseDoolan,
            type: .figure,
            description: "she is considered to have an Appaloosa card in play at all times; she sees the other players at a distance decreased by 1.",
            effects: [
                .maxHealth(4),
                .init(
                    trigger: .permanent,
                    action: .increaseMagnifying,
                    amount: 1
                )
            ]
        )
    }

    static var paulRegret: Self {
        .init(
            name: .paulRegret,
            type: .figure,
            description: "he is considered to have a Mustang card in play at all times; all other players must add 1 to the distance to him.",
            effects: [
                .maxHealth(3),
                .init(
                    trigger: .permanent,
                    action: .increaseRemoteness,
                    amount: 1
                )
            ]
        )
    }

    static var bartCassidy: Self {
        .init(
            name: .bartCassidy,
            type: .figure,
            description: "each time he loses a life point, he immediately draws a card from the deck.",
            effects: [
                .maxHealth(4),
                .init(
                    trigger: .damaged,
                    action: .drawDeck,
                    selectors: [
                        .repeat(.receivedDamageAmount)
                    ]
                )
            ]
        )
    }

    static var elGringo: Self {
        .init(
            name: .elGringo,
            type: .figure,
            description: "each time he loses a life point due to a card played by another player, he draws a random card from the hands of that player (one card for each life point). If that player has no more cards, too bad! Note that Dynamite damages are not caused by any player.",
            effects: [
                .maxHealth(3),
                .init(
                    trigger: .damaged,
                    action: .stealHand,
                    selectors: [
                        .setTarget(.damagingPlayer),
                        .repeat(.receivedDamageAmount),
                        .chooseOne(.targetCard([.isFromHand]))
                    ]
                )
            ]
        )
    }

    static var suzyLafayette: Self {
        .init(
            name: .suzyLafayette,
            type: .figure,
            description: "as soon as she has no cards in her hand, she draws a card from the draw pile.",
            effects: [
                .maxHealth(4),
                .init(
                    trigger: .handEmptied,
                    action: .drawDeck
                )
            ]
        )
    }

    static var jourdonnais: Self {
        .init(
            name: .jourdonnais,
            type: .figure,
            description: "he is considered to have a Barrel card in play at all times; he can \"draw!\" when he is the target of a BANG!, and on a Heart he is missed. If he has another real Barrel card in play, he can count both of them, giving him two chances to cancel the BANG! before playing a Missed! card.",
            effects: [
                .maxHealth(4),
                .init(
                    trigger: .shot,
                    action: .draw
                ),
                .init(
                    trigger: .shot,
                    action: .counterShot,
                    selectors: [
                        .applyIf(.drawnCardMatches(.regexHearts))
                    ]
                )
            ]
        )
    }

    static var sidKetchum: Self {
        .init(
            name: .sidKetchum,
            type: .figure,
            description: "at any time, he may discard 2 cards from his hand to regain one life point. If he is willing and able, he can use this ability more than once at a time.",
            effects: [
                .maxHealth(4),
                .init(
                    trigger: .cardPrePlayed,
                    action: .heal,
                    amount: 1,
                    selectors: [
                        .chooseOne(.costCard([.isFromHand])),
                        .chooseOne(.costCard([.isFromHand]))
                    ]
                )
            ]
        )
    }

    static var vultureSam: Self {
        .init(
            name: .vultureSam,
            type: .figure,
            description: "whenever a character is eliminated from the game, Sam takes all the cards that player had in his hand and in play, and adds them to his hand.",
            effects: [
                .maxHealth(4),
                .init(
                    trigger: .otherEliminated,
                    action: .stealInPlay,
                    selectors: [
                        .setTarget(.eliminatedPlayer),
                        .setCard(.allInPlay)
                    ]
                ),
                .init(
                    trigger: .otherEliminated,
                    action: .stealHand,
                    selectors: [
                        .setTarget(.eliminatedPlayer),
                        .setCard(.allInHand)
                    ]
                )
            ]
        )
    }

    static var luckyDuke: Self {
        .init(
            name: .luckyDuke,
            type: .figure,
            description: "each time he is required to \"draw!\", he flips the top two cards from the deck, and chooses the result he prefers. Discard both cards afterwards.",
            effects: [
                .maxHealth(4),
                .init(
                    trigger: .requiredToDraw,
                    action: .draw
                )
            ]
        )
    }

    static var blackJack: Self {
        .init(
            name: .blackJack,
            type: .figure,
            description: "during the phase 1 of his turn, he must show the second card he draws: if it's Heart or Diamonds (just like a \"draw!\", he draws one additional card (without revealing it).",
            effects: [
                .maxHealth(4),
                .init(
                    trigger: .drawLastCardOnTurnStarted,
                    action: .showHand,
                    selectors: [
                        .setCard(.lastHand)
                    ]
                ),
                .init(
                    trigger: .drawLastCardOnTurnStarted,
                    action: .drawDeck,
                    selectors: [
                        .applyIf(.lastHandCardMatches(.regexRed))
                    ]
                )
            ]
        )
    }

    static var pedroRamirez: Self {
        .init(
            name: .pedroRamirez,
            type: .figure,
            description: "during the phase 1 of his turn, he may choose to draw the first card from the top of the discard pile or from the deck. Then, he draws the second card from the deck.",
            effects: [
                .maxHealth(4),
                .init(
                    trigger: .turnStarted,
                    action: .stealHand,
                    selectors: [
                        .chooseOne(.targetPlayer([.hasHandCards])),
                        .chooseOne(.targetCard([.isFromHand])),
                        .onComplete([
                            .init(
                                trigger: .turnStarted,
                                action: .addContextCardsPerTurn,
                                amount: -1
                            )
                        ])
                    ]
                )
            ]
        )
    }

    static var jesseJones: Self {
        .init(
            name: .jesseJones,
            type: .figure,
            description: "during phase 1 of his turn, he may choose to draw the first card from the deck, or randomly from the hand of any other player. Then he draws the second card from the deck.",
            effects: [
                .maxHealth(4),
                .init(
                    trigger: .turnStarted,
                    action: .drawDiscard,
                    selectors: [
                        .chooseOne(.discardedCard),
                        .onComplete([
                            .init(
                                trigger: .turnStarted,
                                action: .addContextCardsPerTurn,
                                amount: -1,
                            )
                        ])
                    ]
                )
            ]
        )
    }

    static var kitCarlson: Self {
        .init(
            name: .kitCarlson,
            type: .figure,
            description: "during the phase 1 of his turn, he looks at the top three cards of the deck: he chooses 2 to draw, and puts the other one back on the top of the deck, face down.",
            effects: [
                .maxHealth(4),
                .init(
                    trigger: .turnStarted,
                    action: .discover,
                    selectors: [
                        .repeat(.fixed(3))
                    ]
                ),
                .init(
                    trigger: .turnStarted,
                    action: .drawDiscovered,
                    selectors: [
                        .repeat(.fixed(2)),
                        .chooseOne(.discoverCard)
                    ]
                ),
                .init(
                    trigger: .turnStarted,
                    action: .undiscover
                ),
                .init(
                    trigger: .turnStarted,
                    action: .addContextCardsPerTurn,
                    amount: -2
                )
            ]
        )
    }

    static var slabTheKiller: Self {
        .init(
            name: .slabTheKiller,
            type: .figure,
            description: "players trying to cancel his BANG! cards need to play 2 Missed! cards. The Barrel effect, if successfully used, only counts as one Missed!.",
            effects: [
                .maxHealth(4),
                .init(
                    trigger: .shootingWithCard(named: .bang),
                    action: .addContextAdditionalMissed,
                    amount: 1
                )
            ]
        )
    }

    static var calamityJanet: Self {
        .init(
            name: .calamityJanet,
            type: .figure,
            description: "she can use BANG! cards as Missed! cards and vice versa. If she plays a Missed! card as a BANG!, she cannot play another BANG! card that turn (unless she has a Volcanic in play).",
            effects: [
                .maxHealth(4),
                .init(
                    trigger: .permanent,
                    action: .setPlayAlias,
                    playAlias: [.missed: .bang]
                ),
                .init(
                    trigger: .permanent,
                    action: .setEffectAlias,
                    effectAlias: [.bang: .missed]
                )
            ]
        )
    }

    // MARK: - Dodge city
/*
    static var punch: Self {
        .init(
            name: .punch,
            description: "Acts as a Bang! with a range of one.",
            effects: [
                .collectible,
                .init(
                    name: .shoot,
                    selectors: [
                        .chooseTarget([.atDistance(1)])
                    ]
                )
            ]
        )
    }

    static var dodge: Self {
        .init(
            name: .dodge,
            description: "Acts as a Missed!, but allows the player to draw a card.",
            canPlay: .shot,
            effects: [
                .collectible,
                .init(
                    name: .missed
                ),
                .init(
                    name: .drawDeck
                )
            ]
        )
    }

    static var springfield: Self {
        .init(
            name: .springfield,
            description: "The player must discard one additional card, and then the card acts as a Bang! with unlimited range.",
            effects: [
                .collectible,
                .init(
                    name: .shoot,
                    selectors: [
                        .chooseCostHandCard(),
                        .chooseTarget()
                    ]
                )
            ]
        )
    }

    static var hideout: Self {
        .init(
            name: .hideout,
            description: "Others view you at distance +1",
            increasePlayerAttribute: [.remoteness: 1]
        )
    }

    static var binocular: Self {
        .init(
            name: .binocular,
            description: "you view others at distance -1",
            increasePlayerAttribute: [.magnifying: 1]
        )
    }

    static var whisky: Self {
        .init(
            name: .whisky,
            description: "The player must discard one additional card, to heal two health.",
            effects: [
                .collectible,
                .init(
                    name: .heal,
                    selectors: [
                        .chooseCostHandCard(),
                        .setAttribute(.healAmount, value: .value(2))
                    ]
                )
            ]
        )
    }

    static var tequila: Self {
        .init(
            name: .tequila,
            description: "The player must discard one additional card, to heal any player one health.",
            setPlayerAttribute: [.maxHealth: 4],
            effects: [
                .collectible,
                .init(
                    name: .heal,
                    selectors: [
                        .chooseCostHandCard(),
                        .chooseTarget()
                    ]
                )
            ]
        )
    }

    static var ragTime: Self {
        .init(
            name: .ragTime,
            description: "The player must discard one additional card to steal a card from any other player.",
            effects: [
                .collectible,
                .init(
                    name: .steal,
                    selectors: [
                        .chooseCostHandCard(),
                        .chooseTarget(),
                        .chooseCard()
                    ]
                )
            ]
        )
    }

    static var brawl: Self {
        .init(
            name: .brawl,
            description: "The player must discard one additional card to cause all other players to discard one card.",
            effects: [
                .collectible,
                .init(
                    name: .discard,
                    selectors: [
                        .chooseCostHandCard(),
                        .setTarget(.all),
                        .chooseCard()
                    ]
                )
            ]
        )
    }

    static var elenaFuente: Self {
        .init(
            name: .elenaFuente,
            description: "She may use any card in hand as Missed!.",
            setPlayerAttribute: [.maxHealth: 3],
            setActionAttribute: ["": [.playableAsMissed: 0]]
        )
    }

    static var seanMallory: Self {
        .init(
            name: .seanMallory,
            description: "He may hold in his hand up to 10 cards.",
            setPlayerAttribute: [.maxHealth: 3, .handLimit: 10]
        )
    }

    static var tequilaJoe: Self {
        .init(
            name: .tequilaJoe,
            description: "Each time he plays a Beer, he regains 2 life points instead of 1.",
            setPlayerAttribute: [.maxHealth: 4],
            setActionAttribute: [.beer: [.healAmount: 2]]
        )
    }

    static var pixiePete: Self {
        .init(
            name: .pixiePete,
            description: "During phase 1 of his turn, he draws 3 cards instead of 2.",
            setPlayerAttribute: [.maxHealth: 3],
            setActionAttribute: [.draw2CardsOnTurnStarted: [.silent: 0]],
            effects: [
                .init(
                    name: .drawDeck,
                    selectors: [
                        .repeat(.value(3))
                    ],
                    when: .turnStarted
                )
            ]
        )
    }

    static var billNoface: Self {
        .init(
            name: .billNoface,
            description: "He draws 1 card, plus 1 card for each wound he has.",
            setPlayerAttribute: [.maxHealth: 4],
            setActionAttribute: [.draw2CardsOnTurnStarted: [.silent: 0]],
            effects: [
                .init(
                    name: .drawDeck,
                    when: .turnStarted
                ),
                .init(
                    name: .drawDeck,
                    selectors: [
                        .repeat(.wound)
                    ],
                    when: .turnStarted
                )
            ]
        )
    }

    static var gregDigger: Self {
        .init(
            name: .gregDigger,
            description: "Each time another player is eliminated, he regains 2 life points.",
            setPlayerAttribute: [.maxHealth: 4],
            effects: [
                .init(
                    name: .heal,
                    selectors: [
                        .setAttribute(.healAmount, value: .value(2))
                    ],
                    when: .otherEliminated
                )
            ]
        )
    }

    static var herbHunter: Self {
        .init(
            name: .herbHunter,
            description: "Each time another player is eliminated, he draws 2 extra cards.",
            setPlayerAttribute: [.maxHealth: 4],
            effects: [
                .init(
                    name: .drawDeck,
                    selectors: [
                        .repeat(.value(2))
                    ],
                    when: .otherEliminated
                )
            ]
        )
    }

    static var mollyStark: Self {
        .init(
            name: .mollyStark,
            description: "Each time she uses a card from her hand out of turn, she draw a card.",
            setPlayerAttribute: [.maxHealth: 4],
            effects: [
                .init(
                    name: .drawDeck,
                    selectors: [
                        .require(.limitPerTurn(2))
                    ],
                    when: .playedCardOutOfTurn
                )
            ]
        )
    }

    static var joseDelgado: Self {
        .init(
            name: .joseDelgado,
            description: "Twice in his turn, he may discard a blue card from the hand to draw 2 cards.",
            setPlayerAttribute: [.maxHealth: 4],
            effects: [
                .init(
                    name: .drawDeck,
                    selectors: [
                        .require(.limitPerTurn(2)),
                        .chooseCostHandCard(.isBlue),
                        .repeat(.value(2))
                    ]
                )
            ]
        )
    }

    static var chuckWengam: Self {
        .init(
            name: .chuckWengam,
            description: "During his turn, he may choose to lose 1 life point to draw 2 cards. However, the last life point cannot be lost.",
            setPlayerAttribute: [.maxHealth: 4],
            effects: [
                .init(
                    name: .damage
                ),
                .init(
                    name: .drawDeck,
                    selectors: [
                        .repeat(.value(2))
                    ]
                )
            ]
        )
    }

    static var docHolyday: Self {
        .init(
            name: .docHolyday,
            description: "Once during his turn, he may discard 2 cards from the hand to shoot a Bang!.",
            setPlayerAttribute: [.maxHealth: 4],
            effects: [
                .init(
                    name: .shoot,
                    selectors: [
                        .require(.limitPerTurn(1)),
                        .chooseCostHandCard(count: 2),
                        .chooseTarget([.atDistanceReachable])
                    ]
                )
            ]
        )
    }

    static var apacheKid: Self {
        .init(
            name: .apacheKid,
            description: "Cards of Diamond played by other players do not affect him",
            setPlayerAttribute: [.maxHealth: 4],
            setActionAttribute: ["♦️": [.playedByOtherHasNoEffect: 0]]
        )
    }

    static var belleStar: Self {
        .init(
            name: .belleStar,
            description: "During her turn, cards in play in front of other players have no effect. ",
            setPlayerAttribute: [.maxHealth: 4],
            setActionAttribute: ["": [.inPlayOfOtherHasNoEffect: 0]]
        )
    }

    static var patBrennan: Self {
        .init(
            name: .patBrennan,
            description: "Instead of drawing normally, he may draw only one card in play in front of any one player.",
            setPlayerAttribute: [.maxHealth: 4],
            setActionAttribute: [.draw2CardsOnTurnStarted: [.eventuallySilent: 0]],
            effects: [
                .init(
                    name: .steal,
                    selectors: [
                        .chooseTarget([.havingInPlayCard]),
                        .chooseCard(.inPlay)
                    ],
                    when: .turnStarted
                )
            ]
        )
    }

    static var veraCuster: Self {
        .init(
            name: .veraCuster,
            description: "For a whole round, she gains the same ability of another character in play of her choice until the beginning of her next turn",
            setPlayerAttribute: [.maxHealth: 3]
        )
    }

    // MARK: - The Valley of Shadows

    static var lastCall: Self {
        .init(
            name: .lastCall,
            description: "Refill 1 life point even in game last 2 players.",
            effects: [
                .collectible,
                .init(
                    name: .heal
                )
            ]
        )
    }

    static var tornado: Self {
        .init(
            name: .tornado,
            description: "Each player discards a card from their hand (if possible), then draw 2 cards from the deck",
            effects: [
                .collectible,
                .init(
                    name: .drawDeck,
                    selectors: [
                        .setTarget(.all),
                        .chooseCostHandCard(),
                        .repeat(.value(2))
                    ]
                )
            ]
        )
    }

    static var backfire: Self {
        .init(
            name: .backfire,
            description: "Count as MISSED!. Player who shot you, is now target of BANG!.",
            effects: [
                .collectible,
                .init(
                    name: .missed
                ),
                .init(
                    name: .shoot,
                    selectors: [
                        .setTarget(.offender)
                    ]
                )
            ]
        )
    }

    static var tomahawk: Self {
        .init(
            name: .tomahawk,
            description: "Bang at distance 2. But it can be used at distance 1",
            effects: [
                .collectible,
                .init(
                    name: .shoot,
                    selectors: [
                        .chooseTarget([.atDistance(2)])
                    ]
                )
            ]
        )
    }

    static var aim: Self {
        .init(
            name: .aim,
            description: "Play with Bang card. If defending player doesn't miss, he loses 2 life points instead",
            setActionAttribute: [.bang: [.damageAmount: 2]],
            canPlay: .playedCardWithName(.bang),
            effects: [
                .playable
            ]
        )
    }

    static var faning: Self {
        .init(
            name: .faning,
            description: "Count as your normal bang per turn. You hit addional player at distance 1 from 1st target(except you).",
            setActionAttribute: ["faning": [.labeledAsBang: 0]],
            effects: [
                .collectible,
                .init(
                    name: .shoot,
                    selectors: [
                        .require(.limitPerTurn(1)),
                        .chooseTarget([.atDistanceReachable])
                    ]
                ),
                .init(
                    name: .shoot,
                    selectors: [
                        .chooseTarget([.neighbourToTarget])
                    ]
                )
            ]
        )
    }

    static var saved: Self {
        .init(
            name: .saved,
            description: "Play out your turn. By discarding prevent any player to lose 1 life. In case of save from death, you draw 2 card form hand of saved player or from deck (your choice).",
            canPlay: .otherDamaged,
            effects: [
                .collectible,
                .init(
                    name: .heal,
                    selectors: [
                        .setTarget(.damaged)
                    ]
                ),
                .init(
                    name: .drawDeck,
                    selectors: [
                        .require(.targetHealthIs1),
                        .repeat(.value(2))
                    ]
                )
            ]
        )
    }

    static var bandidos: Self {
        .init(
            name: .bandidos,
            description: "Others players may discard 2 cards from hand (1 if he only has one) or loose one life point.",
            effects: [
                .collectible,
                .init(
                    name: .damage,
                    selectors: [
                        .setTarget(.others),
                        .chooseEventuallyCounterHandCard(count: 2)
                    ]
                )
            ]
        )
    }

    static var poker: Self {
        .init(
            name: .poker,
            description: "All others players discard a card. If no one discards an Ace card, you can draw 2 cards from the discarded cards.",
            effects: [
                .collectible,
                .init(
                    name: .discard,
                    selectors: [
                        .setTarget(.others),
                        .chooseCard()
                    ]
                ),
                .init(
                    name: .drawDiscard,
                    selectors: [
                        .require(.discardedCardsNotAce),
                        .repeat(.value(2)),
                        .chooseCard(.discarded)
                    ]
                )
            ]
        )
    }

    static var lemat: Self {
        .init(
            name: .lemat,
            description: "gun, range 1: In your turn, you may use any card like BANG card.",
            setPlayerAttribute: [.weapon: 1],
            setActionAttribute: ["": [.playableAsBang: 0]]
        )
    }

    static var shootgun: Self {
        .init(
            name: .shootgun,
            description: "gun, range 1: If any player is hit by BANG! card by player with SHOTGUN, that player discard 1 card from hand at his choice.",
            setPlayerAttribute: [.weapon: 1],
            effects: [
                .equip,
                .init(
                    name: .discard,
                    selectors: [
                        .setTarget(.damaged),
                        .chooseCard(.fromHand)
                    ],
                    when: .otherDamagedByYourCard(.bang)
                )
            ]
        )
    }

    static var bounty: Self {
        .init(
            name: .bounty,
            description: "Play in front any player. Player who succesfully hit player with BOUNTY with BANG! card, he draw a card.",
            effects: [
                .handicap,
                .init(
                    name: .drawDeck,
                    selectors: [
                        .setTarget(.offender)
                    ],
                    when: .damagedByCard(.bang)
                )
            ]
        )
    }

    static var rattlesnake: Self {
        .init(
            name: .rattlesnake,
            description: "Play in front any player. At beginnings of that player's turn, he draw: On Spade, he lose 1 life point, otherwise he does nothing.",
            effects: [
                .handicap,
                .init(
                    name: .draw,
                    when: .turnStarted
                ),
                .init(
                    name: .damage,
                    selectors: [
                        .require(.draw("♠️"))
                    ],
                    when: .turnStarted
                )
            ]
        )
    }

    static var escape: Self {
        .init(
            name: .escape,
            description: "If you are target of card other than BANG! card, you may discard this card to avoid that card's effect.",
            effects: [
                .init(
                    name: .counter,
                    when: .targetedWithCardOthertThan(.bang)
                )
            ]
        )
    }

    static var ghost: Self {
        .init(
            name: .ghost,
            description: "Play in front any eliminated player. He return to game without his ability and possibilty to grain or lose any life point. He play as normal player.",
            setPlayerAttribute: [.ghost: 0]
        )
    }

    static var coloradoBill: Self {
        .init(
            name: .coloradoBill,
            description: "Eachtime any player play MISSED! against BANG! card from Colorado: Colorado draw: on Spades, MISSED! is ignored and that player lose 1 life points.",
            effects: [
                .init(
                    name: .draw,
                    when: .otherMissedYourShoot(.bang)
                ),
                .init(
                    name: .damage,
                    selectors: [
                        .require(.draw("♠️")),
                        .setTarget(.targeted)
                    ],
                    when: .otherMissedYourShoot(.bang)
                )
            ]
        )
    }

    static var evelynShebang: Self {
        .init(
            name: .evelynShebang,
            description: "She may decide not to draw some number of cards in her draw phase. For each card skipped, she shoots a Bang! at a different target in reachable distance.",
            setActionAttribute: [.draw2CardsOnTurnStarted: [.eventuallySilent: 0]],
            effects: [
                .init(
                    name: .shoot,
                    selectors: [
                        .repeat(.value(2)),
                        .chooseTarget([.atDistanceReachable])
                    ],
                    when: .turnStarted
                )
            ]
        )
    }

    static var lemonadeJim: Self {
        .init(
            name: .lemonadeJim,
            description: "When another player plays BEER card, he may discard any card to refill 1 life point.",
            canPlay: .otherPlayedCard(.beer),
            effects: [
                .init(
                    name: .heal,
                    selectors: [
                        .chooseCostHandCard()
                    ]
                )
            ]
        )
    }

    static var henryBlock: Self {
        .init(
            name: .henryBlock,
            description: "Any another player who discards or draw from Henry hand or in front him, is target of BANG.",
            effects: [
                .init(
                    name: .shoot,
                    selectors: [
                        .setTarget(.offender)
                    ],
                    when: .cardStolen
                ),
                .init(
                    name: .shoot,
                    selectors: [
                        .setTarget(.offender)
                    ],
                    when: .cardDiscarded
                )
            ]
        )
    }

    static var blackFlower: Self {
        .init(
            name: .blackFlower,
            description: "Once per turn, she can shoot an extra Bang! by discarding a Clubs card.",
            effects: [
                .init(
                    name: .shoot,
                    selectors: [
                        .require(.limitPerTurn(1)),
                        .chooseCostHandCard(.suits("♣️")),
                        .chooseTarget([.atDistanceReachable])
                    ]
                )
            ]
        )
    }

    static var derSpotBurstRinger: Self {
        .init(
            name: .derSpotBurstRinger,
            description: "Once per turn, he can play a Bang! card as Gatling.",
            effects: [
                .init(
                    name: .shoot,
                    selectors: [
                        .require(.limitPerTurn(1)),
                        .chooseCostHandCard(.named(.bang)),
                        .setTarget(.others)
                    ]
                )
            ]
        )
    }

    static var tucoFranziskaner: Self {
        .init(
            name: .tucoFranziskaner,
            description: "During his draw phase, he draw 2 extra cards if he has no blue cards in play.",
            effects: [
                .init(
                    name: .drawDeck,
                    selectors: [
                        .require(.hasNoBlueCardsInPlay),
                        .repeat(.value(2))
                    ],
                    when: .turnStarted
                )
            ]
        )
    }
 */
}

/// Card effect regex
/// https://regex101.com/
private extension String {
    static let regexHearts = "♥️"
    static let regexRed = "(♥️)|(♦️)"
    static let regex2To9Spades = "([2|3|4|5|6|7|8|9]♠️)"
}

private extension Card.Effect {
    static var playOnPrePlayed: Self {
        .init(
            trigger: .cardPrePlayed,
            action: .play
        )
    }

    static var equipOnPrePlayed: Self {
        .init(
            trigger: .cardPrePlayed,
            action: .equip
        )
    }

    static func maxHealth(_ value: Int) -> Self {
        .init(
            trigger: .permanent,
            action: .setMaxHealth,
            amount: value
        )
    }
}

private extension Array where Element == Card.Effect {
    static func weapon(range: Int) -> Self {
        [
            .equipOnPrePlayed,
            .init(
                trigger: .cardEquiped,
                action: .setWeapon,
                amount: range
            ),
            .init(
                trigger: .cardDiscarded,
                action: .setWeapon,
                amount: 1
            )
        ]
    }
}
