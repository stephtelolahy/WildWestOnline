//
//  HomeViewConnector.swift
//  
//
//  Created by Stephano Hugues TELOLAHY on 10/05/2024.
//

import AppCore
import Redux

public enum HomeViewConnector: Connector {
    public static func deriveState(_ state: AppState) -> HomeView.State? {
        .init()
    }
    
    public static func embedAction(_ action: HomeView.Action) -> AppAction {
        switch action {
        case .didTapSettingsButton:
                .navigate(.settings)
            
        case .didTapPlayButton:
                .createGame
        }
    }
}
