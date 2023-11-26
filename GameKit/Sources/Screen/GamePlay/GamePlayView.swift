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
            // Action
        } label: {
            // 1
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
    let state = GamePlayState(
        players: [
            Player.makeBuilder().withFigure(.willyTheKid).build(),
            Player.makeBuilder().withFigure(.bartCassidy).build()
        ],
        message: "Your turn"
    )

    return Store<AppState>(
        initial: AppState(screens: [.game(state)]),
        reducer: { state, _ in state },
        middlewares: []
    )
}()
