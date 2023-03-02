import GameDSL

/// Select an option during effect resolution
public struct Choose: Event {
    let actor: String
    let label: String
    let children: [Event]?

    public init(actor: String, label: String, children: [Event]? = nil) {
        self.actor = actor
        self.label = label
        self.children = children
    }

    public func resolve(_ ctx: Game) -> Result<EventOutput, Error> {
        fatalError()
    }
}
