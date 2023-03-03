//
//  LastEvent.swift
//  
//
//  Created by Hugues Telolahy on 03/03/2023.
//
import GameDSL

public struct LastEvent: Attribute {
    public let name: String = "event"
    public let value: Result<Event, Error>

    public init(_ value: Result<Event, Error>) {
        self.value = value
    }
}
