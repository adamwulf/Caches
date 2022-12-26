//
//  SetTests.swift
//
//
//  Created by Adam Wulf on 12/20/22.
//

import XCTest
@testable import Caches

final class SetTests: XCTestCase {
    func testCache1() throws {
        var arr: WeakSet<Something> = []

        autoreleasepool {
            let something = Something("value")

            arr.insert(something)
            XCTAssertEqual(arr.first, something)
        }

        XCTAssertNil(arr.first)
    }

    func testCache2() throws {
        var arr: WeakSet<Something> = []

        autoreleasepool {
            let something = Something("value")

            arr.insert(something)
            XCTAssertEqual(arr.first, something)
        }

        XCTAssertNil(arr.first)
    }

    func testCache3() throws {
        var arr: WeakSet<Something> = []

        autoreleasepool {
            let something = Something("value")

            arr.insert(something)
            XCTAssertEqual(arr.first, something)

            arr.removeAll()
            XCTAssertEqual(arr.count, 0)
        }

        XCTAssertNil(arr.first)
    }

    func testCache4() throws {
        var arr: WeakSet<Something> = []

        autoreleasepool {
            let something = Something("value")

            arr.insert(something)
            XCTAssertEqual(arr.first, something)
            XCTAssert(arr.contains(something))
            XCTAssert(arr.contains(where: { $0.str == "value" }))
        }

        XCTAssertFalse(arr.contains(where: { $0.str == "value" }))
    }

    func testCollide() throws {
        var arr: WeakSet<Something> = []

        autoreleasepool {
            let something1 = Something("value1", "hash")
            let something2 = Something("value2", "hash")

            arr.insert(something1)
            XCTAssertEqual(arr.count, 1)
            XCTAssert(arr.contains(something1))
            XCTAssertFalse(arr.contains(something2))

            arr.insert(something2)
            // they collide, so our count is only an estimate
            XCTAssertEqual(arr.estimatedCount, 1)
            XCTAssertEqual(arr.count, 2)
            XCTAssert(arr.contains(something1))
            XCTAssert(arr.contains(something2))
        }

        XCTAssertFalse(arr.contains(where: { $0.str.hasPrefix("value") }))
    }

    func testCollide2() throws {
        var arr: WeakSet<Something> = []
        let something1 = Something("value1", "hash")
        arr.insert(something1)

        XCTAssertEqual(arr.count, 1)
        XCTAssert(arr.contains(something1))

        autoreleasepool {
            let something2 = Something("value2", "hash")
            XCTAssertFalse(arr.contains(something2))

            arr.insert(something2)
            // they collide, so our count is only an estimate
            XCTAssertEqual(arr.count, 2)
            XCTAssert(arr.contains(something1))
            XCTAssert(arr.contains(something2))
        }

        XCTAssert(arr.contains(where: { $0.str.hasPrefix("value") }))
        XCTAssertEqual(arr.estimatedCount, 1)
        XCTAssertEqual(arr.count, 1)
    }
}
