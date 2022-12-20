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
}
