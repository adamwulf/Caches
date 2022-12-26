//
//  ArrayTests.swift
//
//
//  Created by Adam Wulf on 3/1/22.
//

import XCTest
@testable import Caches

final class ArrayTests: XCTestCase {
    func testCache1() throws {
        var arr: WeakArray<Something> = []

        autoreleasepool {
            let something = Something("value")

            arr.append(something)
            XCTAssertEqual(arr.first, something)
        }

        XCTAssertNil(arr.first)
    }

    func testCache2() throws {
        var arr: WeakArray<Something> = []

        autoreleasepool {
            let something = Something("value")

            arr.append(something)
            XCTAssertEqual(arr.first, something)
        }

        XCTAssertNil(arr.first)
    }

    func testCache3() throws {
        var arr: WeakArray<Something> = []

        autoreleasepool {
            let something = Something("value")

            arr.append(something)
            XCTAssertEqual(arr.first, something)

            arr.removeAll()
            XCTAssertEqual(arr.count, 0)
        }

        XCTAssertNil(arr.first)
    }

    func testCache4() throws {
        var arr: WeakArray<Something> = []

        autoreleasepool {
            let something = Something("value")

            arr.append(something)
            XCTAssertEqual(arr.first, something)
            XCTAssert(arr.contains(something))
            XCTAssert(arr.contains(where: { $0.str == "value" }))
        }

        XCTAssertFalse(arr.contains(where: { $0.str == "value" }))
    }

    func testCache5() throws {
        var arr: WeakArray<Something> = []

        autoreleasepool {
            let something = Something("value")

            arr.append(something)
            XCTAssertEqual(arr.first, something)

            arr.removeAll(where: { $0.str == "value" })
            XCTAssertEqual(arr.count, 0)
        }

        XCTAssertNil(arr.first)
    }

    func testStrongToWeak() throws {
        var arr: WeakArray<Something> = []

        autoreleasepool {
            let something1 = Something("value1")
            let something2 = Something("value2")
            let something3 = Something("value3")

            arr = WeakArray([something1, something2, something3])

            XCTAssertEqual(arr.first, something1)
            XCTAssertEqual(arr.last, something3)

            arr.removeAll(where: { $0.str == "value1" })
            XCTAssertEqual(arr.count, 2)
        }

        XCTAssertNil(arr.first)
    }

    func testCompact() throws {
        var arr: WeakArray<Something> = []

        autoreleasepool {
            let something = Something("value1")
            arr.append(something)
            XCTAssertEqual(arr.count, 1)
            XCTAssertNotNil(arr.first)
        }

        XCTAssertNil(arr.first)

        // we haven't compacted, even though we have all nil items
        XCTAssertEqual(arr.estimatedCount, 1)
        XCTAssertEqual(arr.count, 0)
        arr.compact()
        XCTAssertEqual(arr.estimatedCount, 0)
        XCTAssertEqual(arr.count, 0)
    }
}
