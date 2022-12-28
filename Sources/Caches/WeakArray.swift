//
//  File.swift
//
//
//  Created by Adam Wulf on 3/1/22.
//

import Foundation

/// A `WeakArray` holds all of its object elements weakly.
@frozen public struct WeakArray<Element: AnyObject>: ExpressibleByArrayLiteral {
    public typealias ArrayLiteralElement = Element

    private var arr: [Weak<Element>] = []

    public init() {
    }

    public init(arrayLiteral elements: ArrayLiteralElement...) {
        arr = elements.map({ Weak($0) })
    }

    public init(_ elements: [Element]) {
        arr = elements.map({ Weak($0) })
    }

    public func value(at i: Int) -> Element? {
        return arr[i].value
    }

    public func exists(at i: Int) -> Bool {
        return value(at: i) != nil
    }

    public mutating func append(_ element: Element) {
        defer { compact() }
        arr.append(Weak(element))
    }

    public mutating func append(contentsOf elements: [Element]) {
        defer { compact() }
        arr.append(contentsOf: elements.map({ Weak($0) }))
    }

    @discardableResult
    public mutating func remove(at key: Int) -> Element? {
        defer { compact() }
        return arr.remove(at: key).value
    }

    @discardableResult
    public mutating func removeAll(where shouldBeRemoved: (Element) throws -> Bool) rethrows -> Bool {
        defer { compact() }
        var didRemove = false
        try arr.removeAll(where: { weakEle in
            guard let ele = weakEle.value else { return true }
            let ret = try shouldBeRemoved(ele)
            didRemove = didRemove || ret
            return ret
        })
        return didRemove
    }

    public func contains(where predicate: (Element) throws -> Bool) rethrows -> Bool {
        return try arr.contains(where: { weakEle in
            guard let ele = weakEle.value else { return false }
            return try predicate(ele)
        })
    }

    public mutating func removeAll() {
        return arr.removeAll()
    }

    /// - returns: The exact count of items in the array, excluding any items that have dealloc'd since being added to the array.
    /// - complexity: O(n)
    ///
    /// This iterates over all items in the array to count which have not yet been deallocated.
    public var count: Int { return arr.compactMap({ $0.value }).count }

    /// - returns: An estimate of the number of items in the array. This number will always be greater than or equal to `count`.
    /// - complexity: O(1)
    ///
    /// This value may be higher than the actual number of non-deallocated objects in the array.
    public var estimatedCount: Int { return arr.count }

    public var isEmpty: Bool { return arr.isEmpty }

    public func map<T>(_ transform: (Element) throws -> T) rethrows -> [T] {
        return try arr.compactMap({ $0.value }).map(transform)
    }

    public func compactMap<ElementOfResult>(_ transform: (Element) throws -> ElementOfResult?) rethrows -> [ElementOfResult] {
        return try arr.compactMap({ $0.value }).compactMap(transform)
    }

    public mutating func compact() {
        arr = arr.filter({ $0.value != nil })
    }

    public var first: Element? {
        for item in arr {
            guard let item = item.value else { continue }
            return item
        }
        return nil
    }

    public var last: Element? {
        for item in arr.reversed() {
            guard let item = item.value else { continue }
            return item
        }
        return nil
    }

    public func forEach(_ body: (Element) throws -> Void) rethrows {
        try arr.forEach({
            if let ele = $0.value {
                try body(ele)
            }
        })
    }
}

extension WeakArray: Collection {
    public var startIndex: Int {
        return arr.startIndex
    }

    public var endIndex: Int {
        return arr.endIndex
    }

    public func index(after i: Int) -> Int {
        var i = arr.index(after: i)
        while i < arr.count, arr[i].value == nil {
            i = arr.index(after: i)
        }
        return i
    }

    public subscript(i: Int) -> Element? {
        get { return arr[i].value }
        set {
            if let newValue = newValue {
                if i == arr.count {
                    arr.append(Weak(newValue))
                } else {
                    arr[i] = Weak(newValue)
                }
            } else {
                arr.remove(at: i)
            }
        }
    }
}
