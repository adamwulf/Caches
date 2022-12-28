//
//  Cache.swift
//
//
//  Created by Adam Wulf on 1/21/22.
//
//  Adapted from https://www.swiftbysundell.com/articles/caching-in-swift/

import Foundation

/// Wrap `NSCache` to allow for Swift struct keys and values. Ordinarily, `NSCache` requires that all keys
/// and values are `NSObject`. `Cache` wraps keys and values so that any Swift `Hashable` can be
/// used as the key, and any Swift type can be used as the value
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

    /// The maximum number of objects the cache should hold.
    ///
    /// If 0, there is no count limit. The default value is 0.
    ///
    /// This is not a strict limit—if the cache goes over the limit, an object in the cache could be evicted instantly, later, or possibly never, depending on
    /// the implementation details of the cache.
    public var countLimit: Int {
        get {
            wrapped.countLimit
        }
        set {
            wrapped.countLimit = newValue
        }
    }

    /// The maximum total cost that the cache can hold before it starts evicting objects.
    /// If 0, there is no total cost limit. The default value is 0.
    ///
    /// When you add an object to the cache, you may pass in a specified cost for the object, such as the size in bytes of the object.
    /// If adding this object to the cache causes the cache’s total cost to rise above totalCostLimit, the cache may automatically evict objects until its total
    /// cost falls below totalCostLimit. The order in which the cache evicts objects is not guaranteed.
    ///
    /// This is not a strict limit, and if the cache goes over the limit, an object in the cache could be evicted instantly, at a later point in time, or possibly never,
    /// all depending on the implementation details of the cache.
    public var totalCostLimit: Int {
        get {
            wrapped.totalCostLimit
        }
        set {
            wrapped.totalCostLimit = newValue
        }
    }

    // MARK: - Init

    /// Initialize a new `Cache` with a given `countLimit` and `totalCostLimit`.
    ///
    /// - parameter countLimit: Optional. the maxiumum number of entries to store in the cache. Defaults to `0`.
    /// - parameter totalCostLimit: Optional. the maxiumum cost of entries stored in the cache. Defaults to `0`.
    public init(countLimit: Int = 0, totalCostLimit: Int = 0) {
        self.countLimit = countLimit
        self.totalCostLimit = totalCostLimit
    }

    // MARK: - Public Methods

    /// Sets the value of the specified key in the cache.
    /// - parameter value: The value to be stored in the cache.
    /// - parameter key: The key with which to associate the value.
    public func insert(_ value: Value, forKey key: Key) {
        let entry = Entry(value: value)
        wrapped.setObject(entry, forKey: WrappedKey(key))
    }

    /// Returns the value associated with a given key.
    ///
    /// - parameter key: The key with which to associate a value.
    /// - returns: The value associated with key, or nil if no value is associated with key.
    public func value(forKey key: Key) -> Value? {
        let entry = wrapped.object(forKey: WrappedKey(key))
        return entry?.value
    }

    /// Removes the value of the specified key in the cache.
    /// - parameter key: The key identifying the value to be removed.
    public func removeValue(forKey key: Key) {
        wrapped.removeObject(forKey: WrappedKey(key))
    }

    /// Returns the value associated with a given key.
    ///
    /// If an existing key is set to `nil`, that value is removed from the cache.
    ///
    /// - parameter key: The key with which to associate a value.
    /// - returns: The value associated with key, or nil if no value is associated with key.
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
