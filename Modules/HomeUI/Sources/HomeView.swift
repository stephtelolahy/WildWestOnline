//
//  HomeView.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 02/04/2023.
//

import SwiftUI
import Theme

public struct HomeView: View {
    @StateObject private var store: ViewStore

    @Environment(\.theme) private var theme

    public init(store: @escaping () -> ViewStore) {
        // SwiftUI ensures that the following initialization uses the
        // closure only once during the lifetime of the view.
        _store = StateObject(wrappedValue: store())
    }

    public var body: some View {
        ZStack {
            theme.colorBackground.ignoresSafeArea()
            VStack {
                Spacer()
                contentView
                Spacer()
                footerView
            }
        }
#if os(iOS)
        .navigationBarHidden(true)
#endif
    }

    private var contentView: some View {
        VStack {
            VStack {
                Text(.menuGameTitle)
                    .font(theme.fontHeadline)
                    .foregroundStyle(.primary)
                Image(.logo)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 140, height: 140)
                    .shadow(color: .black.opacity(0.25), radius: 12, x: 0, y: 6)
                    .modifier(BreathingEffect())
            }
            VStack(spacing: 8) {
                mainButton("menu.play.button") {
                    Task {
                        await store.dispatch(.start)
                    }
                }
                mainButton("menu.settings.button") {
                    Task {
                        await store.dispatch(.navigation(.presentSettingsSheet))
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
                .font(theme.fontTitle)
                .padding(8)
        }
    }

    private var footerView: some View {
        VStack {
            Text(.menuDeveloperName)
                .font(theme.fontHeadline)
                .foregroundStyle(.primary)
            Text(.menuDeveloperEmail)
                .font(theme.fontHeadline)
                .foregroundStyle(.primary.opacity(0.4))
        }
    }
}

// MARK: - Helpers

private struct BreathingEffect: ViewModifier {
    @State private var scale: CGFloat = 1.0

    func body(content: Content) -> some View {
        content
            .scaleEffect(scale)
            .onAppear {
                withAnimation(.easeInOut(duration: 2.2).repeatForever(autoreverses: true)) {
                    scale = 1.1
                }
            }
    }
}

#Preview {
    HomeView {
        .init(initialState: .init(), dependencies: ())
    }
}
