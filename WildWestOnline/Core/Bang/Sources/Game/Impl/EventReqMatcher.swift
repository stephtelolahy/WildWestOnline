//
//  EventReqMatcher.swift
//  WildWestOnline
//
//  Created by Stephano Hugues TELOLAHY on 11/11/2024.
//

extension EventReq {
    func match(_ ctx: MatchingContext, state: GameState) -> Bool {
        matcher.match(ctx, state: state)
    }

    struct MatchingContext {
        let event: GameAction
        let card: String
        let actor: String
    }
}

private extension EventReq {
    protocol Matcher {
        func match(_ ctx: MatchingContext, state: GameState) -> Bool
    }

    var matcher: Matcher {
        switch self {
        case .turnEnded: TurnEnded()
        }
    }

    struct TurnEnded: Matcher {
        func match(_ ctx: MatchingContext, state: GameState) -> Bool {
            ctx.event.kind == .endTurn
            && ctx.event.payload.target == ctx.actor
        }
    }
}
