//
//  TypedTextData.swift
//  word_o_crossv2
//
//  Created by Austin Kang on 2/7/22.
//

import Foundation

struct TypedTextData: Codable, Equatable {
    var text: String
    var index: Int
    
    static func == (lhs: TypedTextData, rhs: TypedTextData) -> Bool {
        lhs.text == rhs.text &&
        lhs.index == rhs.index
    }
}
