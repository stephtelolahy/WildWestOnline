//
//  Luck.swift
//  
//
//  Created by Hugues Telolahy on 19/01/2023.
//
import Foundation
import GameRules

/// Flip over the top card of the deck, then apply effects according to suits and values
public struct Luck: Effect, Equatable {
    private let regex: String
    @EquatableIgnore private var onSuccess: [Effect]?
    @EquatableIgnore private var onFailure: [Effect]?
    @EquatableIgnore public var playCtx: PlayContext = PlayContextImpl()
    
    public init(regex: String, onSuccess: [Effect]? = nil, onFailure: [Effect]? = nil) {
        assert(!regex.isEmpty)
        
        self.regex = regex
        self.onSuccess = onSuccess
        self.onFailure = onFailure
    }
    
    public func resolve(_ ctx: Game) -> Result<EventOutput, Error> {
        var ctx = ctx
        let cardObj = ctx.removeTopDeck()
        ctx.discard.append(cardObj)
        let success = cardObj.matches(regex: regex)
        let children: [Effect]?
        if success {
            children = onSuccess?.withCtx(playCtx)
        } else {
            children = onFailure?.withCtx(playCtx)
        }
        return .success(EventOutputImpl(state: ctx, children: children))
    }
}

public enum CardRegex {
    // https://regex101.com/
    public static let successfulBarrel = "♥️"
    public static let escapeFromJail = "♥️"
    public static let passDynamite = "(♥️)|(♦️)|(♣️)|([10|J|Q|K|A]♠️)"
}

private extension Card {
    func matches(regex pattern: String) -> Bool {
        guard let value = self.value else {
            fatalError(InternalError.missingCardValue)
        }
        
        return value.matches(regex: pattern)
    }
}

private  extension String {
    func matches(regex pattern: String) -> Bool {
        guard let regex = try? NSRegularExpression(pattern: pattern) else {
            return false
        }
        
        let string = self
        let range = NSRange(location: 0, length: string.utf16.count)
        return regex.firstMatch(in: string, options: [], range: range) != nil
    }
}
