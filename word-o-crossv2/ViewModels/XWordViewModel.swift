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
    @Published var otherPlayersMove: MoveData
    @Published var otherPlayersFocusedSquareIndex: Int
    @Published var otherPlayersAcrossFocused: Bool
    @Published var textState: TextState
    @Published var solvedSheetPresented: Bool
    @Published var secondsElapsed: Int64
    var solved: Bool
    var shouldSendMessage: Bool
    var shouldSendCrossword: Bool
    var previousFocusedSquareIndex: Int
    var otherPlayersPreviousFocusedSquareIndex: Int
    var currentlyOtherPlayersChanges: Bool
    var crosswordWidth: Int
    var crosswordSize: Int
    var crossword: Crossword
    var squareModels: [SquareModel]
    var correctSquares: Int
    var totalSpaces: Int
    var entries: [String]

    init(crossword: Crossword) {
        clue = ""
        typedText = ""
        focusedSquareIndex = 0
        acrossFocused = true
        otherPlayersMove = MoveData(text: "", previousIndex: 0, currentIndex: 0, acrossFocused: true, wasTappedOn: false)
        otherPlayersFocusedSquareIndex = 0
        otherPlayersAcrossFocused = true
        shouldSendMessage = false
        shouldSendCrossword = false
        previousFocusedSquareIndex = 0
        otherPlayersPreviousFocusedSquareIndex = 0
        currentlyOtherPlayersChanges = false
        solved = false
        solvedSheetPresented = false
        crosswordWidth = 0
        crosswordSize = 0
        textState = .typedTo
        self.crossword = Crossword()
        squareModels = []
        correctSquares = 0
        totalSpaces = 0
        crosswordWidth = crossword.size.cols
        crosswordSize = crossword.grid.count
        entries = crossword.entries
        self.secondsElapsed = crossword.secondsElapsed
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
        
        var startingCorrectness = 0
        (0...crosswordSize - 1).forEach { index in
            if (crossword.grid[index] == ".") {
                startingCorrectness += 1
                squareModels[index].changeCurrentText(to: ".")
            }
        }
        self.correctSquares = startingCorrectness
        self.totalSpaces = crossword.grid.count - startingCorrectness
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
    
    func changeShouldSendCrossword(to shouldSendCrossword: Bool) {
        self.shouldSendCrossword = shouldSendCrossword
    }
    
    func changeOtherPlayersMove(to otherPlayersMove: MoveData) {
        self.otherPlayersMove = otherPlayersMove
    }

    func changeOtherPlayersFocusedSquareIndex(to otherPlayersfocusedSquareIndex: Int) {
        self.otherPlayersPreviousFocusedSquareIndex = self.otherPlayersFocusedSquareIndex
        self.otherPlayersFocusedSquareIndex = otherPlayersfocusedSquareIndex
    }

    func changeAcrossFocused(to acrossFocused: Bool) {
        self.acrossFocused = acrossFocused
    }
    
    func changeOtherPlayersAcrossFocused(to otherPlayersAcrossFocused: Bool) {
        self.otherPlayersAcrossFocused = otherPlayersAcrossFocused
    }
    
    func changeCurrentlyOtherPlayersChanges( currentlyOtherPlayersChanges: Bool) {
        self.currentlyOtherPlayersChanges = currentlyOtherPlayersChanges
    }
    
    func changeTextState(to textState: TextState) {
        if self.textState == .letterTyped && textState == .letterTyped {
            self.textState = .letterTyped2
        } else {
            self.textState = textState
        }
    }
    
    func changeFocus() -> Void {
        unsetPreviousHighlighting(acrossFocusedChanged: false)
        setCurrentHighlighting()
        setCurrentClue()
        changeTypedText(to: "")
    }
    
    func unsetPreviousHighlighting(acrossFocusedChanged: Bool) -> Void {
        // if acrossFocused was changed, get the one it changed from
        let positionToUnset = acrossFocusedChanged
            ? focusedSquareIndex
            : previousFocusedSquareIndex
        let orientationToUnset = acrossFocusedChanged
            ? !acrossFocused
            : acrossFocused
        var indexToUnset = positionToUnset
        if orientationToUnset /* (across) */ {
            // get all squares to the left of position
            indexToUnset-=1
            while (indexToUnset >= 0 && indexToUnset % self.crosswordWidth != (self.crosswordWidth - 1)
                  && self.crossword.grid[indexToUnset] != ".") {
                squareModels[indexToUnset].changeSquareState(to: .unfocused)
                indexToUnset-=1
            }
            indexToUnset = positionToUnset + 1
            // get all squares to the right of position
            while (indexToUnset % self.crosswordWidth != 0
                   && self.crossword.grid[indexToUnset] != ".") {
                squareModels[indexToUnset].changeSquareState(to: .unfocused)
                indexToUnset+=1
            }
        } else /* down */ {
            // get all squares above position
            while (indexToUnset >= 0 && self.crossword.grid[indexToUnset] != ".") {
                squareModels[indexToUnset].changeSquareState(to: .unfocused)
                indexToUnset-=self.crosswordWidth
            }
            indexToUnset = positionToUnset
            // get all squares below position
            while (indexToUnset < self.crosswordSize && self.crossword.grid[indexToUnset] != ".") {
                squareModels[indexToUnset].changeSquareState(to: .unfocused)
                indexToUnset+=self.crosswordWidth
            }
        }
        squareModels[previousFocusedSquareIndex].changeSquareState(to: .unfocused)
    }
    
    func setCurrentHighlighting() -> Void {
        var indexToSet = focusedSquareIndex
        if acrossFocused /* (across) */ {
            indexToSet-=1
            // get all squares to the left of position
            while (indexToSet >= 0 && indexToSet % self.crosswordWidth != (self.crosswordWidth - 1)
                  && self.crossword.grid[indexToSet] != ".") {
                squareModels[indexToSet].changeSquareState(to: .highlighted)
                indexToSet-=1
            }
            indexToSet = focusedSquareIndex + 1
            // get all squares to the right of position
            while (indexToSet % self.crosswordWidth != 0
                   && self.crossword.grid[indexToSet] != ".") {
                squareModels[indexToSet].changeSquareState(to: .highlighted)
                indexToSet+=1
            }
        } else /* down */ {
            // get all squares above position
            while (indexToSet >= 0 && self.crossword.grid[indexToSet] != ".") {
                squareModels[indexToSet].changeSquareState(to: .highlighted)
                indexToSet-=self.crosswordWidth
            }
            indexToSet = focusedSquareIndex
            // get all squares below position
            while (indexToSet <= self.crosswordSize - 1
                   && self.crossword.grid[indexToSet] != ".") {
                squareModels[indexToSet].changeSquareState(to: .highlighted)
                indexToSet+=self.crosswordWidth
            }
        }
        
        squareModels[focusedSquareIndex].changeSquareState(to: .focused)
    }
    
    func goToPreviousSquare() -> Void {
        let newIndex = acrossFocused ? getLeftASquare() : getUpASquare()
        changeFocusedSquareIndex(to: newIndex)
    }
    
    func goToNextSquare() -> Void {
        let newIndex = acrossFocused ? getRightASquare() : getDownASquare()
        changeFocusedSquareIndex(to: newIndex)
    }
    
    func getUpASquare() -> Int {
        var newIndex = focusedSquareIndex - crosswordWidth

        if (newIndex < 0 || crossword.grid[newIndex] == ".") {
            newIndex = getPreviousDownClueSquare()
            
            // get to the bottom of the current word
            while (newIndex < crosswordSize - crosswordWidth && crossword.grid[newIndex + crosswordWidth] != ".") {
                newIndex += crosswordWidth
            }
        }
        
        return newIndex
    }
    
    func getDownASquare() -> Int {
        var newIndex = focusedSquareIndex + crosswordWidth
        if (newIndex >= crosswordSize || crossword.grid[newIndex] == ".") {
            newIndex = getNextDownClueSquare()
        }
        return newIndex
    }
    
    func getNextDownEmptySquare(from: Int? = nil) -> Int {
        var newIndex = from != nil ? from! : focusedSquareIndex
        repeat {
            newIndex = newIndex + crosswordWidth
            if (newIndex >= crosswordSize || crossword.grid[newIndex] == ".") {
                newIndex = getNextDownClueSquare(from: newIndex)
            }
            if squareModels[newIndex].currentText == "" {
                break
            }
        } while (newIndex != focusedSquareIndex)
        
        if (newIndex == focusedSquareIndex) {
            newIndex = getNextDownClueSquare()
        }
        
        return newIndex
    }
    
    func getLeftASquare() -> Int {
        var newIndex = focusedSquareIndex == 0 ? crosswordSize - 1 : focusedSquareIndex - 1
        while (crossword.grid[newIndex] == ".") {
            newIndex = newIndex == 0 ? crosswordSize - 1 : newIndex - 1
        }
        return newIndex
    }
    
    func getRightASquare() -> Int {
        var newIndex = focusedSquareIndex == crosswordSize - 1 ? 0 : focusedSquareIndex + 1
        while (crossword.grid[newIndex] == ".") {
            newIndex = newIndex == crosswordSize - 1 ? 0 : newIndex + 1
        }
        return newIndex
    }
    
    func getNextAcrossEmptySquare(from: Int? = nil) -> Int {
        let startingIndex = from != nil ? from! : focusedSquareIndex
        var newIndex = startingIndex == crosswordSize - 1 ? 0 : startingIndex + 1
        while (squareModels[newIndex].currentText != "" && newIndex != startingIndex) {
            newIndex = newIndex == crosswordSize - 1 ? 0 : newIndex + 1
        }
        if (newIndex == startingIndex) {
            newIndex = getNextAcrossClueSquare()
        }
        return newIndex
    }
    
    func jumpToNextSquare() -> Void {
        let newIndex = acrossFocused
        ? getNextAcrossEmptySquare(from: getNextAcrossClueSquare())
        : getNextDownEmptySquare(from: getNextDownClueSquare() - crosswordWidth)

        changeFocusedSquareIndex(to: newIndex)
    }
    
    func jumpToPreviousSquare() -> Void {
        let newIndex = acrossFocused ? getPreviousAcrossClueSquare() : getPreviousDownClueSquare()
        changeFocusedSquareIndex(to: newIndex)
    }
    

    
    func getNextAcrossClueSquare() -> Int {
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
        }
        while (crossword.grid[newIndex] == ".") {
            newIndex += 1
        }
        return newIndex
    }
    
    func getPreviousAcrossClueSquare() -> Int {
        var newIndex = focusedSquareIndex - 1 >= 0 ? focusedSquareIndex - 1 : crosswordSize - 1
        while (crossword.grid[newIndex] == ".") {
            newIndex = newIndex > 0 ? newIndex - 1 : crosswordSize - 1
        }
        while (newIndex != 0 && crossword.grid[newIndex - 1] != "." && newIndex % crosswordWidth != 0) {
            newIndex -= 1
        }
        return newIndex
    }
    
    func getNextDownClueSquare(from: Int? = nil) -> Int {
        var newIndex = from != nil ? from! : focusedSquareIndex
        
        // get to the top of the current word
        while (newIndex >= crosswordWidth && crossword.grid[newIndex - crosswordWidth] != ".") {
            newIndex -= crosswordWidth
        }
        
        // start looking at the square right of this one
        newIndex += 1

        // get to the first space with a black square or nothing above it from this point
        while(crossword.grid[newIndex] == "." || (newIndex >= crosswordWidth && crossword.grid[newIndex - crosswordWidth] != ".")) {
            newIndex = newIndex + 1 < crosswordSize ? newIndex + 1 : 0
        }

        return newIndex
    }
    
    func getPreviousDownClueSquare() -> Int {
        var newIndex = focusedSquareIndex
        
        // get to the top of the current word
        while (newIndex >= crosswordWidth && crossword.grid[newIndex - crosswordWidth] != ".") {
            newIndex -= crosswordWidth
        }

        if newIndex == focusedSquareIndex {
            // start looking at the square left of this one
            newIndex = newIndex - 1 >= 0 ? newIndex - 1 : crosswordSize - 1

            // get to the first space with a black square or nothing above it from this point
            while(crossword.grid[newIndex] == "." || (newIndex >= crosswordWidth && crossword.grid[newIndex - crosswordWidth] != ".")) {
                newIndex = newIndex - 1 >= 0 ? newIndex - 1 : crosswordSize - 1
            }
        }
        
        return newIndex
    }
    
    func setCurrentClue() -> Void {
        let newModel = squareModels[focusedSquareIndex]
        let newClue = acrossFocused ? newModel.acrossClue : newModel.downClue
        changeClue(to: newClue)
    }
    
    func changeHighlightingAndClue() -> Void {
        unsetPreviousHighlighting(acrossFocusedChanged: true)
        setCurrentHighlighting()
        setCurrentClue()
    }
    
    
    func changeOrientation() {
        changeAcrossFocused(to: !acrossFocused)
        changeHighlightingAndClue()
    }
    
    func handleBackspace() -> Void {
        let newIndex = acrossFocused ? getLeftASquare() : getUpASquare()
        changeFocusedSquareIndex(to: newIndex)
        self.textState = .backspacedTo
        changeShouldSendMessage(to: true)
    }
    
    func handleLetterTyped() -> Void {
        changeShouldSendMessage(to: true)
        let newIndex = acrossFocused ? getNextAcrossEmptySquare() : getNextDownEmptySquare()
        changeFocusedSquareIndex(to: newIndex)
        textState = .typedTo
        checkCrossword()
    }
    
    func handleShouldBackspaceState() -> Void {
        let newIndex = acrossFocused ? getLeftASquare() : getUpASquare()
        changeFocusedSquareIndex(to: newIndex)
        textState = .typedTo
    }
    
    func incrementCorrectSquares() -> Void {
        correctSquares += 1
    }
    
    func decrementCorrectSquares() -> Void {
        correctSquares -= 1
    }
    
    func checkCrossword() -> Void {
        if (correctSquares == crosswordSize) {
            squareModels.forEach({ squareModel in
                squareModel.squareState = .correct
            })
            solvedSheetPresented = true
            solved = true
            crossword.solved = true
        }
    }
    
    
    // MARK: OTHER PLAYER'S CHANGES
    func changeOtherPlayersFocus() -> Void {
        unsetOtherPlayersPreviousHighlighting(acrossFocusedChanged: false)
        setOtherPlayersCurrentHighlighting()
    }

    func unsetOtherPlayersPreviousHighlighting(acrossFocusedChanged: Bool) -> Void {
        // if acrossFocused was changed, get the one it changed from
        let indexToUnset = acrossFocusedChanged
            ? otherPlayersFocusedSquareIndex
            : otherPlayersPreviousFocusedSquareIndex
        let orientationToUnset = acrossFocusedChanged
            ? !otherPlayersAcrossFocused
            : otherPlayersAcrossFocused

        let clues: Dictionary<String, String> = (crossword.tagsToCluesMap[indexToUnset])
        let clueName = clues[orientationToUnset ? "A" : "D"]
        let clueTags: Array<Int> = (crossword.cluesToTagsMap[clueName!])!
        for clueTag in clueTags {
            squareModels[clueTag].changeSquareState(to: .unfocused)
        }
    }
    
    func setOtherPlayersCurrentHighlighting() -> Void {
        let clues: Dictionary<String, String> = (crossword.tagsToCluesMap[otherPlayersFocusedSquareIndex])
        let clueName = clues[otherPlayersAcrossFocused ? "A" : "D"]
        let clueTags: Array<Int> = (crossword.cluesToTagsMap[clueName!])!
        for clueTag in clueTags {
            squareModels[clueTag].changeSquareState(to: .otherPlayerHighlighted)
        }
        squareModels[otherPlayersFocusedSquareIndex].changeSquareState(to: .otherPlayerFocused)
    }
    
    func changeOtherPlayersHighlighting() -> Void {
        unsetOtherPlayersPreviousHighlighting(acrossFocusedChanged: true)
        setOtherPlayersCurrentHighlighting()
    }

}
