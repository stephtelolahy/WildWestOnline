//
//  GamePlayView.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 02/04/2023.
//
// swiftlint:disable no_magic_numbers type_contents_order

import AppCore
import CardNames
import GameCore
import Redux
import SwiftUI
import Theme

public struct GamePlayView: View {
    @StateObject private var store: Store<State>
    @SwiftUI.State private var events: [String] = []

    public init(store: @escaping () -> Store<State>) {
        // SwiftUI ensures that the following initialization uses the
        // closure only once during the lifetime of the view.
        _store = StateObject(wrappedValue: store())
    }

    public var body: some View {
        VStack(alignment: .leading) {
            headerView
            ScrollView {
                VStack {
                    ForEach(store.state.visiblePlayers, id: \.id) {
                        itemPlayerView($0)
                    }
                    Divider()
                    eventsView
                    Spacer()
                    footerView
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppColor.background)
        .alert(
            "Choose one option",
            isPresented: Binding<Bool>(
                get: { store.state.chooseOneActions.isNotEmpty },
                set: { _ in }
            ),
            presenting: store.state.chooseOneActions
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
            let sheriff = store.state.visiblePlayers[0].id
            store.dispatch(GameAction.setTurn(player: sheriff))
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
                        store.dispatch(AppAction.close)
                    }
                } label: {
                    Image(systemName: "xmark.circle")
                        .foregroundColor(.accentColor)
                        .font(.title)
                }
            }
        }
    }

    private var footerView: some View {
        let data = store.state.handActions
        return TagFlowLayout(alignment: .leading) {
            ForEach(data, id: \.card) { item in
                Button("\(item.card)") {
                    guard let action = item.action else {
                        fatalError("unexpected")
                    }
                    store.dispatch(action)
                }
                .buttonStyle(.borderedProminent)
                .disabled(item.action == nil)
            }
        }
    }

    private func itemPlayerView(_ player: Self.State.PlayerItem) -> some View {
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
                Text("\(player.hand)\t\(player.health)")
                    .lineLimit(1)
                    .padding(.trailing, 8)
            }
        }
        .background(itemPlayerBackgroundColor(for: player.status))
        .clipShape(RoundedRectangle(cornerRadius: 40, style: .circular))
    }

    private var eventsView: some View {
        ScrollView {
            VStack(alignment: .leading) {
                ForEach(Array(events.enumerated()), id: \.offset) { _, event in
                    Text(event)
                        .lineLimit(1)
                }
            }
        }
    }

    private func itemPlayerBackgroundColor(for status: Self.State.PlayerItem.Status) -> Color {
        switch status {
        case .active:
            Color.white.opacity(0.6)

        case .idle:
            Color.white.opacity(0.2)

        case .eliminated:
            Color.clear
        }
    }
}

#Preview {
    GamePlayView {
        Store<GamePlayView.State>(initial: previewState)
    }
}

private var previewState: GamePlayView.State {
    .init(
        visiblePlayers: [
            .init(
                id: "p1",
                imageName: .willyTheKid,
                displayName: .willyTheKid,
                hand: "[]2",
                health: "2x",
                equipment: "SCOPE",
                status: .active
            ),
            .init(
                id: "p2",
                imageName: .bartCassidy,
                displayName: .bartCassidy,
                hand: "[]2",
                health: "0x",
                equipment: "",
                status: .eliminated
            )
        ],
        message: "P1's turn",
        chooseOneActions: [
            .missed: .play(.missed, player: "p2"),
            .bang: .play(.bang, player: "p2")
        ],
        handActions: [
            .init(card: .bang, action: .play(.bang, player: "p1")),
            .init(card: .gatling, action: .play(.gatling, player: "p1")),
            .init(card: .schofield, action: .play(.schofield, player: "p1")),
            .init(card: .mustang, action: nil),
            .init(card: .barrel, action: .play(.barrel, player: "p1")),
            .init(card: .beer, action: nil)
        ]
    )
}
