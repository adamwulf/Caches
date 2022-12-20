//
//  File.swift
//
//
//  Created by Adam Wulf on 12/20/22.
//

import Foundation

@frozen public struct WeakSet<Element: AnyObject & Hashable>: ExpressibleByArrayLiteral {
    public typealias ArrayLiteralElement = Element

    private var inner: [Int: Weak<Element>] = [:]

    // MARK: - Initializers

    public init() {
    }

    public init(minimumCapacity: Int) {
        inner = Dictionary(minimumCapacity: minimumCapacity)
    }

    public init<T: Sequence>(_ elements: T) where T.Element == Element {
        inner = Dictionary(elements.map({ ($0.hashValue, Weak($0)) }), uniquingKeysWith: { val1, _ in
            return val1
        })
    }

    public init(arrayLiteral elements: ArrayLiteralElement...) {
        self.init(elements)
    }

    internal init(inner: [Int: Weak<Element>]) {
        self.inner = inner
    }

    // MARK: - Public Members

    public var count: Int {
        return inner.count
    }

    public var first: Element? {
        for (_, val) in inner {
            guard let ele = val.value else { continue }
            return ele
        }
        return nil
    }

    // MARK: - Public Methods

    @discardableResult
    public mutating func insert(_ newMember: Element) -> (inserted: Bool, memberAfterInsert: Element) {
        let hash = newMember.hashValue
        if let old = inner[hash], let oldValue = old.value {
            return (false, oldValue)
        }
        inner[hash] = Weak(newMember)
        return (true, newMember)
    }

    public mutating func removeAll(keepingCapacity keepCapacity: Bool = false) {
        inner.removeAll(keepingCapacity: keepCapacity)
    }

    public func contains(_ member: Element) -> Bool {
        let val = inner[member.hashValue]
        return val?.value != nil
    }

    public func contains(where predicate: (Element) throws -> Bool) rethrows -> Bool {
        for (_, item) in inner {
            guard let value = item.value, try predicate(value) else { continue }
            return true
        }
        return false
    }

    public mutating func removeAll(where predicate: (Element) throws -> Bool) rethrows -> Bool {
        var didRemove = false
        for (key, item) in inner {
            guard let value = item.value, try predicate(value) else { continue }
            inner.removeValue(forKey: key)
            didRemove = true
        }
        return didRemove
    }

    public func filter(_ isIncluded: (Element) throws -> Bool) rethrows -> WeakSet<Element> {
        let result = try inner.filter({ _, item in
            guard let item = item.value else { return false }
            return try isIncluded(item)
        })
        return WeakSet(inner: result)
    }
}
