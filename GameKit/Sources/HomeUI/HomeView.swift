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
        VStack(spacing: 48) {
            Spacer()
            VStack(spacing: 32) {
                VStack {
                    Text("menu.game.title", bundle: .module)
                        .font(.subheadline)
                        .foregroundStyle(.primary)
                    Image("logo", bundle: .module)
                        .resizable()
                        .frame(width: 200, height: 200)
                }
                VStack(spacing: 16) {
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
            }
            Spacer()
            VStack(spacing: 8) {
                Text("splash.developer.name", bundle: .module)
                    .font(.subheadline)
                    .foregroundStyle(.primary)
                Text("splash.developer.email", bundle: .module)
                    .font(.subheadline)
                    .foregroundStyle(.primary.opacity(0.4))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.appBackground)
    }

    private func roundedButton(_ titleKey: String.LocalizationValue, action: @escaping () -> Void) -> some View {
        Button(String(localized: titleKey, bundle: .module), action: action)
            .font(.headline)
            .padding(12)
            .foregroundStyle(.primary)
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .stroke(Color.buttonColor, lineWidth: 4)
            )

    }
}

#Preview {
    HomeView {
        Store<HomeState>(initial: .init())
    }
}


extension Image {
    init(packageResource name: String, ofType type: String) {
        #if canImport(UIKit)
        guard let path = Bundle.module.path(forResource: name, ofType: type),
              let image = UIImage(contentsOfFile: path) else {
            self.init(name)
            return
        }
        self.init(uiImage: image)
        #elseif canImport(AppKit)
        guard let path = Bundle.module.path(forResource: name, ofType: type),
              let image = NSImage(contentsOfFile: path) else {
            self.init(name)
            return
        }
        self.init(nsImage: image)
        #else
        self.init(name)
        #endif
    }
}
