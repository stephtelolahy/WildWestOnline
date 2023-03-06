//
//  EffectEmitError.swift
//  
//
//  Created by Hugues Telolahy on 10/01/2023.
//
import GameCore
import GameUtils

public struct EffectEmitError: Event, Equatable {
    @EquatableCast var error: Error
    @EquatableIgnore public var eventCtx: EventContext = EventContextImpl()

    public init(error: Error) {
        self.error = error
    }

    public func resolve(_ ctx: Game) -> Result<EventOutput, Error> {
        .failure(error)
    }
}
