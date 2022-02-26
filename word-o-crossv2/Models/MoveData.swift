//
//  TypedTextData.swift
//  word_o_crossv2
//
//  Created by Austin Kang on 2/7/22.
//

import Foundation

struct MoveData: Codable, Equatable {
    var text: String
    var previousIndex: Int
    var currentIndex: Int
    //var moveNumber: Int
    var acrossFocused: Bool
    var wasTappedOn: Bool
    var crossword: Crossword?
    
    static func == (lhs: MoveData, rhs: MoveData) -> Bool {
        var crosswordCondition = true
        if (lhs.crossword != nil && rhs.crossword != nil) {
            crosswordCondition = lhs.crossword!.title == rhs.crossword!.title
        }
        return lhs.text == rhs.text &&
        lhs.previousIndex == rhs.previousIndex &&
        lhs.currentIndex == rhs.currentIndex &&
        lhs.acrossFocused == rhs.acrossFocused &&
        lhs.wasTappedOn == rhs.wasTappedOn &&
        crosswordCondition
    }
}

extension MoveData {
    func encode() -> Data? {
        return try? JSONEncoder().encode(self)
    }
    
    static func decode(data: Data) -> MoveData? {
        return try? JSONDecoder().decode(MoveData.self, from: data)
    }
}
