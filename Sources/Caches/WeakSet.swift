//
//  File.swift
//
//
//  Created by Adam Wulf on 12/20/22.
//

import Foundation

/// A `WeakSet` holds all of its items weakly.
@frozen public struct WeakSet<Element: AnyObject & Hashable>: ExpressibleByArrayLiteral {
    public typealias ArrayLiteralElement = Element

    private var inner: [Int: WeakArray<Element>] = [:]

    // MARK: - Initializers

    public init() {
    }

    public init(minimumCapacity: Int) {
        inner = Dictionary(minimumCapacity: minimumCapacity)
    }

    public init<T: Sequence>(_ elements: T) where T.Element == Element {
        inner = [:]
        for ele in elements {
            insert(ele)
        }
    }

    public init(arrayLiteral elements: ArrayLiteralElement...) {
        self.init(elements)
    }

    internal init(inner: [Int: WeakArray<Element>]) {
        self.inner = inner
    }

    // MARK: - Public Members

    public var count: Int { return inner.compactMap({ $0.1.count }).reduce(0, +) }

    public var estimatedCount: Int { return inner.count }

    public var first: Element? {
        for (_, collisions) in inner {
            guard let ele = collisions.first else { continue }
            return ele
        }
        return nil
    }

    // MARK: - Public Methods

    @discardableResult
    public mutating func insert(_ newMember: Element) -> (inserted: Bool, memberAfterInsert: Element) {
        let hash = newMember.hashValue
        if let old = inner[hash], let maybeVal = old.first(where: { $0 == newMember }), let oldValue = maybeVal {
            return (false, oldValue)
        }
        if var arr = inner[hash] {
            arr.append(newMember)
            inner[hash] = arr
        } else {
            inner[hash] = [newMember]
        }
        return (true, newMember)
    }

    public mutating func removeAll(keepingCapacity keepCapacity: Bool = false) {
        inner.removeAll(keepingCapacity: keepCapacity)
    }

    public func contains(_ member: Element) -> Bool {
        guard let val = inner[member.hashValue] else { return false }
        return val.contains(member)
    }

    public func contains(where predicate: (Element) throws -> Bool) rethrows -> Bool {
        for (_, collisions) in inner where try collisions.contains(where: predicate) {
            return true
        }
        return false
    }

    @discardableResult
    public mutating func removeAll(where predicate: (Element) throws -> Bool) rethrows -> Bool {
        var didRemove = false
        for (key, var collisions) in inner where try collisions.removeAll(where: predicate) {
            inner[key] = collisions
            didRemove = true
        }
        return didRemove
    }

    public func filter(_ isIncluded: (Element) throws -> Bool) rethrows -> WeakSet<Element> {
        let result = try inner.compactMapValues({ collisions in
            WeakArray(try collisions.filter({
                guard let item = $0 else { return false }
                return try isIncluded(item)
            }).compactMap({ $0 }))
        })
        return WeakSet(inner: result)
    }

    public mutating func compact() {
        inner = inner.compactMapValues({ items in
            var items = items
            items.compact()
            guard !items.isEmpty else { return nil }
            return items
        })
    }
}
