//
//  WeakDictionary.swift
//  
//
//  Created by Adam Wulf on 2/16/22.
//

import Foundation

@frozen public struct WeakDictionary<Key: Hashable, Value: AnyObject>: ExpressibleByDictionaryLiteral {

    private var dict: [Key: Weak<Value>] = [:]

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
        defer { compact() }
        if let value = newValue {
            dict[key] = Weak(value)
        } else {
            dict.removeValue(forKey: key)
        }
    }

    @discardableResult
    mutating public func removeValue(forKey key: Key) -> Value? {
        defer { compact() }
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

    mutating private func compact() {
        dict = dict.filter({ $0.value.value != nil })
    }
}

private func == <T: Hashable>(l: T, r: T) -> Bool { return l.hashValue == r.hashValue }

extension WeakDictionary: Collection {
    public var startIndex: Int {
        return 0
    }

    public var endIndex: Int {
        return dict.keys.count
    }

    public subscript(i: Int) -> Value? {
        let index = dict.keys.index(dict.keys.startIndex, offsetBy: i)
        let key = dict.keys[index]
        return dict[key]?.value
    }

    public func index(after i: Int) -> Int {
        return i + 1
    }
}
