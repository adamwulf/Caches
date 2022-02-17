import XCTest
@testable import Caches

class Something: Equatable {
    let str: String
    init(_ str: String) {
        self.str = str
    }

    static func == (lhs: Something, rhs: Something) -> Bool {
        return lhs.str == rhs.str
    }
}

final class DictionaryTests: XCTestCase {
    func testCache1() throws {
        var dictionary: WeakDictionary<String, Something> = [:]

        autoreleasepool {
            let something = Something("value")

            dictionary["key"] = something

            XCTAssertEqual(dictionary["key"], something)
        }

        XCTAssertNil(dictionary["key"])
    }

    func testCache2() throws {
        var dictionary: WeakDictionary<String, Something> = [:]

        autoreleasepool {
            let something = Something("value")

            dictionary = ["key": something]

            XCTAssertEqual(dictionary["key"], something)
        }

        XCTAssertNil(dictionary["key"])
    }
}
