//
//  Game+CardGame.swift
//  
//
//  Created by Hugues Telolahy on 03/03/2023.
//
import GameDSL

extension Game: CardGame {

    var isOver: Bool {
        attr.getValue(for: IsOver.self) ?? false
    }

    var event: Result<Event, Error>? {
        get {
            attr.getValue(for: LastEvent.self)
        }
        set {
            if let newValue {
                attr.setValue(LastEvent(newValue))
            } else {
                attr.removeValue(for: LastEvent.self)
            }
        }
    }
}
