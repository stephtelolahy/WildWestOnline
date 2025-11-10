//
//  SwiftUIView.swift
//  WildWestOnline
//
//  Created by Stephano Hugues TELOLAHY on 07/09/2024.
//

import SwiftUI
import CardResources

struct SettingsFiguresView: View {
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
                        await store.dispatch(.settings(.updatePreferredFigure(figure.name)))
                    }
                }, label: {
                    figureRow(figure: figure)
                        .foregroundStyle(.foreground)
                })
            }
        }
        .scrollContentBackground(.hidden)
        .navigationTitle("Figures")
    }

    func figureRow(figure: ViewState.Figure) -> some View {
        HStack {
            Image(figure.name, bundle: .cardResources)
                .resizable()
                .scaledToFit()
                .frame(width: 48, height: 48)
                .clipShape(Circle())

            Text(figure.name.uppercased())

            Spacer()

            if figure.isFavorite {
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
                    .padding()
            }
        }
    }
}

#Preview {
    SettingsFiguresView {
        .init(
            initialState: .init(figures: [
                .init(name: .willyTheKid, isFavorite: false),
                .init(name: .calamityJanet, isFavorite: false),
                .init(name: .blackJack, isFavorite: true)
            ]),
            dependencies: ()
        )
    }
}
