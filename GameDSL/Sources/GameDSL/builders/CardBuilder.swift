import Foundation

@resultBuilder
public struct CardBuilder {
    
    public static func buildBlock(_ components: Card...) -> [Card] {
        components
    }
    
    public static func buildExpression(_ card: Card) -> Card {
        card
    }
    
    public static func buildExpression(_ id: String) -> Card {
        Card(id: id, actions: [], attr: [])
    }
}
