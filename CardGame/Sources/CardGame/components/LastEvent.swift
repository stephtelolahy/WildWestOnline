//
//  LastEvent.swift
//  
//
//  Created by Hugues Telolahy on 03/03/2023.
//
import GameDSL

public struct LastEvent: Attribute {
    public let name: String = "event"
    let event: Result<Event, Error>?

    public init(event: Result<Event, Error>?) {
        self.event = event
    }
}
