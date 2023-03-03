import GameDSL

/// Choose one of pending actions to proceed effect resolving
public struct ChooseOne: Event {
    let options: [Event]

    public init(@EventBuilder options: () -> [Event]) {
        self.options = options()
    }

    public func resolve(_ ctx: Game) -> Result<EventOutput, Error> {
        fatalError()
    }
}
