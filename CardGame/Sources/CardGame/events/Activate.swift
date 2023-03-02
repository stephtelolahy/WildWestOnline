import GameDSL

/// Emit active moves
public struct Activate: Event {
    let moves: [Event]

    public init(_ moves: [Event]) {
        self.moves = moves
    }

    public func resolve(_ ctx: Game) -> Result<EventOutput, Error> {
        fatalError()
    }
}

