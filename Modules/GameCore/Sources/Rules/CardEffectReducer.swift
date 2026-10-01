//
//  CardEffectReducer.swift
//
//  Created by Hugues Telolahy on 30/10/2024.
//

import Redux

extension Card.ActionName {
    func reduce(_ action: GameFeature.Action, state: GameFeature.State) throws(GameFeature.Error) -> GameFeature.State {
        var state = state
        try state.reduce(self, action: action)
        return state
    }
}

private extension GameFeature.State {
    // swiftlint:disable:next function_body_length
    mutating func reduce(_ name: Card.ActionName, action: GameFeature.Action) throws(GameFeature.Error) {
        let player = action.sourcePlayer
        switch name {
        case .preparePlay:
            try preparePlay(action)

        case .play:
            play(action)

        case .equip:
            try putInPlay(action.sourceCard, from: player, to: player)

        case .handicap:
            try putInPlay(action.sourceCard, from: player, to: action.requiredTarget)

        case .draw:
            let card = try popDeck()
            discard.insert(card, at: 0)

        case .drawDeck:
            let card = try popDeck()
            self[player: action.requiredTarget].hand.append(card)

        case .drawDiscard:
            let card = action.requiredCard
            guard try popDiscard() == card else { fatalError("Card \(card) is not the top discard") }
            self[player: action.requiredTarget].hand.append(card)

        case .drawDiscovered:
            drawDiscovered(action.requiredCard, player: action.requiredTarget)

        case .discover:
            if discovered.count >= deck.count {
                try resetDeck()
            }
            discovered.append(deck[discovered.count])

        case .undiscover:
            discovered = []

        case .discardHand:
            take(action.requiredCard, from: \.hand, of: action.requiredTarget)
            discard.insert(action.requiredCard, at: 0)

        case .discardInPlay:
            take(action.requiredCard, from: \.inPlay, of: action.requiredTarget)
            discard.insert(action.requiredCard, at: 0)

        case .stealHand:
            take(action.requiredCard, from: \.hand, of: action.requiredTarget)
            self[player: player].hand.append(action.requiredCard)

        case .stealInPlay:
            take(action.requiredCard, from: \.inPlay, of: action.requiredTarget)
            self[player: player].hand.append(action.requiredCard)

        case .passInPlay:
            take(action.requiredCard, from: \.inPlay, of: player)
            self[player: action.requiredTarget].inPlay.append(action.requiredCard)

        case .showHand:
            guard action.targetedPlayer != nil, action.targetedCard != nil else { fatalError("Missing targetedPlayer or targetedCard") }

        case .heal:
            try heal(action.requiredAmount, player: action.requiredTarget)

        case .damage:
            self[player: action.requiredTarget].health -= action.requiredAmount

        case .choose:
            choose(action)

        case .shoot:
            queue.insert(
                .init(
                    name: .damage,
                    sourcePlayer: player,
                    sourceCard: action.sourceCard,
                    triggeredBy: [action],
                    targetedPlayer: action.requiredTarget,
                    amount: 1,
                    requiredMisses: 1
                ),
                at: 0
            )

        case .counterShot:
            counterShot(target: action.requiredTarget)

        case .endTurn:
            let target = action.requiredTarget
            turn = nil
            queue.removeAll { $0.sourcePlayer == target && $0.sourceCard != action.sourceCard }

        case .startTurn:
            turn = action.requiredTarget

        case .queue:
            guard let children = action.children else { fatalError("Missing children") }
            queue.insert(contentsOf: children, at: 0)

        case .eliminate:
            let target = action.requiredTarget
            playOrder.removeAll { $0 == target }
            queue.removeAll { $0.sourcePlayer == target }

        case .endGame:
            isOver = true

        case .activate:
            guard let cards = action.playableCards else { fatalError("Missing playableCards") }
            playable = .init(player: action.requiredTarget, cards: cards)

        case .setWeapon:
            self[player: action.requiredTarget].weapon = action.requiredAmount

        case .increaseMagnifying:
            self[player: action.requiredTarget].magnifying += action.requiredAmount

        case .increaseRemoteness:
            self[player: action.requiredTarget].remoteness += action.requiredAmount

        case .incrementRequiredMisses:
            let damageIndex = shotDamageIndex(target: action.requiredTarget)
            guard let requiredMisses = queue[damageIndex].requiredMisses else { fatalError("Missing requiredMisses") }
            queue[damageIndex].requiredMisses = requiredMisses + action.requiredAmount

        case .ignoreLimitPerTurn:
            ignoreLimitPerTurn()

        case .incrementCardsPerTurn:
            incrementCardsPerTurn(by: action.requiredAmount)

        case .setMaxHealth, .setAlias, .discard, .steal:
            fatalError("Unexpected to dispatch \(name)")
        }
    }

    subscript(player id: String) -> Player {
        get { players.get(id) }
        set { players[id] = newValue }
    }

    mutating func take(_ card: String, from zone: WritableKeyPath<Player, [String]>, of player: String) {
        guard self[player: player][keyPath: zone].contains(card) else {
            fatalError("Card \(card) not in \(zone) of \(player)")
        }

        self[player: player][keyPath: zone].removeAll { $0 == card }
    }

