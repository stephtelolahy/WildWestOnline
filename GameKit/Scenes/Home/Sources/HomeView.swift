//
//  HomeView.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 02/04/2023.
//
// swiftlint:disable no_magic_numbers type_contents_order

import AppCore
import Redux
import SwiftUI
import Theme

public struct HomeView: View {
    @Environment(\.theme) private var theme
    @StateObject private var store: Store<State>

    public init(store: @escaping () -> Store<State>) {
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
            .toolbar {
                Button {
                    withAnimation {
                        store.dispatch(AppAction.present(.settings))
                    }
                } label: {
                    Image(systemName: "gearshape")
                        .foregroundColor(.accentColor)
                        .font(.title)
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
                Image("logo", bundle: .module)
                    .resizable()
                    .frame(width: 120, height: 120)
            }
            VStack(spacing: 8) {
                roundedButton("menu.play.button") {
                    withAnimation {
                        store.dispatch(AppAction.navigate(.game))
                    }
                }
                roundedButton("menu.online.button") {
                    withAnimation {
                    }
                }
            }
        }
    }

    private func roundedButton(
        _ titleKey: String.LocalizationValue,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            Text(String(localized: titleKey, bundle: .module))
                .font(.headline)
                .padding(8)
                .frame(minWidth: 0, maxWidth: 200)
                .foregroundStyle(.primary)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.accentColor, lineWidth: 4)
                )
        }
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
        Store(initial: .init())
    }
}
