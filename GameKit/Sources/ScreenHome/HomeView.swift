//
//  HomeView.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 02/04/2023.
//
// swiftlint:disable no_magic_numbers type_contents_order

import Redux
import Routing
import SwiftUI

public struct HomeView: View {
    @StateObject private var store: Store<HomeState>

    public init(store: @escaping () -> Store<HomeState>) {
        // SwiftUI ensures that the following initialization uses the
        // closure only once during the lifetime of the view, so
        // later changes to the view's name input have no effect.
        _store = StateObject(wrappedValue: store())
    }

    public var body: some View {
        VStack(alignment: .center, spacing: 32) {
            Image(systemName: "gamecontroller")
                .font(.system(size: 100))
            roundedButton("menu.start.button") {
                withAnimation {
                    store.dispatch(NavAction.showScreen(.game))
                }
            }
            roundedButton("menu.settings.button") {
                withAnimation {
                    store.dispatch(NavAction.showScreen(.settings))
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func roundedButton(_ titleKey: String.LocalizationValue, action: @escaping () -> Void) -> some View {
        Button(String(localized: titleKey, bundle: .module), action: action)
        .font(.headline)
        .padding()
        .foregroundStyle(.primary)
        .background(Color.accentColor)
        .clipShape(.rect(cornerRadius: 40))
    }
}

#Preview {
    HomeView {
        Store<HomeState>(initial: .init())
    }
    .environment(\.locale, .init(identifier: "fr"))
}
