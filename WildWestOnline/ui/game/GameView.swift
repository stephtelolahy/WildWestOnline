//
//  GameView.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 18/01/2023.
//

import SwiftUI

struct GameView: View {
    @ObservedObject private(set) var viewModel: ViewModel
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    ForEach(viewModel.players) { model in
                        PlayerRow(player: model)
                    }
                }
            }
            .navigationBarTitle(viewModel.message)
        }
        
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(viewModel: .init(ctx: Sample.game))
    }
}
