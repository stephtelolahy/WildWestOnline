//
//  GameAction+Builder.swift
//  WildWestOnline
//
//  Created by Stephano Hugues TELOLAHY on 20/10/2024.
//

public extension GameAction {
    static func playBrown(_ card: String, player: String) -> Self {
        .init(type: .playBrown, payload: .init(actor: player, card: card))
    }

    /*
     /// Put an equipment card on player's inPlay
     case playEquipment(String, player: String)

     /// Put hand card on target's inPlay
     case playHandicap(String, target: String, player: String)

     /// Spell character ability
     case playAbility(String, player: String)

     /// Restore player's health, limited to maxHealth
     case heal(Int, player: String)

     /// Deals damage to a player, attempting to reduce its Health by the stated amount
     case damage(Int, player: String)

     /// Draw top deck card
     case drawDeck(player: String)

     /// Draw top discard
     case drawDiscard(player: String)

     /// Draw card from other player's hand
     case stealHand(String, target: String, player: String)

     /// Draw card from other player's inPlay
     case stealInPlay(String, target: String, player: String)

     /// Discard a player's hand card
     case discardHand(String, player: String)

     /// Discard a player's inPlay card
     case discardInPlay(String, player: String)

     /// Pass inPlay card on target's inPlay
     case passInPlay(String, target: String, player: String)

     /// Flip top deck card and put to discard
     case draw

     /// Show hand card
     case showLastHand(player: String)

     /// Discover top N deck cards
     case discover(Int)

     /// Draw discovered deck card
     case drawDiscovered(String, player: String)

     /// Hide discovered cards
     case undiscover

     /// Start turn
     case startTurn(player: String)

     /// End turn
     case endTurn(player: String)

     /// Eliminate
     case eliminate(player: String)

     /// Set attribute
     case setWeapon(Int, player: String)
     case setMaginifying(Int, player: String)
     case setRemoteness(Int, player: String)

     // MARK: - To spec

     /// End game
     case endGame(winner: String)

     /// Expose active cards
     case activate([String], player: String)

     // MARK: - Invisible

     /// Move: play a card
     case preparePlay(String, player: String)

     /// Move: choose an option
     case prepareChoose(String, player: String)

     /// Resolve a pending action
     case prepareAction(PendingAction)

     /// Queue actions
     case queue([Self])

     /// Expose a choice
     case chooseOne(PendingChoice, player: String)
     */
}
