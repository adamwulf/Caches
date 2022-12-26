//
//  File.swift
//
//
//  Created by Adam Wulf on 3/1/22.
//

import Foundation

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

    public mutating func removeAll(where shouldBeRemoved: (Element) throws -> Bool) rethrows {
        defer { compact() }
        try arr.removeAll(where: { weakEle in
            guard let ele = weakEle.value else { return true }
            return try shouldBeRemoved(ele)
        })
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

    public var count: Int { return arr.compactMap({ $0.value }).count }

    public var estimatedCount: Int { return arr.count }

    public var isEmpty: Bool { return arr.isEmpty }

    public func map<T>(_ transform: (Element) throws -> T) throws -> [T] {
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
        return arr.index(after: i)
    }

    public subscript(i: Int) -> Element? {
        get { return arr[i].value }
        set {
            if let newValue = newValue {
                arr[i] = Weak(newValue)
            } else {
                arr.remove(at: i)
            }
        }
    }
}
