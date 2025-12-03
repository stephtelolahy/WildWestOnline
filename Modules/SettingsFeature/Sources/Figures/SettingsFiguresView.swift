//
//  SettingsFiguresView.swift
//  WildWestOnline
//
//  Created by Stephano Hugues TELOLAHY on 07/09/2024.
//

import SwiftUI
import Redux
import CardResources

struct SettingsFiguresView: View {
    typealias ViewStore = Store<SettingsFiguresFeature.State, SettingsFiguresFeature.Action>

    @StateObject private var store: ViewStore

    init(store: @escaping () -> ViewStore) {
        // SwiftUI ensures that the following initialization uses the
        // closure only once during the lifetime of the view.
        _store = StateObject(wrappedValue: store())
    }

    var body: some View {
        List {
            ForEach(store.state.figures, id: \.name) { figure in
                Button(action: {
                    Task {
                        await store.dispatch(.selected(figure.name))
                    }
                }, label: {
                    rowView(figure: figure)
                })
            }
        }
        .scrollContentBackground(.hidden)
        .navigationTitle("Figures")
        .task {
            await store.dispatch(.onAppear)
        }
    }

    func rowView(figure: SettingsFiguresFeature.State.Figure) -> some View {
        HStack {
            Image(figure.name, bundle: .cardResources)
                .resizable()
                .scaledToFit()
                .frame(width: 48, height: 48)
                .clipShape(Circle())

            VStack(alignment: .leading) {
                Text(figure.name.uppercased())
                    .bold()
                Text(figure.description)
            }

            Spacer()

            if figure.isFavorite {
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
                    .padding()
            }
        }
        .foregroundStyle(.foreground)
    }
}

#Preview {
    NavigationStack {
        SettingsFiguresView {
            .init(
                initialState: .init(
                    figures: [
                        .init(
                            name: .willyTheKid,
                            description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry",
                            isFavorite: false
                        ),
                        .init(
                            name: .calamityJanet,
                            description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry",
                            isFavorite: false
                        ),
                        .init(
                            name: .blackJack,
                            description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry",
                            isFavorite: true
                        )
                    ]
                )
            )
        }
    }
}