    mutating func putInPlay(_ card: String, from player: String, to target: String) throws(GameFeature.Error) {
        let cardName = Card.name(of: card)
        guard self[player: target].inPlay.allSatisfy({ Card.name(of: $0) != cardName }) else {
            throw .cardAlreadyInPlay(cardName, player: target)
        }

        self[player: player].hand.removeAll { $0 == card }
        self[player: target].inPlay.append(card)
    }

    mutating func preparePlay(_ action: GameFeature.Action) throws(GameFeature.Error) {
        let alias = self.alias(for: Card.name(of: action.sourceCard), player: action.sourcePlayer, action: .play, on: .prePlayed)
        let cardName = alias ?? Card.name(of: action.sourceCard)
        let effects = cards.get(cardName).effects.filter { $0.trigger == .prePlayed }
        guard effects.isNotEmpty else {
            throw .cardNotPlayable(cardName)
        }

        queue.insert(
            contentsOf: effects.map {
                $0.toInstance(withPlayer: action.sourcePlayer, playedCard: action.sourceCard, triggeredBy: [action], alias: alias)
            },
            at: 0
        )
    }

    mutating func play(_ action: GameFeature.Action) {
        let card = action.sourceCard
        self[player: action.sourcePlayer].hand.removeAll { $0 == card }
        discard.insert(card, at: 0)

        let cardName = action.alias ?? Card.name(of: card)
        queue.insert(
            contentsOf: cards.get(cardName).effects
                .filter { $0.trigger == .played }
                .map { $0.toInstance(withPlayer: action.sourcePlayer, playedCard: card, triggeredBy: [action]) },
            at: 0
        )
    }

    mutating func drawDiscovered(_ card: String, player: String) {
        guard let discoverIndex = discovered.firstIndex(of: card) else { fatalError("Card \(card) not discovered") }
        guard let deckIndex = deck.firstIndex(of: card) else { fatalError("Card \(card) not in deck") }

        deck.remove(at: deckIndex)
        discovered.remove(at: discoverIndex)
        self[player: player].hand.append(card)
    }

    mutating func heal(_ amount: Int, player: String) throws(GameFeature.Error) {
        let maxHealth = self[player: player].maxHealth
        guard self[player: player].health < maxHealth else {
            throw .playerAlreadyMaxHealth(player)
        }

        self[player: player].health = min(self[player: player].health + amount, maxHealth)
    }

    mutating func choose(_ action: GameFeature.Action) {
        guard let selection = action.selection else { fatalError("Missing selection") }
        guard let nextAction = queue.first,
              let selector = nextAction.selectors.first,
              case .choose(let element, let status) = selector,
              case .prompted(let prompt) = status,
              prompt.options.map(\.label).contains(selection) else {
            fatalError("Missing pending choice")
        }

        queue[0].selectors[0] = .choose(element, status: .selected(selection, prompt))
    }

    mutating func counterShot(target: String) {
        let damageIndex = shotDamageIndex(target: target)
        guard let requiredMisses = queue[damageIndex].requiredMisses else { fatalError("Missing requiredMisses") }

        if requiredMisses > 1 {
            queue[damageIndex].requiredMisses = requiredMisses - 1
            return
        }

        // remove all effects triggered by shoot on targetedPlayer
        queue.removeAll {
            $0.triggeredBy.first?.name == .shoot && $0.triggeredBy.first?.targetedPlayer == target
        }
    }

    mutating func ignoreLimitPerTurn() {
        guard let playIndex = queue.firstIndex(where: { $0.name == .play }) else { fatalError("Missing play action") }

        queue[playIndex].selectors.removeAll { if case .require(.playLimit) = $0 { true } else { false } }
    }

    mutating func incrementCardsPerTurn(by amount: Int) {
        guard let actionIndex = queue.firstIndex(where: { $0.name == .drawDeck && $0.triggeredBy.first?.name == .startTurn }) else {
            fatalError("Missing drawDeck action")
        }

        let selectors = queue[actionIndex].selectors
        guard let repeatIndex = selectors.firstIndex(where: { if case .repeat = $0 { true } else { false } }),
              case .repeat(.times(let value)) = selectors[repeatIndex] else {
            fatalError("Missing repeat count")
        }

        queue[actionIndex].selectors[repeatIndex] = .repeat(.times(value + amount))
    }

    /// Draw the top card from the deck
    /// As soon as the draw pile is empty,
    /// shuffle the discard pile to create a new playing deck.
    mutating func popDeck() throws(GameFeature.Error) -> String {
        if deck.isEmpty {
            try resetDeck()
        }

        return deck.remove(at: 0)
    }

    mutating func resetDeck() throws(GameFeature.Error) {
        let minDiscardedCards = 2
        guard discard.count >= minDiscardedCards else {
            throw .insufficientDeck
        }

        let cards = discard
        discard = Array(cards.prefix(1))
        deck.append(contentsOf: Array(cards.dropFirst()))
    }

    mutating func popDiscard() throws(GameFeature.Error) -> String {
        if discard.isEmpty {
            throw .insufficientDiscard
        }

        return discard.remove(at: 0)
    }
}
