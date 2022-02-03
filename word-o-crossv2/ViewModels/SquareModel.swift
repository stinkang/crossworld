//
//  SquareStateModel.swift
//  word_o_crossv2
//
//  Created by Austin Kang on 1/28/22.
//

import Foundation

enum SquareState {
    case focused
    case highlighted
    case unfocused
}

class SquareModel: ObservableObject {

    @Published var squareState: SquareState = .unfocused
    var acrossClue: String = ""
    var downClue: String = ""

    func changeSquareState(to squareState: SquareState) {
        self.squareState = squareState
    }
    
    init(acrossClue: String, downClue: String) {
        self.acrossClue = acrossClue
        self.downClue = downClue
    }
}
