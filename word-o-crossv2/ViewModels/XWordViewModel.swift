//
//  ClueModel.swift
//  word_o_crossv2
//
//  Created by Austin Kang on 2/1/22.
//

import Foundation

class XWordViewModel: ObservableObject {

    @Published var clue: String
    @Published var typedText: String
    @Published var focusedSquareIndex: Int
    @Published var acrossFocused: Bool
    @Published var otherPlayersMove: TypedTextData
    @Published var textState: TextState
    var shouldSendMessage: Bool
    var previousFocusedSquareIndex: Int
    var crosswordWidth: Int
    var crosswordSize: Int
    var crossword: Crossword
    var squareModels: [SquareModel]
    var correctSquares: Int

    init(crossword: Crossword) {
        clue = ""
        typedText = ""
        focusedSquareIndex = 0
        acrossFocused = true
        otherPlayersMove = TypedTextData(text: "", index: 0)
        shouldSendMessage = false
        previousFocusedSquareIndex = 0
        crosswordWidth = 0
        crosswordSize = 0
        textState = .typedTo
        self.crossword = Crossword()
        squareModels = []
        correctSquares = 0
        crosswordWidth = crossword.cols
        crosswordSize = crossword.grid.count
        self.crossword = crossword
        
        (0...crosswordSize - 1).forEach { index in
            var acrossClue: String = ""
            var downClue: String = ""
            if (crossword.grid[index] != ".") {
                acrossClue = crossword.clueNamesToCluesMap[crossword.tagsToCluesMap[index]["A"]!]!
                downClue = crossword.clueNamesToCluesMap[crossword.tagsToCluesMap[index]["D"]!]!
            }
            squareModels.append(SquareModel(acrossClue: acrossClue, downClue: downClue))
        }
        (0...crosswordSize - 1).forEach { index in
            if (crossword.grid[index] == ".") {
                correctSquares += 1
            }
        }
        //self.changeFocus(index: 0)
    }
//    
//    func addCrossword(_ crossword: Crossword) {
//        crosswordWidth = crossword.cols
//        crosswordSize = crossword.grid.count
//        self.crossword = crossword
//        
//        (0...crosswordSize - 1).forEach { index in
//            var acrossClue: String = ""
//            var downClue: String = ""
//            if (crossword.grid[index] != ".") {
//                acrossClue = crossword.clueNamesToCluesMap[crossword.tagsToCluesMap[index]["A"]!]!
//                downClue = crossword.clueNamesToCluesMap[crossword.tagsToCluesMap[index]["D"]!]!
//            }
//            squareModels.append(SquareModel(acrossClue: acrossClue, downClue: downClue))
//        }
//    }

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
    
    func changeAcrossFocused(to acrossFocused: Bool) {
        self.acrossFocused = acrossFocused
    }
    
    func changeTextState(to textState: TextState) {
        self.textState = textState
    }
    
    func changeFocus(index: Int) -> Void {
        unsetPreviousHighlighting(acrossFocusedChanged: false)
        setCurrentHighlighting()
        setCurrentClue()
        changeTypedText(to: "")
    }
    
    func unsetPreviousHighlighting(acrossFocusedChanged: Bool) -> Void {
        // if acrossFocused was changed, get the one it changed from
        let indexToUnset = acrossFocusedChanged
            ? focusedSquareIndex
            : previousFocusedSquareIndex
        let orientationToUnset = acrossFocusedChanged
            ? !acrossFocused
            : acrossFocused

        let clues: Dictionary<String, String> = (crossword.tagsToCluesMap[indexToUnset])
        let clueName = clues[orientationToUnset ? "A" : "D"]
        let clueTags: Array<Int> = (crossword.cluesToTagsMap[clueName!])!
        for clueTag in clueTags {
            squareModels[clueTag].changeSquareState(to: .unfocused)
        }
    }
    
    func setCurrentHighlighting() -> Void {
        let clues: Dictionary<String, String> = (crossword.tagsToCluesMap[focusedSquareIndex])
        let clueName = clues[acrossFocused ? "A" : "D"]
        let clueTags: Array<Int> = (crossword.cluesToTagsMap[clueName!])!
        for clueTag in clueTags {
            squareModels[clueTag].changeSquareState(to: .highlighted)
        }
        squareModels[focusedSquareIndex].changeSquareState(to: .focused)
    }
    
    func goUpASquare() -> Void {
        var potentialNewIndex = focusedSquareIndex - crosswordWidth
        var newIndex: Int
        if (focusedSquareIndex == 0) {
            newIndex = crosswordSize - 1
        } else {
            newIndex = potentialNewIndex < 0
                ? crosswordSize + potentialNewIndex - 1
                : potentialNewIndex
        }
        while (crossword.grid[newIndex] == ".") {
            potentialNewIndex = newIndex - crosswordWidth
            newIndex = potentialNewIndex < 0
                ? crosswordSize + potentialNewIndex - 1
                : potentialNewIndex
        }
        changeFocusedSquareIndex(to: newIndex)
    }
    
