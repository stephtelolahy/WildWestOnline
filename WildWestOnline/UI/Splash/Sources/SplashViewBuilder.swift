//
//  SwiftUIView.swift
//  WildWestOnline
//
//  Created by Hugues Stephano TELOLAHY on 19/09/2024.
//

import SwiftUI
import Redux
import AppCore

public struct SplashViewBuilder: View {
    @EnvironmentObject private var store: Store<AppState>

    public init() {}

    public var body: some View {
        SplashView {
            store.projection(SplashView.presenter)
        }
    }
}

extension SplashView {
    static let presenter: Presenter<AppState, State> = { _ in
            .init()
    }
}
