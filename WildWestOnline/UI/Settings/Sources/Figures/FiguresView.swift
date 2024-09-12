//
//  SwiftUIView.swift
//  WildWestOnline
//
//  Created by Stephano Hugues TELOLAHY on 07/09/2024.
//

import Redux
import SwiftUI

public struct FiguresView: View {
    public struct State: Equatable {
        public let figures: [Figure]

        public struct Figure: Equatable {
            let name: String
            let isFavorite: Bool
        }
    }

    public enum Action {
        case didChangePreferredFigure(String)
    }

    @StateObject private var store: Store<State, Action>

    public init(store: @escaping () -> Store<State, Action>) {
        // SwiftUI ensures that the following initialization uses the
        // closure only once during the lifetime of the view.
        _store = StateObject(wrappedValue: store())
    }

    public var body: some View {
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

struct FigureRow: View {
    var figure: FiguresView.State.Figure

    var body: some View {
        HStack {
            Image(systemName: "lanyardcard")
            Text(figure.name)

            Spacer()

            if figure.isFavorite {
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
                    .padding()
            }

        }
    }
}
