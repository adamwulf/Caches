//
//  SetTests.swift
//
//
//  Created by Adam Wulf on 12/20/22.
//

import XCTest
@testable import Caches

final class SetTests: XCTestCase {
    func testInsert() throws {
        var set: WeakSet<Something> = []

        autoreleasepool {
            let something = Something("value")

            set.insert(something)
            XCTAssertEqual(set.first, something)
        }

        XCTAssertNil(set.first)
    }

    func testInsertTwice() throws {
        var set: WeakSet<Something> = []

        autoreleasepool {
            let something = Something("value")

            set.insert(something)
            set.insert(something)
            XCTAssertEqual(set.first, something)
            XCTAssertEqual(set.count, 1)
            XCTAssertEqual(set.estimatedCount, 1)
        }

        XCTAssertEqual(set.count, 0)
        XCTAssertNil(set.first)
    }

    func testInitArray() throws {
        var set: WeakSet<Something> = []

        autoreleasepool {
            let something1 = Something("value1")
            let something2 = Something("value2")

            set = WeakSet([something1, something2])
            XCTAssert(set.contains(something1))
        }

        XCTAssertFalse(set.contains(where: { $0.str == "value1" }))
    }

    func testRemoveAll() throws {
        var set: WeakSet<Something> = []

        autoreleasepool {
            let something = Something("value")

            set.insert(something)
            XCTAssertEqual(set.first, something)

            set.removeAll()
            XCTAssertEqual(set.count, 0)
        }

        XCTAssertNil(set.first)
    }

    func testContains() throws {
        var set: WeakSet<Something> = []

        autoreleasepool {
            let something1 = Something("value1")

            set.insert(something1)
            XCTAssertEqual(set.first, something1)
            XCTAssert(set.contains(where: { $0.str == "value1" }))
            XCTAssert(set.contains(something1))

            let something2 = Something("value2")
            XCTAssertFalse(set.contains(something2))
        }

        XCTAssertFalse(set.contains(where: { $0.str == "value" }))
    }

    func testCollide() throws {
        var set: WeakSet<Something> = []

        autoreleasepool {
            let something1 = Something("value1", "hash")
            let something2 = Something("value2", "hash")

            set.insert(something1)
            XCTAssertEqual(set.count, 1)
            XCTAssert(set.contains(something1))
            XCTAssertFalse(set.contains(something2))

            set.insert(something2)
            // they collide, so our count is only an estimate
            XCTAssertEqual(set.estimatedCount, 1)
            XCTAssertEqual(set.count, 2)
            XCTAssert(set.contains(something1))
            XCTAssert(set.contains(something2))
        }

        XCTAssertFalse(set.contains(where: { $0.str.hasPrefix("value") }))
    }

    func testCollide2() throws {
        var set: WeakSet<Something> = []
        let something1 = Something("value1", "hash")
        set.insert(something1)

        XCTAssertEqual(set.count, 1)
        XCTAssert(set.contains(something1))

        autoreleasepool {
            let something2 = Something("value2", "hash")
            XCTAssertFalse(set.contains(something2))

            set.insert(something2)
            // they collide, so our count is only an estimate
            XCTAssertEqual(set.count, 2)
            XCTAssert(set.contains(something1))
            XCTAssert(set.contains(something2))
        }

        XCTAssert(set.contains(where: { $0.str.hasPrefix("value") }))
        XCTAssertEqual(set.estimatedCount, 1)
        XCTAssertEqual(set.count, 1)
    }

    func testEstimatedSize() throws {
        var set: WeakSet<Something> = []
        let something1 = Something("value1")
        set.insert(something1)

        XCTAssertEqual(set.count, 1)
        XCTAssertEqual(set.estimatedCount, 1)

        autoreleasepool {
            let something2 = Something("value2")

            set.insert(something2)
            // they collide, so our count is only an estimate
            XCTAssertEqual(set.count, 2)
            XCTAssertEqual(set.estimatedCount, 2)
            XCTAssert(set.contains(something1))
            XCTAssert(set.contains(something2))
        }

        XCTAssertEqual(set.count, 1)
        XCTAssertEqual(set.estimatedCount, 2)
        set.compact()
        XCTAssertEqual(set.count, 1)
        XCTAssertEqual(set.estimatedCount, 1)
    }

    func testFilter() throws {
        let something1 = Something("value1")
        let something2 = Something("value2")
        let set1: WeakSet<Something> = [something1, something2]
        let set2 = set1.filter({ $0.str.hasSuffix("1") })

        XCTAssert(set1.contains(where: { $0.str == "value1" }))
        XCTAssert(set1.contains(where: { $0.str == "value2" }))
        XCTAssert(set2.contains(where: { $0.str == "value1" }))
        XCTAssertFalse(set2.contains(where: { $0.str == "value2" }))
    }

    // Test that the filter method can handle null values
    func testFilterWithNull() throws {
        let something1 = Something("value1")
        var set1: WeakSet<Something> = [something1]

        autoreleasepool {
            let something2 = Something("value2")
            set1.insert(something2)
        }

        let set2 = set1.filter({ $0.str.hasSuffix("1") })

        XCTAssert(set1.contains(where: { $0.str == "value1" }))
        XCTAssertFalse(set1.contains(where: { $0.str == "value2" }))
        XCTAssert(set2.contains(where: { $0.str == "value1" }))
        XCTAssertFalse(set2.contains(where: { $0.str == "value2" }))
    }

    func testRemoveWhere() throws {
        let something1 = Something("value1")
        let something2 = Something("value2")
        var set1: WeakSet<Something> = [something1, something2]

        XCTAssert(set1.contains(where: { $0.str == "value1" }))
        XCTAssert(set1.contains(where: { $0.str == "value2" }))

        XCTAssert(set1.removeAll(where: { $0.str.hasSuffix("1") }))

        XCTAssert(set1.contains(where: { $0.str == "value2" }))
        XCTAssertFalse(set1.contains(where: { $0.str == "value1" }))

        XCTAssertFalse(set1.removeAll(where: { $0.str.hasSuffix("1") }))
    }

    func testCompact() throws {
        let something1 = Something("value1")
        var set: WeakSet<Something> = [something1]

        autoreleasepool {
            let something2 = Something("value2")

            set.insert(something2)
            XCTAssert(set.contains(something2))
        }

        XCTAssertEqual(set.estimatedCount, 2)
        XCTAssertEqual(set.count, 1)
        set.compact()
        XCTAssertEqual(set.estimatedCount, 1)
        XCTAssertEqual(set.count, 1)
    }
}
