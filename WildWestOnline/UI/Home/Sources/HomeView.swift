//
//  HomeView.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 02/04/2023.
//
// swiftlint:disable no_magic_numbers type_contents_order

import Redux
import SwiftUI
import Theme

public struct HomeView: View {
    @Environment(\.theme) private var theme
    @StateObject private var store: Store<State, Action>

    public init(store: @escaping () -> Store<State, Action>) {
        // SwiftUI ensures that the following initialization uses the
        // closure only once during the lifetime of the view.
        _store = StateObject(wrappedValue: store())
    }

    public var body: some View {
        NavigationView {
            ZStack {
                theme.backgroundView.edgesIgnoringSafeArea(.all)
                VStack {
                    Spacer()
                    contentView
                    Spacer()
                    footerView
                }
            }
        }
    }

    private var contentView: some View {
        VStack {
            VStack {
                Text("menu.game.title", bundle: .module)
                    .font(.subheadline)
                    .foregroundStyle(.primary)
                Image(.logo)
                    .resizable()
                    .frame(width: 120, height: 120)
            }
            VStack(spacing: 8) {
                mainButton("menu.play.button") {
                    withAnimation {
                        store.dispatch(.didTapPlayButton)
                    }
                }
                mainButton("menu.settings.button") {
                    withAnimation {
                        store.dispatch(.didTapSettingsButton)
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
                .foregroundColor(.accentColor)
        }.symbolRenderingMode(.multicolor)
    }

    private var footerView: some View {
        VStack {
            Text("splash.developer.name", bundle: .module)
                .font(.footnote)
                .foregroundStyle(.primary)
            Text("splash.developer.email", bundle: .module)
                .font(.footnote)
                .foregroundStyle(.primary.opacity(0.4))
        }
    }
}

#Preview {
    HomeView {
        .init(initial: .init())
    }
}
