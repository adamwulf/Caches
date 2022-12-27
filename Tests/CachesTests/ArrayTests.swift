//
//  ArrayTests.swift
//
//
//  Created by Adam Wulf on 3/1/22.
//

import XCTest
@testable import Caches

final class ArrayTests: XCTestCase {
    func testAppend() throws {
        var arr: WeakArray<Something> = []

        autoreleasepool {
            let something = Something("value")

            arr.append(something)
            XCTAssertEqual(arr.first, something)
        }

        XCTAssertNil(arr.first)
    }

    func testRemoveAll() throws {
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

    func testContains() throws {
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

    func testRemoveWhere() throws {
        var arr: WeakArray<Something> = []

        autoreleasepool {
            let something = Something("value")

            arr.append(something)
            XCTAssertEqual(arr.first, something)

            arr.removeAll(where: { $0.str == "fumble" })
            XCTAssertEqual(arr.count, 1)

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

    func testSubscript() throws {
        var arr: WeakArray<Something> = []
        let something1 = Something("value1")
        let something2 = Something("value2")
        arr[0] = something1
        XCTAssertEqual(arr.count, 1)
        XCTAssertNotNil(arr.first)

        arr[0] = something2
        XCTAssertEqual(arr.count, 1)
        XCTAssertNotNil(arr.first)

        arr[0] = nil

        XCTAssertEqual(arr.count, 0)
        XCTAssertNil(arr.first)
    }

    func testIterate() throws {
        let something1 = Something("value2")
        var arr: WeakArray<Something> = [something1]

        autoreleasepool {
            let something2 = Something("value1")
            arr.append(something2)

            var count = 0
            for val in arr {
                XCTAssert([something1, something2].contains(val))
                count += 1
            }
            XCTAssertEqual(count, 2)
        }

        var count = 0
        for i in arr.indices {
            XCTAssertEqual(arr[i], something1)
            count += 1
        }
        XCTAssertEqual(count, 1)
    }

    func testForEach() throws {
        let something1 = Something("value2")
        var arr: WeakArray<Something> = [something1]

        autoreleasepool {
            let something2 = Something("value1")
            arr.append(something2)

            var count = 0
            arr.forEach { val in
                XCTAssert([something1, something2].contains(val))
                count += 1
            }
            XCTAssertEqual(count, 2)
        }

        var count = 0
        arr.forEach { val in
            XCTAssertEqual(val, something1)
            count += 1
        }
        XCTAssertEqual(count, 1)
    }

    func testLast() throws {
        let something1 = Something("value2")
        var arr: WeakArray<Something> = [something1]

        autoreleasepool {
            let something2 = Something("value1")
            arr.append(something2)

            XCTAssertEqual(arr.last, something2)
        }

        XCTAssertEqual(arr.last, something1)

        arr.remove(at: 0)

        XCTAssertEqual(arr.last, nil)
    }

    func testMap() throws {
        let something1 = Something("value2")
        var arr: WeakArray<Something> = [something1]

        autoreleasepool {
            let something2 = Something("value1")
            arr.append(something2)

            XCTAssertEqual(arr.map({ $0.str }), ["value2", "value1"])
        }

        XCTAssertEqual(arr.map({ $0.str }), ["value2"])
    }

    func testMapToNil() throws {
        let something1 = Something("value2")
        var arr: WeakArray<Something> = [something1]

        autoreleasepool {
            let something2 = Something("value1")
            arr.append(something2)

            XCTAssertEqual(arr.map({ $0.str == "value2" ? nil : $0.str }), [nil, "value1"])
        }

        XCTAssertEqual(arr.map({ $0.str == "value2" ? nil : $0.str }), [nil])
    }

    func testCompactMap() throws {
        let something1: Something = Something("value2")
        var arr: WeakArray<Something> = [something1]

        autoreleasepool {
            let something2 = Something("value1")
            arr.append(something2)

            XCTAssertEqual(arr.compactMap({ $0.str == "value2" ? nil : $0.str }), ["value1"])
        }

        XCTAssertEqual(arr.compactMap({ $0.str == "value2" ? nil : $0.str }), [])
    }

    func testExists() throws {
        let something1 = Something("value2")
        var arr: WeakArray<Something> = [something1]

        XCTAssert(arr.exists(at: 0))

        autoreleasepool {
            let something2 = Something("value1")
            arr.append(something2)

            XCTAssert(arr.exists(at: 1))
        }

        XCTAssert(arr.exists(at: 0))
        XCTAssertFalse(arr.exists(at: 1))
    }

    func testAppendContents() throws {
        var arr: WeakArray<Something> = []

        autoreleasepool {
            let something1 = Something("value2")
            let something2 = Something("value1")

            arr.append(contentsOf: [something1, something2])
            XCTAssertEqual(arr.count, 2)
        }

        XCTAssertEqual(arr.count, 0)
    }

    func testRemoveWhereAlreadyNil() throws {
        let something1 = Something("value2")
        var arr: WeakArray<Something> = [something1]

        autoreleasepool {
            let something2 = Something("value1")
            arr.append(contentsOf: [something1, something2])
            XCTAssertEqual(arr.count, 3)
        }

        arr.removeAll(where: { $0.str == "anything" })

        XCTAssertEqual(arr.count, 2)
    }
}
