import XCTest
@testable import CardGameCore

final class CardGameCoreTests: XCTestCase {
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        let card = Card()
        XCTAssertEqual(card.id, "")
    }
}
