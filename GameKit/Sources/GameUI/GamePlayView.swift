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
import Theme

public struct GamePlayView: View {
    @StateObject private var store: Store<GameState>

    public init(store: @escaping () -> Store<GameState>) {
        // SwiftUI ensures that the following initialization uses the
        // closure only once during the lifetime of the view, so
        // later changes to the view's name input have no effect.
        _store = StateObject(wrappedValue: store())
    }

    public var body: some View {
        VStack(alignment: .leading) {
            headerView
            ForEach(store.state.visiblePlayers) {
                itemPlayerView($0)
            }
            Divider()
            logView
            footerView
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppColor.background)
        .alert(
            "Choose one option",
            isPresented: Binding<Bool>(
                get: { store.state.chooseOneAlertData.isNotEmpty },
                set: { _ in }
            ),
            presenting: store.state.chooseOneAlertData
        ) { data in
            ForEach(Array(data.keys.sorted()), id: \.self) { key in
                Button(key, role: key == .pass ? .cancel : nil) {
                    guard let action = data[key] else {
                        fatalError("unexpected")
                    }
                    store.dispatch(action)
                }
            }
        }
        .onAppear {
            let sheriff = store.state.playOrder[0]
            store.dispatch(GameAction.setTurn(sheriff))
        }
    }

    private var headerView: some View {
        ZStack {
            Text(store.state.message)
                .font(.headline)
                .lineLimit(1)
                .padding()
            HStack {
                Spacer()
                Button {
                    withAnimation {
                        store.dispatch(NavAction.dismiss)
                    }
                } label: {
                    Image(systemName: "xmark.circle")
                        .foregroundColor(AppColor.button)
                        .padding()
                        .font(.title)
                }
            }
        }
    }

    private var footerView: some View {
        let data = store.state.activeActions
        return HStack {
            ForEach(Array(data.keys.sorted()), id: \.self) { key in
                Button("\(key)") {
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

            if player.activeActions.isNotEmpty {
                Image(systemName: "\(player.activeActions.count).circle.fill")
                    .foregroundColor(AppColor.button)
                    .font(.headline)
            }
        }
        .background(Color.white.opacity(player.highlighted ? 0.4 : 0.2))
        .clipShape(RoundedRectangle(cornerRadius: 40, style: .circular))
    }

    private var logView: some View {
        let logs = store.log
            .reversed()
            .map { String(describing: $0) }
        return ScrollView {
            ForEach(Array(logs.enumerated()), id: \.offset) { _, event in
                Text(event)
                    .lineLimit(1)
                    .font(.footnote)
            }
        }
    }
}

#Preview {
    GamePlayView {
        Store<GameState>(initial: previewState)
    }
}

private var previewState: GameState {
    GameState.makeBuilder()
        .withPlayer("p1") {
            $0.withFigure(.willyTheKid)
                .withHealth(1)
                .withInPlay([.saloon, .barrel])
        }
        .withPlayer("p2") {
            $0.withFigure(.bartCassidy)
                .withHealth(3)
        }
        .withActive("p1", cards: [.bang, .mustang, .barrel, .beer, .endTurn])
        .withChooseOne("p2", options: [.missed: .nothing])
        .withTurn("p1")
        .withPlayModes(["p1": .manual])
        .build()
}
