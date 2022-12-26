//
//  File.swift
//
//
//  Created by Adam Wulf on 3/1/22.
//

import Foundation

class Something: Hashable {
    let str: String
    private let hash: String?
    init(_ str: String, _ hash: String? = nil) {
        self.str = str
        self.hash = hash
    }

    static func == (lhs: Something, rhs: Something) -> Bool {
        return lhs.str == rhs.str
    }

    func hash(into hasher: inout Hasher) {
        if let hash = hash {
            hasher.combine(hash)
        } else {
            hasher.combine(str)
        }
    }
}
