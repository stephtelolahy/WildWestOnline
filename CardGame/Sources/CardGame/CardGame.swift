import GameDSL

protocol CardGame {

    /// is Game over
    var isOver: Bool { get }

    /// last occurred event
    var event: Result<Event, Error>? { get set }
}
