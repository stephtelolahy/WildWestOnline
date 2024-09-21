//
//  GameSetupAction.swift
//  
//
//  Created by Stephano Hugues TELOLAHY on 23/06/2024.
//

import Redux
import GameCore
import SettingsCore
import NavigationCore

public enum GameSetupAction: Action {
    case startGame
    case quitGame
    case setGame(GameState)
    case unsetGame
}
