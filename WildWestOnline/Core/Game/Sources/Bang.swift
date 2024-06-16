//
//  Bang.swift
//
//
//  Created by Stephano Hugues TELOLAHY on 15/06/2024.
//
// swiftlint:disable nesting

enum Bang {
    enum Player {
        struct State {
            let maxHealth: Int
            var health: Int
            var attributes: [String: Int]
        }
        enum Action {
            case heal(Int)
            case damage(Int)
            case setAttribute(String, value: Int)
            case removeAttribute(String)
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

    enum PossibleMoves {
        struct State {
            var active: [String: [String]]
            var chooseOne: [String: [String]]
        }
        enum Action {
            case activate([String], player: String)
            case removeActivate(player: String)
            case chooseOne([String], player: String)
            case removeChooseOne(player: String)
        }
    }

    enum Game {
        struct State {
            var players: [String: Player]
            let startOrder: [String]
            var playOrder: [String]
            var winner: String?
            var turn: String?
            var playedThisTurn: [String: Int]
        }
        enum Action {
            case startTurn(String)
            case endTurn
            case eliminate(player: String)
            case finish(winner: String)
        }
    }

    enum Sequence {
        struct State {
            var queue: [Any]
        }
        enum Action {
            case play(String, player: String)
            case choose(String, player: String)
            case cancel(Any)
            case counterShoot(Any)
            case resolve(Any)
            case push([Any])
        }
    }
}
