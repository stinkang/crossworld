//
//  ClueModel.swift
//  word_o_crossv2
//
//  Created by Austin Kang on 2/1/22.
//

import Foundation
class XWordViewModel: ObservableObject {

    @Published var clue: String = ""
    @Published var typedText: String = ""
    @Published var focusedSquareIndex: Int = 0
    @Published var otherPlayersMove: TypedTextData = TypedTextData(text: "", index: 0)
    var shouldSendMessage: Bool = false
    var previousFocusedSquareIndex = 0

    func changeClue(to clue: String) {
        self.clue = clue
    }

    func changeTypedText(to typedText: String) {
        self.typedText = typedText
    }
    
    func changeFocusedSquareIndex(to focusedSquareIndex: Int) {
        self.previousFocusedSquareIndex = self.focusedSquareIndex
        self.focusedSquareIndex = focusedSquareIndex
    }
    
    func changeShouldSendMessage(to shouldSendMessage: Bool) {
        self.shouldSendMessage = shouldSendMessage
    }
    
    func changeOtherPlayersMove(to otherPlayersMove: TypedTextData) {
        self.otherPlayersMove = otherPlayersMove
    }
}
