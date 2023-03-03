//
//  MockEvent.swift
//  
//
//  Created by Hugues Telolahy on 03/03/2023.
//
import GameDSL

struct MockEvent: Event {
    func resolve(_ ctx: Game) -> Result<EventOutput, Error> {
        .success(EventOutput(state: ctx))
    }
}
