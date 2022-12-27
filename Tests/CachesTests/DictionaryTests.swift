import XCTest
@testable import Caches

final class DictionaryTests: XCTestCase {
    func testSetKeyValue() throws {
        var dictionary: WeakDictionary<String, Something> = [:]

        autoreleasepool {
            let something = Something("value1")

            dictionary["key"] = something

            XCTAssertEqual(dictionary["key"], something)
        }

        XCTAssertNil(dictionary["key"])
    }

    func testDictionaryLiteral() throws {
        var dictionary: WeakDictionary<String, Something> = [:]

        autoreleasepool {
            let something = Something("value1")

            dictionary = ["key": something]

            XCTAssertEqual(dictionary["key"], something)
        }

        XCTAssertNil(dictionary["key"])
    }

    func testIterate() throws {
        var dictionary: WeakDictionary<String, Something> = [:]

        autoreleasepool {
            let something = Something("value1")

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
            let something1 = Something("value1")
            let something2 = Something("value2")

            dictionary = ["key1": something1, "key2": something2]

            for (key, val) in dictionary {
                XCTAssert(["key1", "key2"].contains(key))
                XCTAssert([something1, something2].contains(val))
            }

            XCTAssertEqual(dictionary["key1"], something1)
            XCTAssertEqual(dictionary.count, 2)
        }

        XCTAssertNil(dictionary["key1"])
        // we still have a count of 1 even though the item is nil
        XCTAssertEqual(dictionary.estimatedCount, 2)
        XCTAssertEqual(dictionary.count, 0)
        dictionary.compact()
        XCTAssertEqual(dictionary.estimatedCount, 0)
        XCTAssertEqual(dictionary.count, 0)
    }

    func testDictionaryKeys() throws {
        var dictionary: WeakDictionary<String, Something> = [:]

        autoreleasepool {
            let something1 = Something("value1")
            let something2 = Something("value2")

            dictionary = ["key1": something1, "key2": something2]

            XCTAssertEqual(dictionary.keys.sorted(), ["key1", "key2"])
        }

        XCTAssert(dictionary.keys.isEmpty)
    }

    func testRemoveValue() throws {
        let something1 = Something("value1")
        let something2 = Something("value2")

        var dictionary: WeakDictionary<String, Something> = [:]
        dictionary["key1"] = something1
        dictionary["key2"] = something2

        XCTAssertEqual(dictionary.count, 2)
        XCTAssertEqual(dictionary.estimatedCount, 2)

        dictionary.removeValue(forKey: "key2")

        XCTAssertEqual(dictionary["key1"], something1)
        XCTAssertEqual(dictionary["key2"], nil)

        XCTAssertEqual(dictionary.count, 1)
        XCTAssertEqual(dictionary.estimatedCount, 1)
    }

    func testSetValue() throws {
        let something1 = Something("value1")
        let something2 = Something("value2")

        var dictionary: WeakDictionary<String, Something> = [:]

        dictionary.setValue(newValue: something2, forKey: "key1")
        dictionary.setValue(newValue: something1, forKey: "key1")

        XCTAssertEqual(dictionary["key1"], something1)

        XCTAssert(dictionary.exists(forKey: "key1"))
        XCTAssertEqual(dictionary.count, 1)
        XCTAssertEqual(dictionary.estimatedCount, 1)

        dictionary.setValue(newValue: nil, forKey: "key1")

        XCTAssertFalse(dictionary.exists(forKey: "key1"))
        XCTAssertEqual(dictionary["key1"], nil)

        XCTAssertEqual(dictionary.count, 0)
        XCTAssertEqual(dictionary.estimatedCount, 0)
    }

    func testIndex() throws {
        let something1 = Something("value1")
        let something2 = Something("value2")
        let dictionary: WeakDictionary<String, Something> = ["key1": something1, "key2": something2]

        let firstIndex = dictionary.startIndex
        let nextIndex = dictionary.index(after: firstIndex)
        let endIndex = dictionary.endIndex

        XCTAssert(firstIndex < nextIndex)
        XCTAssert(nextIndex < endIndex)

        XCTAssert(["value1", "value2"].contains(dictionary[nextIndex].1?.str))
    }

    func testIsEmpty() throws {
        let something1 = Something("value1")
        let something2 = Something("value2")
        var dictionary: WeakDictionary<String, Something> = ["key1": something1, "key2": something2]

        XCTAssertFalse(dictionary.isEmpty)

        dictionary.removeAll()

        XCTAssert(dictionary.isEmpty)
    }

    func testValues() throws {
        var dictionary: WeakDictionary<String, Something> = [:]
        let something1 = Something("value1")
        dictionary["key1"] = something1

        autoreleasepool {
            let something2 = Something("value2")
            dictionary["key2"] = something2
            let vals = dictionary.values

            XCTAssert(vals.contains(something1))
            XCTAssert(vals.contains(something2))
        }

        let vals = dictionary.values.map({ $0.str })

        XCTAssert(vals.contains("value1"))
        XCTAssertFalse(vals.contains("value2"))
    }
}
