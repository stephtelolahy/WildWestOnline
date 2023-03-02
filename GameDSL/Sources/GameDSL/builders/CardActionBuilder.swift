import Foundation

@resultBuilder
public struct CardActionBuilder {

    public static func buildBlock(_ components: CardAction...) -> [CardAction] {
        components
    }
}
