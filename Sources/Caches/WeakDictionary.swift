//
//  WeakDictionary.swift
//  
//
//  Created by Adam Wulf on 2/16/22.
//

import Foundation

@frozen public struct WeakDictionary<Key: Hashable, Value: AnyObject>: ExpressibleByDictionaryLiteral {

    private var dict: [Key: Weak<Value>] = [:]

    public final class Weak<T: AnyObject> {
        weak var value: T?
        init(_ value: T) { self.value = value }
    }

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

    mutating public func setValue(newValue: Value?, forKey key: Key) {
        if let value = newValue {
            dict[key] = Weak(value)
        } else {
            dict.removeValue(forKey: key)
        }
    }

    @discardableResult
    mutating public func removeValue(forKey key: Key) -> Value? {
        return dict.removeValue(forKey: key)?.value
    }

    public var count: Int { return dict.count }

    public var isEmpty: Bool { return dict.isEmpty }

    public var keys: [Key] {
        return dict.compactMap { key, value in
            return value.value != nil ? key : nil
        }
    }

    public var values: [Value] {
        return dict.values.compactMap({ $0.value })
    }
}

private func == <T: Hashable>(l: T, r: T) -> Bool { return l.hashValue == r.hashValue }
