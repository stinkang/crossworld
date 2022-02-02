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

    @Published var state: SquareState = .unfocused
    var acrossClue: String = ""
    var downClue: String = ""

    func change(to state: SquareState) {
        self.state = state
    }
    
    init(acrossClue: String, downClue: String) {
        self.acrossClue = acrossClue
        self.downClue = downClue
    }
}
