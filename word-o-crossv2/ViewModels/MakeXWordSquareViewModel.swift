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
    
    @Published var currentText: String
    @Published var isWhite: Bool
    @Published var squareState: MakeXWordSquareState
    @Published var clueNumber = 0
    @Published var acrossClueIndex = -1
    @Published var downClueIndex = -1
    var answerText: String = ""

    func changeCurrentText(to currentText: String) {
        self.currentText = currentText
    }
    
    init(answerText: String, isWhite: Bool = true, currentText: String="") {
        self.answerText = answerText
        self.squareState = .unfocused
        self.isWhite = isWhite
        self.currentText = currentText
    }
}
