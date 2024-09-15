//
//  SwiftUIView.swift
//  WildWestOnline
//
//  Created by Stephano Hugues TELOLAHY on 07/09/2024.
//

import Redux
import SwiftUI

struct FiguresView: View {
    struct State: Equatable {
        let figures: [Figure]

        struct Figure: Equatable {
            let name: String
            let isFavorite: Bool
        }
    }

    enum Action {
        case didChangePreferredFigure(String)
    }

    @StateObject private var store: Store<State>

    init(store: @escaping () -> Store<State>) {
        // SwiftUI ensures that the following initialization uses the
        // closure only once during the lifetime of the view.
        _store = StateObject(wrappedValue: store())
    }

    var body: some View {
        List {
            ForEach(store.state.figures, id: \.name) { figure in
                Button(action: {
                    store.dispatch(.didChangePreferredFigure(figure.name))
                }, label: {
                    FigureRow(figure: figure)
                })

            }
        }
        .navigationTitle("Figures")
    }
}

#Preview {
    FiguresView {
        .init(initial: .init(figures: [
            .init(name: "Figure1", isFavorite: false),
            .init(name: "Figure2", isFavorite: false),
            .init(name: "Figure3", isFavorite: true)
        ]))
    }
}
