//
//  GamePlayView.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 02/04/2023.
//

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
                    .foregroundColor(.accentColor)
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
            Image(systemName: "plus")
                .font(.title.weight(.semibold))
                .padding()
                .background(Color.accentColor)
                .foregroundStyle(.white)
                .clipShape(Circle())
        }
        .padding()
    }
}

#Preview {
    GamePlayView()
        .environmentObject(gamePreviewStore)
}

private var gamePreviewStore: Store<AppState> = {
    let game = GameState.makeBuilder()
        .withPlayer("p1") {
            $0.withFigure(.willyTheKid)
        }
        .withPlayer("p2") {
            $0.withFigure(.bartCassidy)
        }
        .build()
    let state = GamePlayState(
        gameState: game,
        message: "Your turn"
    )

    return Store<AppState>(
        initial: AppState(screens: [.game(state)]),
        reducer: { state, _ in state },
        middlewares: []
    )
}()
