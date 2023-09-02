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
    @EnvironmentObject private var store: Store<AppState, AppAction>

    private var state: GamePlay.State? {
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
                    store.dispatch(.dismissScreen(.game))
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
    private static var previewStore: Store<AppState, AppAction> = {
        let state = GamePlay.State(
            players: [
                Player("p1").name("willyTheKid"),
                Player("p2").name("bartCassidy")
            ],
            message: "Your turn"
        )

        return Store<AppState, AppAction>(
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