    func goDownASquare() -> Void {
        var potentialNewIndex = focusedSquareIndex + crosswordWidth
        var newIndex: Int
        if (focusedSquareIndex == crosswordSize - 1) {
            newIndex = 0
        } else {
            newIndex = potentialNewIndex >= crosswordSize
                ? potentialNewIndex - (crosswordSize - 1)
                : potentialNewIndex
        }
        while (crossword.grid[newIndex] == ".") {
            potentialNewIndex = newIndex + crossword.cols
            newIndex = potentialNewIndex >= crosswordSize
                ? potentialNewIndex - (crosswordSize - 1)
                : potentialNewIndex
        }
        changeFocusedSquareIndex(to: newIndex)
    }
    
    func goLeftASquare() -> Void {
        var potentialNewIndex = focusedSquareIndex - 1
        var newIndex: Int = focusedSquareIndex == 0
            ? crosswordSize - 1
            : potentialNewIndex
        while (crossword.grid[newIndex] == ".") {
            potentialNewIndex = newIndex - 1
            newIndex = focusedSquareIndex == 0
                ? crosswordSize - 1
                : potentialNewIndex
        }
        changeFocusedSquareIndex(to: newIndex)
    }
    
    func goRightASquare() -> Void {
        var potentialNewIndex = focusedSquareIndex + 1
        var newIndex: Int = focusedSquareIndex == crosswordSize - 1
            ? 0
            : potentialNewIndex
        while (crossword.grid[newIndex] == ".") {
            potentialNewIndex = newIndex + 1
            newIndex = focusedSquareIndex == crosswordSize - 1
                ? 0
                : potentialNewIndex
        }
        changeFocusedSquareIndex(to: newIndex)
    }
    
    func goToNextClueSquare() -> Void {
        if (acrossFocused) {
            goToNextAcrossClueSquare()
        } else {
            goToNextDownClueSquare()
        }
    }
    
    private func goToNextAcrossClueSquare() -> Void {
        var newIndex = focusedSquareIndex
        while (crossword.grid[newIndex] != ".") {
            if ((newIndex + 1) % crosswordWidth == 0) {
                break
            }
            newIndex += 1
        }
        newIndex += 1
        if (newIndex == crosswordSize) {
            newIndex = 0
            changeOrientation()
        }
        while (crossword.grid[newIndex] == ".") {
            newIndex += 1
        }
        changeFocusedSquareIndex(to: newIndex)
    }
    
    private func goToNextDownClueSquare() -> Void {
        var newIndex = focusedSquareIndex
        // Get to the start of the down clue -- the top of the current word
        while (newIndex >= crosswordWidth) {
            let potentialNewIndex = newIndex - crosswordWidth
            if (crossword.grid[potentialNewIndex] == ".") {
                break
            }
            newIndex = newIndex - crosswordWidth
        }

        // Start from the top of this word
        changeFocusedSquareIndex(to: newIndex)
        newIndex += 1

        // Get to the next square if this is the first row
        // or get to the first space with a black square above it from this point
        while(newIndex != crosswordSize) {
            if ((newIndex < crossword.cols || (crossword.grid[newIndex - crosswordWidth] == "."))
                && (crossword.grid[newIndex] != ".")) {
                    changeFocusedSquareIndex(to: newIndex)
                    return
            }
            newIndex += 1
        }

        // Start at the beginning of the puzzle again, with across oriented this time.
        newIndex = 0
        changeOrientation()
        changeFocusedSquareIndex(to: newIndex)
        
    }
    
    func setCurrentClue() -> Void {
        let newModel = squareModels[focusedSquareIndex]
        let newClue = acrossFocused ? newModel.acrossClue : newModel.downClue
        changeClue(to: newClue)
    }
    
    func changeOrientation() -> Void {
        unsetPreviousHighlighting(acrossFocusedChanged: true)
        setCurrentHighlighting()
        setCurrentClue()
    }
    
    func handleBackspace() -> Void {
        if (acrossFocused) {
            goLeftASquare()
            self.textState = .backspacedTo
        } else {
            goUpASquare()
            self.textState = .backspacedTo
        }
    }
    
    func handleLetterTyped() -> Void {
        changeShouldSendMessage(to: true)
        if (acrossFocused) {
            goRightASquare()
        } else {
            if (focusedSquareIndex > (crosswordSize - crosswordWidth)
                || (focusedSquareIndex + crosswordWidth < crosswordSize && crossword.grid[focusedSquareIndex + crosswordWidth] == ".")) {
                goToNextDownClueSquare()
            } else {
                goDownASquare()
            }
        }
        textState = .typedTo
    }
    
    func handleShouldBackspaceState() -> Void {
        if (acrossFocused) {
            goLeftASquare()
        } else {
            goUpASquare()
        }
        textState = .typedTo
    }
    
    func checkCrossword() -> Void {
        if (correctSquares == crosswordSize) {
            squareModels.forEach({ squareModel in
                squareModel.squareState = .correct
            })
        }
    }
}
