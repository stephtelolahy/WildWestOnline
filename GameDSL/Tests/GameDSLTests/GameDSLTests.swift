import XCTest
@testable import GameDSL

final class GameDSLTests: XCTestCase {

    func testExample() throws {
        let ctx = Game {
        }
        
        XCTAssertNotNil(ctx)
    }
}
