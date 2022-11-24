//
//  MakeXWordSquareViewModel.swift
//  word_o_crossv2
//
//  Created by Austin Kang on 11/6/22.
//

import Foundation

import Foundation

enum MakeXWordSquareState {
    case highlighted
    case focused
    case unfocused
    case black
}

class MakeXWordSquareViewModel: ObservableObject {
    
    @Published var currentText: String = ""
    @Published var isWhite = true
    @Published var squareState: MakeXWordSquareState
    @Published var clueNumber = 0
    @Published var acrossClueIndex = -1
    @Published var downClueIndex = -1
    var acrossClue: String = ""
    var downClue: String = ""
    var answerText: String = ""

    func changeCurrentText(to currentText: String) {
        self.currentText = currentText
    }
    
    init(acrossClue: String, downClue: String, answerText: String) {
        self.acrossClue = acrossClue
        self.downClue = downClue
        self.answerText = answerText
        self.squareState = .unfocused
    }
}
