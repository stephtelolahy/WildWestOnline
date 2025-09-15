//
//  HomeView.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 02/04/2023.
//

import SwiftUI
import Theme
import Redux
import AppCore
import NavigationCore

public struct HomeView: View {
    public struct ViewState: Equatable {}

    @Environment(\.theme) private var theme
    @StateObject private var store: Store<ViewState, Void>

    public init(store: @escaping () -> Store<ViewState, Void>) {
        // SwiftUI ensures that the following initialization uses the
        // closure only once during the lifetime of the view.
        _store = StateObject(wrappedValue: store())
    }

    public var body: some View {
        ZStack {
            theme.colorBackground.edgesIgnoringSafeArea(.all)
            VStack {
                Spacer()
                contentView
                Spacer()
                footerView
            }
        }
        .navigationBarHidden(true)
    }

    private var contentView: some View {
        VStack {
            VStack {
                Text(.menuGameTitle)
                    .font(.subheadline)
                    .foregroundStyle(.primary)
                Image(.logo)
                    .resizable()
                    .frame(width: 120, height: 120)
            }
            VStack(spacing: 8) {
                mainButton("menu.play.button") {
                    Task {
                        await store.dispatch(GameSessionFeature.Action.start)
                    }
                }
                mainButton("menu.settings.button") {
                    Task {
                        await store.dispatch(AppNavigationFeature.Action.presentSettingsSheet)
                    }
                }
            }
        }
    }

    private func mainButton(
        _ titleKey: String.LocalizationValue,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            Text(String(localized: titleKey, bundle: .module))
                .font(.headline)
                .padding(8)
        }.symbolRenderingMode(.multicolor)
    }

    private var footerView: some View {
        VStack {
            Text(.menuDeveloperName)
                .font(.footnote)
                .foregroundStyle(.primary)
            Text(.menuDeveloperEmail)
                .font(.footnote)
                .foregroundStyle(.primary.opacity(0.4))
        }
    }
}

#Preview {
    HomeView {
        .init(initialState: .init(), dependencies: ())
    }
}

public extension HomeView.ViewState {
    init?(appState: AppFeature.State) { }
}
