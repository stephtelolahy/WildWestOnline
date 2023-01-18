//
//  ContentView.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 18/01/2023.
//

import SwiftUI
import Bang

struct ContentView: View {
    var body: some View {
        GameView(viewModel: .init(ctx: AppState.game))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
