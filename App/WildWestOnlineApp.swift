//
//  WildWestOnlineApp.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 02/04/2023.
//
import AppCore
import CardsData
import GameCore
import GameUI
import HomeUI
import Redux
import SettingsUI
import SettingsCore
import SettingsData
import SplashUI
import SwiftUI
import Theme

@main
struct WildWestOnlineApp: App {
    @Environment(\.theme) private var theme

    var body: some Scene {
        WindowGroup {
            ContentView {
                createStore()
            }
            .environment(\.colorScheme, .light)
            .accentColor(theme.accentColor)
        }
    }
}

struct ContentView: View {
    @StateObject private var store: Store<AppState, Any>

    public init(store: @escaping () -> Store<AppState, Any>) {
        // SwiftUI ensures that the following initialization uses the
        // closure only once during the lifetime of the view.
        _store = StateObject(wrappedValue: store())
    }

    var body: some View {
        Group {
            switch store.state.screens.last {
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

            default:
                EmptyView()
            }
        }
        .sheet(isPresented: Binding<Bool>(
            get: { store.state.screens.last == .settings },
            set: { _ in }
        ), onDismiss: {
        }, content: {
            SettingsView {
                store.projection(SettingsView.deriveState, SettingsView.embedAction)
            }
        })
        .foregroundColor(.primary)
    }
}

#Preview {
    ContentView {
        Store(initial: .preview)
    }
}

private extension AppState {
    static var preview: Self {
        .init(
            screens: [.home],
            settings: SettingsState.makeBuilder().build(),
            inventory: Inventory.makeBuilder().build()
        )
    }
}

private func createStore() -> Store<AppState, Any> {
    let settingsService = SettingsRepository()
    let cardsService = CardsRepository()

    let settings = SettingsState.makeBuilder()
        .withPlayersCount(settingsService.playersCount())
        .withWaitDelayMilliseconds(settingsService.waitDelayMilliseconds())
        .withSimulation(settingsService.isSimulationEnabled())
        .withPreferredFigure(settingsService.preferredFigure())
        .build()

    let initialState = AppState(
        screens: [.splash],
        settings: settings,
        inventory: cardsService.inventory
    )

    return Store<AppState, Any>(
        initial: initialState,
        reducer: AppState.reducer,
        middlewares: [
            Middlewares.lift(
                Middlewares.updateGame(),
                deriveState: { $0.game },
                deriveAction: { $0 as? GameAction },
                embedAction: { action, _ in action }
            ),
            Middlewares.lift(
                Middlewares.saveSettings(with: settingsService),
                deriveState: { $0.settings },
                deriveAction: { $0 as? SettingsAction },
                embedAction: { action, _ in action }
            ),
            Middlewares.logger()
        ]
    )
}
