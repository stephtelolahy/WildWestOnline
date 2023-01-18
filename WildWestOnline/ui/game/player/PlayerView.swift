//
//  PlayerView.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 18/01/2023.
//

import SwiftUI

struct PlayerView: View {
    let viewModel: ViewModel
    
    var body: some View {
        Text(viewModel.name)
    }
}

struct PlayerView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = PlayerView.ViewModel(id: "p1", name: "p1")
        PlayerView(viewModel: viewModel)
    }
}
