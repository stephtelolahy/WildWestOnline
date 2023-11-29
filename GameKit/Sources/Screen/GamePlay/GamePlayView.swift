//
//  GamePlayView.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 02/04/2023.
//
// swiftlint:disable no_magic_numbers prefixed_toplevel_constant

import Game
import Redux
import SwiftUI

struct GamePlayView: View {
    @EnvironmentObject private var store: Store<AppState>

    private var state: GamePlayState {
        GamePlayState.from(globalState: store.state)
    }

    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                Button {
                    withAnimation {
                        store.dispatch(AppAction.dismissScreen(.game))
                    }
                } label: {
                    HStack {
                        Image(systemName: "hand.point.left.fill")
                        Text("game.quit.button", bundle: .module)
                    }
                    .foregroundColor(.accentColor)
                }
                .padding()
                List {
                    Section {
                        ForEach(state.players) {
                            PlayerView(player: $0)
                        }
                    }
                }
                Text(String(format: String(localized: "game.message", bundle: .module), state.message ?? ""))
                    .font(.subheadline)
                    .padding()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .overlay(alignment: .bottomTrailing) {
            floatingButton
        }
    }

    private var floatingButton: some View {
        Button {
            let sheriff = state.players[0].id
            let action = GameAction.setTurn(sheriff)
            store.dispatch(action)
        } label: {
            Image(systemName: "gamecontroller")
                .font(.title.weight(.semibold))
                .padding()
                .background(Color.accentColor)
                .foregroundStyle(.white)
                .clipShape(Circle())
        }
        .padding(.bottom, 60)
    }
}

#Preview {
    GamePlayView()
        .environmentObject(previewStore)
}

private let previewStore: Store<AppState> = {
    let game = GameState.makeBuilder()
        .withPlayer("p1") {
            $0.withFigure(.willyTheKid)
                .withHealth(1)
        }
        .withPlayer("p2") {
            $0.withFigure(.bartCassidy)
                .withHealth(3)
        }
        .build()
    let state = GamePlayState(gameState: game)
    return Store<AppState>(
        initial: AppState(screens: [.game(state)]),
        reducer: { state, _ in state },
        middlewares: []
    )
}()
