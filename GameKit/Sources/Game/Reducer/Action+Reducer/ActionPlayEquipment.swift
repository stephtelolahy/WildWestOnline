//
//  ActionPlayEquipment.swift
//
//
//  Created by Hugues Telolahy on 10/06/2023.
//

struct ActionPlayEquipment: GameActionReducer {
    let player: String
    let card: String

    func reduce(state: GameState) throws -> GameState {
        // verify rule: not already inPlay
        let cardName = card.extractName()
        let playerObj = state.player(player)
        guard playerObj.inPlay.allSatisfy({ $0.extractName() != cardName }) else {
            throw GameError.cardAlreadyInPlay(cardName)
        }

        // put card on self's play
        var state = state
        state[keyPath: \GameState.players[player]]?.hand.remove(card)
        state[keyPath: \GameState.players[player]]?.inPlay.append(card)

        // save played card
        state.incrementPlayedThisTurn(for: cardName)

        // queue triggered effect
        let event = GameAction.equip(card, player: player)
        let children = PlayEffectResolver.triggeredEffect(event: event, state: state)
        state.sequence.insert(contentsOf: children, at: 0)

        return state
    }
}
