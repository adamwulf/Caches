//
//  File.swift
//
//
//  Created by Adam Wulf on 3/1/22.
//

import Foundation

class Something: Equatable {
    let str: String
    init(_ str: String) {
        self.str = str
    }

    static func == (lhs: Something, rhs: Something) -> Bool {
        return lhs.str == rhs.str
    }
}
