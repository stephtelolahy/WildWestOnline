//
//  CardDefinitions.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 06/04/2025.
//

/*
 static var discardBeerOnDamagedLethal: Self {
     .init(
         name: .discardBeerOnDamagedLethal,
         description: "When you lose your last life point, you are eliminated and your game is over, unless you immediately play a Beer",
         canPlay: .damagedLethal,
         effects: [
             .init(
                 name: .heal,
                 selectors: [
                     .require(.minimumPlayers(3)),
                     .chooseCostHandCard(.named(.beer))
                 ]
             )
         ]
     )
 }

 static var jourdonnais: Self {
     .init(
         name: .jourdonnais,
         description: "he is considered to have a Barrel card in play at all times; he can \"draw!\" when he is the target of a BANG!, and on a Heart he is missed. If he has another real Barrel card in play, he can count both of them, giving him two chances to cancel the BANG! before playing a Missed! card.",
         setPlayerAttribute: [.maxHealth: 4],
         effects: [
             .init(
                 name: .draw,
                 when: .shot
             ),
             .init(
                 name: .missed,
                 selectors: [
                     .require(.draw("♥️"))
                 ],
                 when: .shot
             )
         ]
     )
 }

 static var elGringo: Self {
     .init(
         name: .elGringo,
         description: "each time he loses a life point due to a card played by another player, he draws a random card from the hands of that player (one card for each life point). If that player has no more cards, too bad! Note that Dynamite damages are not caused by any player.",
         setPlayerAttribute: [.maxHealth: 3],
         effects: [
             .init(
                 name: .steal,
                 selectors: [
                     .setTarget(.offender),
                     .repeat(.damage)
                 ],
                 when: .damaged
             )
         ]
     )
 }

 static var suzyLafayette: Self {
     .init(
         name: .suzyLafayette,
         description: "as soon as she has no cards in her hand, she draws a card from the draw pile.",
         setPlayerAttribute: [.maxHealth: 4],
         effects: [
             .init(
                 name: .drawDeck,
                 when: .handEmpty
             )
         ]
     )
 }

 static var sidKetchum: Self {
     .init(
         name: .sidKetchum,
         description: "at any time, he may discard 2 cards from his hand to regain one life point. If he is willing and able, he can use this ability more than once at a time.",
         setPlayerAttribute: [.maxHealth: 4],
         effects: [
             .init(
                 name: .heal,
                 selectors: [
                     .chooseCostHandCard(count: 2)
                 ]
             )
         ]
     )
 }

 static var vultureSam: Self {
     .init(
         name: .vultureSam,
         description: "whenever a character is eliminated from the game, Sam takes all the cards that player had in his hand and in play, and adds them to his hand.",
         setPlayerAttribute: [.maxHealth: 4],
         effects: [
             .init(
                 name: .steal,
                 selectors: [
                     .setTarget(.eliminated),
                     .setCard(.all)
                 ],
                 when: .otherEliminated
             )
         ]
     )
 }

 static var slabTheKiller: Self {
     .init(
         name: .slabTheKiller,
         description: "players trying to cancel his BANG! cards need to play 2 Missed! cards. The Barrel effect, if successfully used, only counts as one Missed!.",
         setPlayerAttribute: [.maxHealth: 4],
         setActionAttribute: [.bang: [.shootRequiredMisses: 2]]
     )
 }

 static var luckyDuke: Self {
     .init(
         name: .luckyDuke,
         description: "each time he is required to \"draw!\", he flips the top two cards from the deck, and chooses the result he prefers. Discard both cards afterwards.",
         setPlayerAttribute: [.maxHealth: 4, .drawCards: 2]
     )
 }

 static var calamityJanet: Self {
     .init(
         name: .calamityJanet,
         description: "she can use BANG! cards as Missed! cards and vice versa. If she plays a Missed! card as a BANG!, she cannot play another BANG! card that turn (unless she has a Volcanic in play).",
         setPlayerAttribute: [.maxHealth: 4],
         setActionAttribute: [
             "missed": [.playableAsBang: 0],
             "bang": [.playableAsMissed: 0]
         ]
     )
 }

 static var kitCarlson: Self {
     .init(
         name: .kitCarlson,
         description: "during the phase 1 of his turn, he looks at the top three cards of the deck: he chooses 2 to draw, and puts the other one back on the top of the deck, face down.",
         setPlayerAttribute: [.maxHealth: 4],
         setActionAttribute: [.draw2CardsOnTurnStarted: [.silent: 0]],
         effects: [
             .init(
                 name: .discover,
                 selectors: [
                     .setAttribute(.discoverAmount, value: .value(3))
                 ],
                 when: .turnStarted
             ),
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

 static var blackJack: Self {
     .init(
         name: .blackJack,
         description: "during the phase 1 of his turn, he must show the second card he draws: if it's Heart or Diamonds (just like a \"draw!\", he draws one additional card (without revealing it).",
         setPlayerAttribute: [.maxHealth: 4],
         setActionAttribute: [.draw2CardsOnTurnStarted: [.silent: 0]],
         effects: [
             .init(
                 name: .drawDeck,
                 selectors: [
                     .repeat(.value(2))
                 ],
                 when: .turnStarted
             ),
             .init(
                 name: .showLastDraw,
                 when: .turnStarted
             ),
             .init(
                 name: .drawDeck,
                 selectors: [
                     .require(.draw("(♥️)|(♦️)"))
                 ],
                 when: .turnStarted
             )
         ]
     )
 }

 static var jesseJones: Self {
     .init(
         name: .jesseJones,
         description: "during phase 1 of his turn, he may choose to draw the first card from the deck, or randomly from the hand of any other player. Then he draws the second card from the deck.",
         setPlayerAttribute: [.maxHealth: 4],
         setActionAttribute: [.draw2CardsOnTurnStarted: [.eventuallySilent: 0]],
         effects: [
             .init(
                 name: .drawDiscard,
                 when: .turnStarted
             ),
             .init(
                 name: .drawDeck,
                 when: .turnStarted
             )
         ]
     )
 }

 static var pedroRamirez: Self {
     .init(
         name: .pedroRamirez,
         description: "during the phase 1 of his turn, he may choose to draw the first card from the top of the discard pile or from the deck. Then, he draws the second card from the deck.",
         setPlayerAttribute: [.maxHealth: 4],
         setActionAttribute: [.draw2CardsOnTurnStarted: [.eventuallySilent: 0]],
         effects: [
             .init(
                 name: .steal,
                 selectors: [
                     .chooseTarget([.havingHandCard]),
                     .chooseCard()
                 ],
                 when: .turnStarted
             ),
             .init(
                 name: .drawDeck,
                 when: .turnStarted
             )
         ]
     )
 }

 // MARK: - Dodge city

 static var punch: Self {
     .init(
         name: .punch,
         description: "Acts as a Bang! with a range of one.",
         effects: [
             .brown,
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
             .brown,
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
             .brown,
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
             .brown,
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
             .brown,
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
             .brown,
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
             .brown,
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
             .brown,
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
             .brown,
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
             .brown,
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
             .brown,
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
             .brown
         ]
     )
 }

 static var faning: Self {
     .init(
         name: .faning,
         description: "Count as your normal bang per turn. You hit addional player at distance 1 from 1st target(except you).",
         setActionAttribute: ["faning": [.labeledAsBang: 0]],
         effects: [
             .brown,
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
             .brown,
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
             .brown,
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
             .brown,
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
}
*/
