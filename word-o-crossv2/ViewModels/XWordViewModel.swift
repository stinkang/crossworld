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
        self.textState = textState
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
            while (indexToUnset <= self.crosswordSize - 1
                   && self.crossword.grid[indexToUnset] != ".") {
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
        if acrossFocused {
            goLeftASquare()
        } else {
            goUpASquare()
        }
    }
    
    func goToNextSquare() -> Void {
        if acrossFocused {
            goRightASquare()
        } else {
            goDownASquare()
        }
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
        if (crossword.grid[newIndex] == "." || newIndex < crosswordWidth) {
            goToPreviousDownClueSquare()
        } else {
            changeFocusedSquareIndex(to: newIndex)
        }
    }
    
    func goDownASquare() -> Void {
        let potentialNewIndex = focusedSquareIndex + crosswordWidth
        var newIndex: Int
        if (focusedSquareIndex == crosswordSize - 1) {
            newIndex = 0
        } else {
            newIndex = potentialNewIndex >= crosswordSize
                ? potentialNewIndex - (crosswordSize - 1)
                : potentialNewIndex
        }
        if (crossword.grid[newIndex] == "." || newIndex < crosswordWidth) {
            goToNextDownClueSquare()
        } else {
            changeFocusedSquareIndex(to: newIndex)
        }
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
    
    func goToNextAcrossClueSquare() -> Void {
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
            changeHighlightingAndClue()
        }
        while (crossword.grid[newIndex] == ".") {
            newIndex += 1
        }
        changeFocusedSquareIndex(to: newIndex)
    }
    
    func goToNextDownClueSquare() -> Void {
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
        //changeFocusedSquareIndex(to: newIndex)
        newIndex += 1

        // Get to the next square if this is the first row
        // or get to the first space with a black square above it from this point
        while(newIndex != crosswordSize) {
            if ((newIndex < crossword.size.cols || (crossword.grid[newIndex - crosswordWidth] == "."))
                && (crossword.grid[newIndex] != ".")) {
                    changeFocusedSquareIndex(to: newIndex)
                    return
            }
            newIndex += 1
        }

        // Start at the beginning of the puzzle again, with across oriented this time.
        newIndex = 0
        //changeHighlightingAndClue()
        changeFocusedSquareIndex(to: newIndex)
        
    }
    
    func jumpPrevious() -> Void {
        if (acrossFocused) {
            jumpPreviousAcross()
        } else {
            jumpPreviousDown()
        }
    }
    
    func jumpPreviousAcross() -> Void {
        
    }
    
    func jumpPreviousDown() -> Void {
        
    }
    
    func goToPreviousClueSquare() -> Void {
        if acrossFocused {
            goToPreviousAcrossClueSquare()
        } else {
            goToPreviousDownClueSquare()
        }
    }
    
    func goToPreviousAcrossClueSquare() -> Void {
        var newIndex = focusedSquareIndex - 1 >= 0 ? focusedSquareIndex - 1 : crosswordSize - 1
        // the or case: when we're at the end of a
        while (crossword.grid[newIndex] == "." || newIndex % crosswordWidth == (crosswordWidth - 1)) {
            newIndex -= 1
        }
        newIndex = newIndex >= 0 ? newIndex : crosswordSize - 1
        while (newIndex != -1 && crossword.grid[newIndex] != "."
               // haven't spilled onto the previous row
               && newIndex % crosswordWidth != (crosswordWidth - 1)) {
            newIndex -= 1
        }
        newIndex += 1
        changeFocusedSquareIndex(to: newIndex)
    }
    
    func goToPreviousDownClueSquare() -> Void {
        var newIndex = focusedSquareIndex
        // Get to the start of the down clue -- the top of the current word
        while (newIndex >= crosswordWidth) {
            let potentialNewIndex = newIndex - crosswordWidth
            if (crossword.grid[potentialNewIndex] == ".") {
                break
            }
            newIndex = potentialNewIndex
        }

        if newIndex != focusedSquareIndex {
            changeFocusedSquareIndex(to: newIndex)
        } else {
            // Start from the top of this word
            newIndex -= 1

            // Get to the previous square if this is the first row
            // or get to the first space with a black square above it to the left of this point
            while(newIndex >= 0) {
                if ((newIndex < crossword.size.cols || (crossword.grid[newIndex - crosswordWidth] == "."))
                    && (crossword.grid[newIndex] != ".")) {
                        changeFocusedSquareIndex(to: newIndex)
                        return
                }
                newIndex -= 1
            }

            // Start at the beginning of the puzzle again, with across oriented this time.
            newIndex = crosswordSize - 1
            //changeHighlightingAndClue()
            changeFocusedSquareIndex(to: newIndex)
        }
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
        if (acrossFocused) {
            goLeftASquare()
            self.textState = .backspacedTo
        } else {
            goUpASquare()
            self.textState = .backspacedTo
        }
        changeShouldSendMessage(to: true)
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
        checkCrossword()
    }
    
    func handleShouldBackspaceState() -> Void {
        if (acrossFocused) {
            goLeftASquare()
        } else {
            goUpASquare()
        }
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
