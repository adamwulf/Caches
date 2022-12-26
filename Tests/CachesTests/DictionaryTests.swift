import XCTest
@testable import Caches

final class DictionaryTests: XCTestCase {
    func testSetKeyValue() throws {
        var dictionary: WeakDictionary<String, Something> = [:]

        autoreleasepool {
            let something = Something("value")

            dictionary["key"] = something

            XCTAssertEqual(dictionary["key"], something)
        }

        XCTAssertNil(dictionary["key"])
    }

    func testDictionaryLiteral() throws {
        var dictionary: WeakDictionary<String, Something> = [:]

        autoreleasepool {
            let something = Something("value")

            dictionary = ["key": something]

            XCTAssertEqual(dictionary["key"], something)
        }

        XCTAssertNil(dictionary["key"])
    }

    func testIterate() throws {
        var dictionary: WeakDictionary<String, Something> = [:]

        autoreleasepool {
            let something = Something("value")

            dictionary = ["key": something]

            for (key, val) in dictionary {
                XCTAssertEqual(key, "key")
                XCTAssertEqual(val, something)
            }

            XCTAssertEqual(dictionary["key"], something)
        }

        XCTAssertNil(dictionary["key"])
    }

    func testCompact() throws {
        var dictionary: WeakDictionary<String, Something> = [:]

        autoreleasepool {
            let something = Something("value")

            dictionary = ["key": something]

            for (key, val) in dictionary {
                XCTAssertEqual(key, "key")
                XCTAssertEqual(val, something)
            }

            XCTAssertEqual(dictionary["key"], something)
            XCTAssertEqual(dictionary.count, 1)
        }

        XCTAssertNil(dictionary["key"])
        // we still have a count of 1 even though the item is nil
        XCTAssertEqual(dictionary.estimatedCount, 1)
        XCTAssertEqual(dictionary.count, 0)
        dictionary.compact()
        XCTAssertEqual(dictionary.estimatedCount, 0)
        XCTAssertEqual(dictionary.count, 0)
    }
}
