//
//  GamePlayView.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 02/04/2023.
//

import SwiftUI
import Redux
import Game

struct GamePlayView: View {
    @EnvironmentObject private var store: Store<AppState>

    private var state: GamePlayState? {
        if let lastScreen = store.state.screens.last,
           case let .game(gameState) = lastScreen {
            gameState
        } else {
            nil
        }
    }

    var body: some View {
        VStack(alignment: .leading) {
            Button {
                withAnimation {
                    store.dispatch(AppAction.dismissScreen(.game))
                }
            } label: {
                HStack {
                    Image(systemName: "hand.point.left.fill")
                    Text("Give Up")
                }
                .foregroundColor(.accentColor)
            }
            .padding()
            List {
                Section {
                    let players = state?.players ?? []
                    ForEach(players) {
                        PlayerView(player: $0)
                    }
                }
            }
            Text("Message: \(state?.message ?? "")")
                .font(.subheadline)
                .foregroundColor(.accentColor)
                .padding()
        }
        .frame(
            minWidth: 0,
            maxWidth: .infinity,
            minHeight: 0,
            maxHeight: .infinity,
            alignment: .topLeading
        )
    }
}

#if DEBUG
struct GameView_Previews: PreviewProvider {
    private static var previewStore: Store<AppState> = {
        let state = GamePlayState(
            players: [
                Player.makeBuilder().withId("willyTheKid").build(),
                Player.makeBuilder().withId("bartCassidy").build()
            ],
            message: "Your turn"
        )

        return Store<AppState>(
            initial: AppState(screens: [.game(state)]),
            reducer: { state, _ in state },
            middlewares: []
        )
    }()

    static var previews: some View {
        GamePlayView()
            .environmentObject(previewStore)
    }
}
#endif
