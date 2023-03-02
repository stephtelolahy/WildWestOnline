import XCTest
import GameDSL
@testable import CardGame

final class CardGameTests: XCTestCase {
    func testExample() throws {
        let ctx = Game {

        }
        let sut = CardGameEngine(ctx, rule: MockCardGameEngineRule())
        XCTAssertNotNil(sut)
    }
}




private final class MockCardGameEngineRule: CardGameEngineRule {

    func triggered(_ ctx: GameDSL.Game) -> [Event]? {
        nil
    }

    func active(_ ctx: GameDSL.Game) -> [Event]? {
        nil
    }
}
