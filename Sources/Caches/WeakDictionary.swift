//
//  WeakDictionary.swift
//
//
//  Created by Adam Wulf on 2/16/22.
//

import Foundation

/// A `WeakDictionary` holds all of its values weakly. If keys are objects, they are held strongly.
@frozen public struct WeakDictionary<Key: Hashable, Value: AnyObject>: ExpressibleByDictionaryLiteral {

    private var dict: [Key: Weak<Value>] = [:]

    // MARK: - Initializers

    public init() {
    }

    public init(dictionary: [Key: Value]) {
        for (k, v) in dictionary {
            setValue(newValue: v, forKey: k)
        }
    }

    public init(dictionaryLiteral elements: (Key, Value)...) {
        var dict = [Key: Value]()
        for (k, v) in elements { dict[k] = v }
        self.init(dictionary: dict)
    }

    public subscript(key: Key) -> Value? {
        get { return value(forKey: key) }
        set { setValue(newValue: newValue, forKey: key) }
    }

    public func value(forKey key: Key) -> Value? {
        return dict[key]?.value
    }

    public func exists(forKey key: Key) -> Bool {
        return value(forKey: key) != nil
    }

    public mutating func setValue(newValue: Value?, forKey key: Key) {
        defer { compact() }
        if let value = newValue {
            dict[key] = Weak(value)
        } else {
            dict.removeValue(forKey: key)
        }
    }

    @discardableResult
    public mutating func removeValue(forKey key: Key) -> Value? {
        defer { compact() }
        return dict.removeValue(forKey: key)?.value
    }

    public mutating func removeAll(keepingCapacity: Bool = false) {
        dict.removeAll(keepingCapacity: keepingCapacity)
    }

    public var count: Int { return dict.compactMapValues({ $0.value }).count }

    public var estimatedCount: Int { return dict.count }

    public var isEmpty: Bool { return dict.isEmpty }

    public var keys: [Key] {
        return dict.compactMap { key, value in
            return value.value != nil ? key : nil
        }
    }

    public var values: [Value] {
        return dict.values.compactMap({ $0.value })
    }

    public mutating func compact() {
        dict = dict.filter({ $0.value.value != nil })
    }
}

extension WeakDictionary: Collection {
    public struct Index: Comparable {
        let inner: Dictionary<Key, Weak<Value>>.Index
        init(_ inner: Dictionary<Key, Weak<Value>>.Index) {
            self.inner = inner
        }
        public static func < (lhs: Index, rhs: Index) -> Bool {
            return lhs.inner < rhs.inner
        }
    }

    public var startIndex: Index {
        return Index(dict.startIndex)
    }

    public var endIndex: Index {
        return Index(dict.endIndex)
    }

    public func index(after i: Index) -> Index {
        return Index(dict.index(after: i.inner))
    }

    public subscript(i: Index) -> (Key, Value?) {
        let foo = dict[i.inner]
        return (foo.key, foo.value.value)
    }
}
