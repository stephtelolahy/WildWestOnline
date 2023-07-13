//
//  GameReducer.swift
//  
//
//  Created by Hugues Telolahy on 09/04/2023.
//
import Redux

public struct GameReducer: ReducerProtocol {

    public init() {}

    public func reduce(state: GameState, action: GameAction) -> GameState {
        guard state.isOver == nil else {
            return state
        }

        var state = state

        do {
            state = try prepare(action: action, state: state)
            state = try action.reduce(state: state)
            state.event = action
            state = queueTriggered(action: action, state: state)
        } catch {
            guard let gameError = error as? GameError else {
                fatalError("Invalid error type")
            }
            state.event = .error(gameError)
        }

        return state
    }
}

private extension GameReducer {

    func prepare(action: GameAction, state: GameState) throws -> GameState {
        var state = state

        if let chooseOne = state.chooseOne {
            guard chooseOne.options.values.contains(action) else {
                throw GameError.unwaitedAction
            }
            state.chooseOne = nil
        } else if let active = state.active {
            guard case let .play(card, actor) = action,
                  active.player == actor,
                  active.cards.contains(card) else {
                throw GameError.unwaitedAction
            }
            state.active = nil
        } else if state.queue.first == action {
            state.queue.removeFirst()
        } else if case .play = action {
            _ = try action.validate(state: state)
        }

        return state
    }

    func queueTriggered(action: GameAction, state: GameState) -> GameState {
        var state = state
        var players = state.playOrder
        if case let .eliminate(justEliminated) = state.event {
            players.append(justEliminated)
        }
        
        var triggered: [GameAction] = []
        for actor in players {
            let actorObj = state.player(actor)
            for card in (actorObj.inPlay.cards + actorObj.abilities + state.abilities) {
                if let triggeredAction = triggeredAction(by: card, actor: actor, state: state) {
                    triggered.append(triggeredAction)
                }
            }
        }
        state.queue.insert(contentsOf: triggered, at: 0)
        return state
    }

    func triggeredAction(by card: String, actor: String, state: GameState) -> GameAction? {
        let cardName = card.extractName()
        guard let cardObj = state.cardRef[cardName] else {
            #warning("No cardRef matching")
            return nil
        }
        
        for action in cardObj.actions {
            do {
                let ctx: EffectContext = [.actor: actor, .card: card]
                let eventMatched = try action.eventReq.match(state: state, ctx: ctx)
                if eventMatched {
                    let sideEffect = action.effect
                    let gameAction = GameAction.resolve(sideEffect, ctx: ctx)
                    try gameAction.validate(state: state)
                    
                    return gameAction
                }
            } catch {
                return nil
            }
        }
        return nil
    }
}
