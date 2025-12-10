//
//  Cards.swift
//
//  Created by Hugues Telolahy on 28/10/2024.
//
// swiftlint:disable file_length line_length

import GameCore
import CardResources

/// BANG! THE BULLET
/// https://bang.dvgiochi.com/cardslist.php?id=2#q_result
enum Cards {
    static let all: [Card] = [
        // MARK: - Aura
        .endTurn,
        .playMissedOnShot,
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

        // MARK: - Bang
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

        // MARK: - Dodge city
        .punch,
        .dodge,
        .binocular,
        .hideout,
        .springfield,
        .whisky,
        .tequila,
        .ragTime,
        .brawl,
    ]
}

private extension Card {
    // MARK: - Default

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

    static var playMissedOnShot: Self {
        .init(
            name: .playMissedOnShot,
            type: .ability,
            description: "Discard counter card on shot",
            effects: [
                .init(
                    trigger: .shot,
                    action: .play,
                    selectors: [
                        .repeat(.requiredMisses),
                        .chooseOne(.playedCard([.canCounterShot]))
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
                    action: .drawDeck,
                    selectors: [
                        .repeat(.fixed(2))
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
                        .applyIf(.isHealthZero)
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
                        .setTarget(.sourcePlayer),
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

    // MARK: - Bang

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
                    trigger: .cardPlayed,
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
                        .setTarget(.otherPlayers())
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
                        .setTarget(.otherPlayers()),
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
                    action: .applyModifier,
                    modifier: .ignoreLimitPerTurn
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
                    action: .applyModifier,
                    modifier: .ignoreLimitPerTurn
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
                                action: .applyModifier,
                                modifier: .incrementCardsPerTurn,
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
                                action: .applyModifier,
                                modifier: .incrementCardsPerTurn,
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
                    action: .applyModifier,
                    modifier: .incrementCardsPerTurn,
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
                    action: .applyModifier,
                    modifier: .incrementRequiredMisses,
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
                    action: .setAlias,
                    alias: [.missed: .bang]
                ),
                .init(
                    trigger: .permanent,
                    action: .setAlias,
                    alias: [.bang: .missed]
                )
            ]
        )
    }

    // MARK: - Dodge city

    static var punch: Self {
        .init(
            name: .punch,
            type: .collectible,
            description: "Acts as a Bang! with a range of one.",
            effects: [
                .init(
                    trigger: .cardPrePlayed,
                    action: .play,
                    selectors: [
                        .chooseOne(.targetPlayer([.atDistance(1)]))
                    ]
                ),
                .init(
                    trigger: .cardPlayed,
                    action: .shoot
                )
            ]
        )
    }

    static var dodge: Self {
        .init(
            name: .dodge,
            type: .collectible,
            description: "Acts as a Missed!, but allows the player to draw a card.",
            effects: [
                .init(
                    trigger: .cardPlayed,
                    action: .counterShot
                ),
                .init(
                    trigger: .cardPlayed,
                    action: .drawDeck
                )
            ]
        )
    }

    static var binocular: Self {
        .init(
            name: .binocular,
            type: .collectible,
            description: "you view others at distance -1",
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

    static var hideout: Self {
        .init(
            name: .hideout,
            type: .collectible,
            description: "Others view you at distance +1",
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

    static var springfield: Self {
        .init(
            name: .springfield,
            type: .collectible,
            description: "The player must discard one additional card, and then the card acts as a Bang! with unlimited range.",
            effects: [
                .init(
                    trigger: .cardPrePlayed,
                    action: .play,
                    selectors: [
                        .setTarget(.sourcePlayer),
                        .chooseOne(.costCard([.isFromHand])),
                        .chooseOne(.targetPlayer())
                    ]
                ),
                .init(
                    trigger: .cardPlayed,
                    action: .shoot
                )
            ]
        )
    }

    static var whisky: Self {
        .init(
            name: .whisky,
            type: .collectible,
            description: "The player must discard one additional card, to heal two health.",
            effects: [
                .init(
                    trigger: .cardPrePlayed,
                    action: .play,
                    selectors: [
                        .setTarget(.sourcePlayer),
                        .chooseOne(.costCard([.isFromHand]))
                    ]
                ),
                .init(
                    trigger: .cardPlayed,
                    action: .heal,
                    amount: 2
                )
            ]
        )
    }

    static var tequila: Self {
        .init(
            name: .tequila,
            type: .collectible,
            description: "The player must discard one additional card, to heal any player one health.",
            effects: [
                .init(
                    trigger: .cardPrePlayed,
                    action: .play,
                    selectors: [
                        .setTarget(.sourcePlayer),
                        .chooseOne(.costCard([.isFromHand])),
                        .chooseOne(.targetPlayer([.isWounded]))
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

    static var ragTime: Self {
        .init(
            name: .ragTime,
            type: .collectible,
            description: "The player must discard one additional card to steal a card from any other player.",
            effects: [
                .init(
                    trigger: .cardPrePlayed,
                    action: .play,
                    selectors: [
                        .setTarget(.sourcePlayer),
                        .chooseOne(.costCard([.isFromHand])),
                        .chooseOne(.targetPlayer([.hasCards])),
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

    static var brawl: Self {
        .init(
            name: .brawl,
            type: .collectible,
            description: "The player must discard one additional card to cause all other players to discard one card.",
            effects: [
                .init(
                    trigger: .cardPrePlayed,
                    action: .play,
                    selectors: [
                        .setTarget(.sourcePlayer),
                        .chooseOne(.costCard([.isFromHand]))
                    ]
                ),
                .init(
                    trigger: .cardPlayed,
                    action: .dummy,
                    selectors: [
                        .setTarget(.otherPlayers([.hasCards])),
                        .chooseOne(.targetCard()),
                        .onComplete([
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
                        ])
                    ]
                )
            ]
        )
    }
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

private extension String {
    static let playMissedOnShot = "playMissedOnShot"
    static let discardExcessHandOnTurnEnded = "discardExcessHandOnTurnEnded"
    static let draw2CardsOnTurnStarted = "draw2CardsOnTurnStarted"
    static let nextTurnOnTurnEnded = "nextTurnOnTurnEnded"
    static let eliminateOnDamagedLethal = "eliminateOnDamagedLethal"
    static let endGameOnEliminated = "endGameOnEliminated"
    static let discardAllCardsOnEliminated = "discardAllCardsOnEliminated"
    static let nextTurnOnEliminated = "nextTurnOnEliminated"
    static let discardBeerOnDamagedLethal = "discardBeerOnDamagedLethal"
    static let draw3CardsOnEliminating = "draw3CardsOnEliminating"
    static let discardEquipedWeaponOnPrePlayed = "discardEquipedWeaponOnPrePlayed"
}
