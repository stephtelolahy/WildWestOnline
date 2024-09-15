//
//  FigureRow.swift
//  WildWestOnline
//
//  Created by Stephano Hugues TELOLAHY on 12/09/2024.
//
import SwiftUI

struct FigureRow: View {
    var figure: SettingsFiguresView.State.Figure

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
