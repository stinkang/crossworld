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
    case correct
    case otherPlayerFocused
    case otherPlayerHighlighted
}

class SquareModel: ObservableObject {

    @Published var squareState: SquareState = .unfocused
    @Published var currentText: String = ""
    var acrossClue: String = ""
    var downClue: String = ""
    var hasBeenCorrect: Bool = false
    var solvedByMe: Bool = false

    func changeSquareState(to squareState: SquareState) {
        self.squareState = squareState
    }
    
    func changeCurrentText(to currentText: String) {
        self.currentText = currentText
    }
    
    func changeHasBeenCorrect(to hasBeenCorrect: Bool) {
        self.hasBeenCorrect = hasBeenCorrect
    }
    
    func changeSolvedByMe(to solvedByMe: Bool) {
        self.solvedByMe = solvedByMe
    }
    
    init(acrossClue: String, downClue: String) {
        self.acrossClue = acrossClue
        self.downClue = downClue
    }
}
