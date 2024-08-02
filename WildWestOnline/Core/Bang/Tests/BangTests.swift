@testable import BangCore
import XCTest

final class BangTests: XCTestCase {
    func testExample() throws {
        let result = try XCTUnwrap(Cards.all.prettyPrintedJSONString)
        print(result)
    }
}

extension Encodable {
    var prettyPrintedJSONString: String? {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        guard let data = try? encoder.encode(self) else {
            return nil
        }

        return String(data: data, encoding: .utf8)
    }
}
