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
