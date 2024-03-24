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
    @StateObject private var store: Store<State>

    public init(store: @escaping () -> Store<State>) {
        // SwiftUI ensures that the following initialization uses the
        // closure only once during the lifetime of the view.
        _store = StateObject(wrappedValue: store())
    }

    public var body: some View {
        VStack {
            headerView
            Spacer()
            contentView
            Spacer()
            footerView
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppColor.background)
    }

    private var headerView: some View {
        HStack {
            Spacer()
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

    private var contentView: some View {
        VStack {
            VStack {
                Text("menu.game.title", bundle: .module)
                    .font(.subheadline)
                    .foregroundStyle(.primary)
                Image("logo", bundle: .module)
                    .resizable()
                    .frame(width: 200, height: 200)
            }
            VStack(spacing: 16) {
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
                .padding(12)
                .frame(minWidth: 0, maxWidth: 200)
                .foregroundStyle(.primary)
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(Color.accentColor, lineWidth: 4)
                )
        }
    }

    private var footerView: some View {
        VStack(spacing: 8) {
            Text("splash.developer.name", bundle: .module)
                .font(.subheadline)
                .foregroundStyle(.primary)
            Text("splash.developer.email", bundle: .module)
                .font(.subheadline)
                .foregroundStyle(.primary.opacity(0.4))
        }
    }
}

#Preview {
    HomeView {
        Store(initial: .init())
    }
}
