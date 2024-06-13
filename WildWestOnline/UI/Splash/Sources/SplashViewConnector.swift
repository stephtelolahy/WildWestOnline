//
//  SplashViewConnector.swift
//
//
//  Created by Stephano Hugues TELOLAHY on 10/05/2024.
//
import AppCore
import Redux

public enum SplashViewConnector: Connector {
    public static func deriveState(_ state: AppState) -> SplashView.State? {
        .init()
    }
    
    public static func embedAction(_ action: SplashView.Action) -> AppAction {
        switch action {
        case .didAppear:
            return AppAction.navigate(.home)
        }
    }
}
