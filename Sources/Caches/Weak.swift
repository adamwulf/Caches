//
//  File.swift
//
//
//  Created by Adam Wulf on 12/19/22.
//

import Foundation

@usableFromInline
final class Weak<T: AnyObject> {
    weak var value: T?
    init(_ value: T) { self.value = value }
}

extension Weak: Equatable where T: Hashable {
    @usableFromInline
    static func == (lhs: Weak<T>, rhs: Weak<T>) -> Bool {
        return lhs.value === rhs.value
    }
}

extension Weak: Hashable where T: Hashable {
    @usableFromInline
    func hash(into hasher: inout Hasher) {
        if let value = value {
            hasher.combine(value)
        }
    }
}
