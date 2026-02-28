//
//  SettingsAbilitiesView.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 28/02/2026.
//
import SwiftUI
import Redux

struct SettingsAbilitiesView: View {
    typealias ViewStore = Store<SettingsAbilitiesFeature.State, SettingsAbilitiesFeature.Action>

    @StateObject private var store: ViewStore

    init(store: @escaping () -> ViewStore) {
        // SwiftUI ensures that the following initialization uses the
        // closure only once during the lifetime of the view.
        _store = StateObject(wrappedValue: store())
    }

    var body: some View {
        List {
            ForEach(store.state.cards, id: \.name) { card in
                rowView(card: card)
            }
        }
        .scrollContentBackground(.hidden)
        .navigationTitle("Abilities")
        .task {
            await store.dispatch(.didAppear)
        }
    }

    func rowView(card: SettingsAbilitiesFeature.State.Card) -> some View {
        HStack(alignment: .top) {
            Image(systemName: "circle.square")
                .resizable()
                .scaledToFit()
                .frame(width: 67, height: 100)

            VStack(alignment: .leading) {
                Text(card.name.uppercased())
                    .bold()
                Text(card.description)
            }
        }
        .foregroundStyle(.foreground)
    }
}

#Preview {
    NavigationStack {
        SettingsAbilitiesView {
            .init(
                initialState: .init(
                    cards: [
                        .init(
                            name: "ability-1",
                            description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry"
                        ),
                        .init(
                            name: "ability-2",
                            description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry"
                        ),
                        .init(
                            name: "ability-3",
                            description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry"
                        )
                    ]
                )
            )
        }
    }
}
