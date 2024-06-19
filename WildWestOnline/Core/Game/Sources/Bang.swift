//
//  Bang.swift
//
//
//  Created by Stephano Hugues TELOLAHY on 15/06/2024.
//
// swiftlint:disable nesting

enum Bang {

    enum Game {
        struct State {
            var players: Players.State
            var cardLocation: CardLocation.State
            var playOrder: PlayOrder.State
            var possibleMoves: PossibleMoves.State
            var effect: Effect.State

            var winner: String?
        }
        enum Action {
            case players(Players.Action)
            case cardLocation(CardLocation.Action)
            case playOrder(PlayOrder.Action)
            case possibleMoves(PossibleMoves.Action)
            case effect(Effect.Action)

            case setGameOver(winner: String)
            case play(String, player: String)
            case choose(String, player: String)
        }
    }

    enum Players {
        struct State {
            var health: [String: Int]
            var attributes: [String: [String: Int]]
        }
        enum Action {
            case heal(Int, player: String)
            case damage(Int, player: String)
            case setAttribute(String, value: Int, player: String)
            case removeAttribute(String, player: String)
        }
    }

    enum CardLocation {
        struct State {
            var deck: [String]
            var discard: [String]
            var arena: [String]
            var hand: [String: [String]]
            var inPlay: [String: [String]]
        }
        enum Action {
            case drawDeck(player: String)
            case drawHand(String, target: String, player: String)
            case drawInPlay(String, target: String, player: String)
            case drawArena(String, player: String)
            case drawDiscard(player: String)
            case discardHand(String, player: String)
            case discardInPlay(String, player: String)
            case discardPlayed(String, player: String)
            case equip(String, player: String)
            case handicap(String, target: String, player: String)
            case passInPlay(String, target: String, player: String)
            case putBack(String, player: String)
            case discover
            case draw
            case revealHand(String, player: String)
        }
    }

    enum PlayOrder {
        struct State {
            let startOrder: [String]
            var playOrder: [String]
            var turn: String?
        }
        enum Action {
            case startTurn(player: String)
            case endTurn(player: String)
            case eliminate(player: String)
        }
    }

    enum PossibleMoves {
        struct State {
            var active: [String: [String]]
            var chooseOne: [String: [String]]
        }
        enum Action {
            case activate([String], player: String)
            case chooseOne([String], player: String)
            case deactivate(player: String)
        }
    }

    enum Effect {
        struct State {
            var queue: [Any]
        }
        enum Action {
            case resolve(Any)
            case cancel(Any)
            case group([Any])
            case counterShoot(Any)
        }
    }
}

/*
 var playedThisTurn: [String: Int]
 var event: GameAction?
 var error: GameError?
 var playMode: [String: PlayMode]
 let cards: [String: Card]
 var waitDelayMilliseconds: Int
 */
