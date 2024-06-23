//
//  AppAction.swift
//  
//
//  Created by Stephano Hugues TELOLAHY on 23/06/2024.
//

import Redux

public enum AppAction: Action {
    case navigate(Screen)
    case close
    case startGame
    case exitGame
}
