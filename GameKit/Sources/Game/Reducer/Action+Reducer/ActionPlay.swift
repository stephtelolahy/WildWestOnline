//
//  ActionPlay.swift
//
//
//  Created by Hugues Telolahy on 20/05/2023.
//

struct ActionPlay: GameReducerProtocol {
    let player: String
    let card: String
    
    // swiftlint:disable:next cyclomatic_complexity function_body_length
    func reduce(state: GameState) throws -> GameState {
        // verify action
        let cardName = card.extractName()
        guard let cardObj = state.cardRef[cardName] else {
            throw GameError.cardNotPlayable(card)
        }
        
        let playRule: CardRule
        let playMode: PlayMode
        if let immediateRule = cardObj.rules.first(where: { $0.playReqs.contains(.onPlayImmediate) }) {
            playRule = immediateRule
            playMode = .immediate
        } else if let abilityRule = cardObj.rules.first(where: { $0.playReqs.contains(.onPlayAbility) }) {
            playRule = abilityRule
            playMode = .ability
        } else if let equipmentRule = cardObj.rules.first(where: { $0.playReqs.contains(.onPlayEquipment) }) {
            playRule = equipmentRule
            playMode = .equipment
        } else if let handicapRule = cardObj.rules.first(where: { $0.playReqs.contains(.onPlayHandicap) }) {
            playRule = handicapRule
            playMode = .handicap
        } else {
            throw GameError.cardNotPlayable(card)
        }
        
        let sideEffect = playRule.effect
        let ctx: EffectContext = [.actor: player, .card: card]
        
        // verify requirements
        let onPlayReqs: [PlayReq] = [.onPlayImmediate, .onPlayAbility, .onPlayHandicap, .onPlayEquipment]
        for playReq in playRule.playReqs where !onPlayReqs.contains(playReq) {
            try playReq.match(state: state, ctx: ctx)
        }
        
        // resolve target
        if case let .target(requiredTarget, _) = sideEffect {
            let resolvedTarget = try requiredTarget.resolve(state: state, ctx: ctx)
            if case let .selectable(pIds) = resolvedTarget {
                var state = state
                let options = pIds.reduce(into: [String: GameAction]()) {
                    let action: GameAction =
                    switch playMode {
                    case .immediate:
                            .playImmediate(card, target: $1, player: player)
                    case .handicap:
                            .playHandicap(card, target: $1, player: player)
                    default:
                        fatalError("unexpected")
                    }
                    
                    $0[$1] = action
                }
                let chooseOne = try GameAction.buildChooseOne(chooser: player, options: options, state: state)
                state.queue.insert(chooseOne, at: 0)
                return state
            }
        }
        
        let action: GameAction =
        switch playMode {
        case .immediate:
                .playImmediate(card, player: player)
        case .ability:
                .playAbility(card, player: player)
        case .equipment:
                .playEquipment(card, player: player)
        default:
            fatalError("unexpected")
        }
        
        // queue play action
        var state = state
        state.queue.insert(action, at: 0)
        return state
    }
}

private enum PlayMode: String {
    case immediate
    case ability
    case equipment
    case handicap
}
