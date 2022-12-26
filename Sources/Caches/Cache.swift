//
//  Cache.swift
//
//
//  Created by Adam Wulf on 1/21/22.
//
//  Adapted from https://www.swiftbysundell.com/articles/caching-in-swift/

import Foundation

/// Wrap `NSCache` to allow for Swift struct keys and values
public final class Cache<Key: Hashable, Value> {

    // MARK: - Private

    private final class WrappedKey: NSObject {
        let key: Key

        init(_ key: Key) { self.key = key }

        override var hash: Int { return key.hashValue }

        override func isEqual(_ object: Any?) -> Bool {
            guard let value = object as? WrappedKey else {
                return false
            }

            return value.key == key
        }
    }

    private final class Entry {
        let value: Value

        init(value: Value) {
            self.value = value
        }
    }

    private let wrapped = NSCache<WrappedKey, Entry>()

    // MARK: - Public Properties

    public var countLimit: Int {
        get {
            wrapped.countLimit
        }
        set {
            wrapped.countLimit = newValue
        }
    }

    public var totalCostLimit: Int {
        get {
            wrapped.totalCostLimit
        }
        set {
            wrapped.totalCostLimit = newValue
        }
    }

    // MARK: - Init

    public init(countLimit: Int = 0, totalCostLimit: Int = 0) {
        self.countLimit = countLimit
        self.totalCostLimit = totalCostLimit
    }

    // MARK: - Public Methods

    public func insert(_ value: Value, forKey key: Key) {
        let entry = Entry(value: value)
        wrapped.setObject(entry, forKey: WrappedKey(key))
    }

    public func value(forKey key: Key) -> Value? {
        let entry = wrapped.object(forKey: WrappedKey(key))
        return entry?.value
    }

    public func removeValue(forKey key: Key) {
        wrapped.removeObject(forKey: WrappedKey(key))
    }

    public subscript(key: Key) -> Value? {
        get { return value(forKey: key) }
        set {
            guard let value = newValue else {
                // If nil was assigned using our subscript,
                // then we remove any value for that key:
                removeValue(forKey: key)
                return
            }

            insert(value, forKey: key)
        }
    }
}
