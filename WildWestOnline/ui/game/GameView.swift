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
                Text(viewModel.message)
                
                Section {
                    ForEach(viewModel.players) { player in
                        Text(player.name)
                    }
                }
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle("Online ⛅️")
        }
        
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(viewModel: .init(ctx: Sample.game))
    }
}
