//
//  CoordinatorView.swift
//  WildWestOnline
//
//  Created by Stephano Hugues TELOLAHY on 07/09/2024.
//
import Redux
import AppCore
import GameCore
import NavigationCore
import SettingsCore
import SplashUI
import HomeUI
import GameUI
import SettingsUI
import SwiftUI

/// CoordinatorView is a SwiftUI view that will be set as the entry point of the application.
/// This view will connect the navigation state with NavigationStack
struct CoordinatorView: View {
    @StateObject private var store: Store<AppState, Any>

    public init(store: @escaping () -> Store<AppState, Any>) {
        // SwiftUI ensures that the following initialization uses the
        // closure only once during the lifetime of the view.
        _store = StateObject(wrappedValue: store())
    }

    var body: some View {
        NavigationStack(path: Binding<[Page]>(
            get: { store.state.navigation.path },
            set: { _ in }
        )) {
            EmptyView()
                .navigationDestination(for: Page.self) { page in
                    build(page: page)
                        .navigationBarHidden(true)
                }
                .sheet(item: Binding<Sheet?>(
                    get: { store.state.navigation.sheet },
                    set: { _ in }
                )) { sheet in
                    build(sheet: sheet)
                }
        }
        .foregroundColor(.primary)
    }
}

private extension CoordinatorView {
    @ViewBuilder
    func build(page: Page) -> some View {
        switch page {
        case .splash:
            SplashView {
                store.projection(SplashView.deriveState, SplashView.embedAction)
            }

        case .home:
            HomeView {
                store.projection(HomeView.deriveState, HomeView.embedAction)
            }

        case .game:
            GameView {
                store.projection(GameView.deriveState, GameView.embedAction)
            }
        }
    }

    @ViewBuilder
    func build(sheet: Sheet) -> some View {
        switch sheet {
        case .settings:
            SettingsView {
                store.projection(SettingsView.deriveState, SettingsView.embedAction)
            }
        }
    }
}

#Preview {
    CoordinatorView {
        Store(initial: .preview)
    }
}

private extension AppState {
    static var preview: Self {
        .init(
            navigation: .init(path: [.home]),
            settings: SettingsState.makeBuilder().build(),
            inventory: Inventory.makeBuilder().build()
        )
    }
}
