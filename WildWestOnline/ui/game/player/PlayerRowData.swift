//
//  PlayerRowData.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 18/01/2023.
//
import Bang
import SwiftUI

extension PlayerRow {
    struct Data: Identifiable {
        let player: Player
        let id = UUID()
        
        var name: String {
            player.name
        }
        
        var image: Image {
            Image(name)
        }
    }
}
