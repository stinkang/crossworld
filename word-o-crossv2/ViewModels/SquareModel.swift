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

class SquareModel: ObservableObject {

    @Published var squareState: SquareState = .unfocused
    @Published var textFromOtherPlayer: String = ""
    @Published var currentText: String = ""
    var acrossClue: String = ""
    var downClue: String = ""

    func changeSquareState(to squareState: SquareState) {
        self.squareState = squareState
    }
    
    func changeTextFromOtherPlayer(to textFromOtherPlayer: String) {
        self.textFromOtherPlayer = textFromOtherPlayer
    }
    
    func changeCurrentText(to currentText: String) {
        self.currentText = currentText
    }
    
    init(acrossClue: String, downClue: String) {
        self.acrossClue = acrossClue
        self.downClue = downClue
    }
}
