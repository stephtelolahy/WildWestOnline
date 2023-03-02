import Foundation

@resultBuilder
public struct PlayerBuilder {

    public static func buildBlock(_ components: Player...) -> [Player] {
        components
    }
    
    public static func buildExpression(_ player: Player) -> Player {
        player
    }
    
    public static func buildExpression(_ id: String) -> Player {
        Player(id: id, attr: [])
    }
}
