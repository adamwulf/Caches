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
}
