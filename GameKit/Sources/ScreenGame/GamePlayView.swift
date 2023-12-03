//
//  GamePlayView.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 02/04/2023.
//
// swiftlint:disable no_magic_numbers type_contents_order

import Game
import Inventory
import Redux
import Routing
import SwiftUI

public struct GamePlayView: View {
    @StateObject private var store: Store<GamePlayState>

    @State private var activeSheet = false
    @State private var activeSheetOptions: [String: GameAction] = [:]
    @State private var chooseOneAlert = false
    @State private var chooseOneAlertOptions: [String: GameAction] = [:]

    public init(store: @escaping () -> Store<GamePlayState>) {
        // SwiftUI ensures that the following initialization uses the
        // closure only once during the lifetime of the view, so
        // later changes to the view's name input have no effect.
        _store = StateObject(wrappedValue: store())
    }

    public var body: some View {
        VStack(alignment: .leading) {
            headerView
            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(store.state.players) {
                        itemPlayerButton($0)
                        Divider()
                    }
                }
                .padding()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .alert(
            "Choose one option",
            isPresented: $chooseOneAlert,
            presenting: chooseOneAlertOptions
        ) { data in
            ForEach(Array(data.keys), id: \.self) { key in
                Button(key) {
                    guard let action = data[key] else {
                        fatalError("unexpected")
                    }
                    store.dispatch(action)
                }
            }
        }
        .onAppear {
            let sheriff = store.state.gameState.playOrder[0]
            store.dispatch(GameAction.setTurn(sheriff))
        }
        .onChange(of: store.state.gameState.chooseOne) { chooseOne in
            if let chooseOne {
                chooseOneAlert = true
                chooseOneAlertOptions = chooseOne.options
            }
        }
    }

    private var headerView: some View {
        HStack {
            Button {
                withAnimation {
                    store.dispatch(NavAction.dismiss)
                }
            } label: {
                Image(systemName: "arrow.backward")
                    .foregroundColor(.accentColor)
                    .padding()
            }
            Spacer()
            Text(store.state.message)
                .font(.subheadline)
                .lineLimit(1)
                .padding()
            Spacer()
            Button {
            } label: {
                Image(systemName: "info.circle")
                    .foregroundColor(.accentColor)
                    .padding()
            }
        }
    }

    private func itemPlayerButton(_ player: PlayerItem) -> some View {
        Button(action: {
            if !player.activeActions.isEmpty {
                activeSheet = true
                activeSheetOptions = player.activeActions
            }
        }, label: {
            itemPlayerView(player)
        })
        .confirmationDialog(
            "Play a card",
            isPresented: $activeSheet,
            titleVisibility: .visible,
            presenting: activeSheetOptions
        ) { data in
            ForEach(Array(data.keys), id: \.self) { key in
                Button(key) {
                    guard let action = data[key] else {
                        fatalError("unexpected")
                    }
                    store.dispatch(action)
                }
            }
        }
    }

    private func itemPlayerView(_ player: PlayerItem) -> some View {
        ZStack {
            HStack {
                CircleImage(
                    image: Image(
                        player.imageName,
                        bundle: Bundle.module,
                        label: Text(player.imageName)
                    )
                )
                VStack(alignment: .leading) {
                    Text(player.displayName)
                        .font(.callout)
                        .lineLimit(1)
                    Text(player.equipment)
                        .font(.footnote)
                        .lineLimit(1)
                }
                Spacer()
                Text(player.status)
                    .lineLimit(1)
                    .padding(.trailing, 8)
            }

            if !player.activeActions.isEmpty {
                Image(systemName: "\(player.activeActions.count).circle.fill")
                    .foregroundColor(.accentColor)
                    .font(.headline)
            }
        }
        .background(Color.accentColor.opacity(player.highlighted ? 0.5 : 0.2))
        .clipShape(RoundedRectangle(cornerRadius: 40, style: .circular))
    }
}

#Preview {
    GamePlayView {
        Store<GamePlayState>(initial: previewState)
    }
}

private var previewState: GamePlayState {
    let game = GameState.makeBuilder()
        .withPlayer("p1") {
            $0.withFigure(.willyTheKid)
                .withHealth(1)
                .withInPlay([.saloon, .barrel])
        }
        .withPlayer("p2") {
            $0.withFigure(.bartCassidy)
                .withHealth(3)
        }
        .withActive("p1", cards: [.bang, .endTurn])
        .withChooseOne("p1", options: [.bang: GameAction.nothing])
        .build()
    return GamePlayState(gameState: game)
}
