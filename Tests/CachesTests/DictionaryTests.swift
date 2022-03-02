import XCTest
@testable import Caches

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
