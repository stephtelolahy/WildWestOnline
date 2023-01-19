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
        
        var id: String {
            player.id
        }
        
        var name: String {
            player.name
        }
        
        var image: Image {
            Image(name)
        }
    }
}
