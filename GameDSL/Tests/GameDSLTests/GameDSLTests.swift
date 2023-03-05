import XCTest
@testable import GameDSL
import Cuckoo

final class GameDSLTests: XCTestCase {

    func testExample() throws {
        let ctx = Game {
        }
        
        XCTAssertNotNil(ctx)
    }
}
