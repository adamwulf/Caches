import XCTest
@testable import Caches

final class CachesTests: XCTestCase {
    func testCache() throws {
        let cache = Cache<String, String>(countLimit: 10)

        cache["1"] = "asdf"
        cache["2"] = "asdf"
        cache["3"] = "asdf"

        XCTAssertNotNil(cache["1"])
        XCTAssertNotNil(cache["2"])
        XCTAssertNotNil(cache["3"])
    }

    func testCacheNil() throws {
        let cache = Cache<String, String>(countLimit: 10)

        for i in 1...1000 {
            cache["\(i)"] = "asdf"
        }

        XCTAssertNil(cache["1"])
        XCTAssertNil(cache["990"])
        XCTAssertNotNil(cache["991"])
        XCTAssertNotNil(cache["1000"])
    }

    func testWeak() throws {
        let str = "asdfasdf"
        let val = Something(str)
        let weak = Weak(val)

        XCTAssertEqual(val.hashValue, weak.hashValue)
    }

    func testCacheSetNil() throws {
        let cache = Cache<String, String>(countLimit: 10)

        cache["1"] = "asdf"

        XCTAssertNotNil(cache["1"])

        cache["1"] = nil

        XCTAssertNil(cache["1"])
    }

    func testCacheLimits() throws {
        let cache = Cache<String, String>(countLimit: 10)

        XCTAssertEqual(cache.countLimit, 10)

        cache.totalCostLimit = 1000

        XCTAssertEqual(cache.totalCostLimit, 1000)
    }

}
