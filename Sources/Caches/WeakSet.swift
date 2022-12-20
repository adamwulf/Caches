//
//  File.swift
//
//
//  Created by Adam Wulf on 12/20/22.
//

import Foundation

@frozen public struct WeakSet<Element: AnyObject & Hashable>: ExpressibleByArrayLiteral {
    public typealias ArrayLiteralElement = Element

    private var inner: Set<Weak<Element>> = Set()

    // MARK: - Initializers

    public init() {
    }

    public init(minimumCapacity: Int) {
        inner = Set(minimumCapacity: minimumCapacity)
    }

    public init<T: Sequence>(_ elements: T) where T.Element == Element {
        inner = Set(elements.map({ Weak($0) }))
    }

    public init(arrayLiteral elements: ArrayLiteralElement...) {
        inner = Set(elements.map({ Weak($0) }))
    }

    internal init(inner: Set<Weak<Element>>) {
        self.inner = inner
    }

    // MARK: - Public Methods

    public func filter(_ isIncluded: (Element) throws -> Bool) rethrows -> WeakSet<Element> {
        let result = try inner.filter({ item in
            guard let item = item.value else { return false }
            return try isIncluded(item)
        })
        return WeakSet(inner: result)
    }
}
