//
//  CrosswordListModel.swift
//  word_o_crossv2
//
//  Created by Austin Kang on 2/15/22.
//

import Foundation

struct CrosswordListModel: Decodable {
    let crosswordList: [String]

    init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        crosswordList = try container.decode([String].self)
    }
    
    init() {
        crosswordList = []
    }
}
