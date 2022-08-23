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
}

class SquareViewModel: ObservableObject {

    @Published var squareState: SquareState = .unfocused
    @Published var otherPlayerSquareState: SquareState = .unfocused
    @Published var currentText: String = ""
    var acrossClue: String = ""
    var downClue: String = ""
    var answerText: String = ""
    var hasBeenCorrect: Bool = false
    var solvedByMe: Bool = false

    func changeSquareState(to squareState: SquareState) {
        self.squareState = squareState
    }
    
    func changeOtherPlayerSquareState(to squareState: SquareState) {
        self.otherPlayerSquareState = squareState
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
    
    init(acrossClue: String, downClue: String, answerText: String) {
        self.acrossClue = acrossClue
        self.downClue = downClue
        self.answerText = answerText
    }
}
