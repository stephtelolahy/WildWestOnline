//
//  SettingsRootViewBuilder.swift
//  WildWestOnline
//
//  Created by Hugues Stephano TELOLAHY on 19/09/2024.
//

import SwiftUI
import Redux
import AppCore

public struct SettingsRootViewBuilder: View {
    @EnvironmentObject private var store: Store<AppState>

    public init() {}

    public var body: some View {
        SettingsHomeView {
            store.projection(SettingsHomeView.presenter)
        }
    }
}

extension SettingsHomeView {
    static let presenter: Presenter<AppState, State> = { state in
            .init(
                playersCount: state.settings.playersCount,
                speedIndex: SettingsHomeView.State.indexOfSpeed(state.settings.waitDelayMilliseconds),
                simulation: state.settings.simulation,
                preferredFigure: state.settings.preferredFigure
            )
    }
}

private extension SettingsHomeView.State {
    static func indexOfSpeed(_ delayMilliseconds: Int) -> Int {
        SpeedOption.all.firstIndex { $0.value == delayMilliseconds } ?? 0
    }
}
