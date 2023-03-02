import GameDSL

protocol CardGame {

    /// is Game over
    var isOver: Bool { get }

    /// last occurred event
    var event: Result<Event, Error>? { get set }
}

extension Game: CardGame {

    var isOver: Bool {
        fatalError()
    }

    var event: Result<Event, Error>? {
        get {
            fatalError()
        }
        set {
            fatalError()
        }
    }


}
