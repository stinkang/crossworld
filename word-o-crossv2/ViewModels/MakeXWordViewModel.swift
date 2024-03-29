//
//  MakeXWordViewModel.swift
//  word_o_crossv2
//
//  Created by Austin Kang on 10/22/22.
//

import Foundation

class MakeXWordViewModel: ObservableObject {
    @Published var cols: Int
    //@Published var grid: [String]
    @Published var editGridMode = true
    @Published var focusedIndex: Int
    @Published var acrossFocused = true
    @Published var editClueTapped = false
    @Published var indexToAcrossCluesMap = Dictionary<Int, String>()
    @Published var indexToDownCluesMap = Dictionary<Int, String>()
    var clueText = ""
    
    var size: Int {
        get {
            cols * cols
        }
    }
    
    var previousFocusedIndex: Int
    var squareModels: [MakeXWordSquareViewModel]
    
    init(cols: Int) {
        self.cols = cols
        //self.grid = ["X", "X", "X", "X", "X", "X", "X", "X", "X"]
        self.focusedIndex = 0
        self.previousFocusedIndex = 0
        squareModels = []
        (0...(cols * cols) - 1).forEach { index in
            squareModels.append(MakeXWordSquareViewModel(acrossClue: "", downClue: "", answerText: ""))
        }
        numberSquares()
    }
    
//    func changeCols(to cols: Int) {
//        squareModels = []
//        (0...(cols * cols) - 1).forEach { index in
//            squareModels.append(MakeXWordSquareViewModel(acrossClue: "", downClue: "", answerText: ""))
//        }
//        self.cols = cols
//    }
    
    func changeEditGridMode(to editGridMode: Bool) {
        self.editGridMode = editGridMode
        if !self.editGridMode {
            numberSquares()
        }
    }
    
    func changeFocusedIndex(to index: Int) {
        previousFocusedIndex = focusedIndex
        focusedIndex = index
        if acrossFocused {
            indexToAcrossCluesMap[squareModels[previousFocusedIndex].acrossClueIndex] = clueText
            clueText = indexToAcrossCluesMap[squareModels[focusedIndex].acrossClueIndex]!
        } else {
            indexToDownCluesMap[squareModels[previousFocusedIndex].downClueIndex] = clueText
            clueText = indexToDownCluesMap[squareModels[focusedIndex].downClueIndex]!
        }
        unsetPreviousHighlighting(acrossFocusedChanged: false)
        setCurrentHighlighting()
    }
    
    func changeAcrossFocused(to value: Bool) {
        acrossFocused = value
        if acrossFocused {
            indexToDownCluesMap[squareModels[focusedIndex].downClueIndex] = clueText
            clueText = indexToAcrossCluesMap[squareModels[focusedIndex].acrossClueIndex]!
        } else {
            indexToAcrossCluesMap[squareModels[focusedIndex].acrossClueIndex] = clueText
            clueText = indexToDownCluesMap[squareModels[focusedIndex].downClueIndex]!
        }
        unsetPreviousHighlighting(acrossFocusedChanged: true)
        setCurrentHighlighting()
    }
    
    func handleLetterTyped() {
        changeFocusedIndex(to: acrossFocused ? getRightASquare() : getDownASquare())
    }
    
    func handleBackspace() {
        let newIndex = acrossFocused ? getLeftASquare() : getUpASquare()
        changeFocusedIndex(to: newIndex)
    }
    
    func handleBackspaceFromEmptySquare() {
        handleBackspace()
        squareModels[focusedIndex].changeCurrentText(to: "")
    }
    
    func goLeftASquare() -> Void {
        changeFocusedIndex(to: getLeftASquare())
    }
    
    func goRightASquare() -> Void {
        changeFocusedIndex(to: getRightASquare())
    }
    
    func goUpASquare() -> Void {
        changeFocusedIndex(to: getUpASquare())
    }
    
    func goDownASquare() -> Void {
        changeFocusedIndex(to: getDownASquare())
    }
    
    func goToNextAcrossClueSquare() -> Void {
        changeFocusedIndex(to: getNextAcrossClueSquare())
    }
    
    func goToPreviousAcrossClueSquare() -> Void {
        changeFocusedIndex(to: getPreviousAcrossClueSquare())
    }
    
    func goToNextDownClueSquare(from: Int? = nil) -> Void {
        changeFocusedIndex(to: getNextDownClueSquare())
    }
    
    func goToPreviousDownClueSquare(from: Int? = nil) -> Void {
        changeFocusedIndex(to: getPreviousDownClueSquare())
    }
    
    func getLeftASquare() -> Int {
        var newIndex = focusedIndex == 0 ? size - 1 : focusedIndex - 1
        while (!squareModels[newIndex].isWhite) {
            newIndex = newIndex == 0 ? size - 1 : newIndex - 1
        }
        return newIndex
    }
    
    func getUpASquare() -> Int {
        var newIndex = focusedIndex - cols

        if (newIndex < 0 || !squareModels[newIndex].isWhite) {
            newIndex = getPreviousDownClueSquare()
            
            // get to the bottom of the current word
            while (newIndex < size - cols && squareModels[newIndex + cols].isWhite) {
                newIndex += cols
            }
        }
        
        return newIndex
    }
    
    func getRightASquare() -> Int {
        var newIndex = focusedIndex == size - 1 ? 0 : focusedIndex + 1
        while (!squareModels[newIndex].isWhite) {
            newIndex = newIndex == size - 1 ? 0 : newIndex + 1
        }
        return newIndex
    }
    
    func getNextAcrossClueSquare(from: Int? = nil) -> Int {
        let startingIndex = from != nil ? from! : focusedIndex
        var newIndex = startingIndex
        while (squareModels[newIndex].isWhite) {
            if ((newIndex + 1) % cols == 0) {
                break
            }
            newIndex += 1
        }
        newIndex += 1
        if (newIndex == size) {
            newIndex = 0
        }
        while (!squareModels[newIndex].isWhite) {
            newIndex += 1
            if (newIndex == size) {
                newIndex = 0
            }
        }
        return newIndex
    }
    
    func getPreviousAcrossClueSquare() -> Int {
        var newIndex = focusedIndex - 1 >= 0 ? focusedIndex - 1 : size - 1
        while (!squareModels[newIndex].isWhite) {
            newIndex = newIndex > 0 ? newIndex - 1 : size - 1
        }
        while (newIndex != 0 && squareModels[newIndex - 1].isWhite && newIndex % cols != 0) {
            newIndex -= 1
        }
        return newIndex
    }
    
    func getDownASquare() -> Int {
        var newIndex = focusedIndex + cols
        if (newIndex >= size || !squareModels[newIndex].isWhite) {
            newIndex = getNextDownClueSquare()
        }
        return newIndex
    }
    
    func getPreviousDownClueSquare(from: Int? = nil) -> Int {
        let startingIndex = from != nil ? from! : focusedIndex
        var newIndex = startingIndex
        // get to the top of the current word
        while (newIndex >= cols && squareModels[newIndex - cols].isWhite) {
            newIndex -= cols
        }

        if newIndex == startingIndex {
            // start looking at the square left of this one
            newIndex = newIndex - 1 >= 0 ? newIndex - 1 : size - 1

            // get to the first space with a black square or nothing above it from this point
            while(!squareModels[newIndex].isWhite || (newIndex >= cols && squareModels[newIndex - cols].isWhite)) {
                newIndex = newIndex - 1 >= 0 ? newIndex - 1 : size - 1
            }
        }

        return newIndex
    }
    
    func getNextDownClueSquare(from: Int? = nil) -> Int {
        var newIndex = from != nil ? from! : focusedIndex
        
        // get to the top of the current word
        while (newIndex >= cols && squareModels[newIndex - cols].isWhite) {
            newIndex -= cols
        }
        
        // start looking at the square right of this one
        newIndex += 1

        // get to the first space with a black square or nothing above it from this point
        while(!squareModels[newIndex].isWhite || (newIndex >= cols && squareModels[newIndex - cols].isWhite)) {
            newIndex = newIndex + 1 < size ? newIndex + 1 : 0
        }

        return newIndex
    }
    
    func getNextDownClueSquareFromCurrentPoint(from: Int? = nil) -> Int {
        var newIndex = from != nil ? from! : focusedIndex
        
        // start looking at the square right of this one
        newIndex = newIndex + 1 < size ? newIndex + 1 : 0

        // get to the first space with a black square or nothing above it from this point
        while(!squareModels[newIndex].isWhite || (newIndex >= cols && squareModels[newIndex - cols].isWhite)) {
            newIndex = newIndex + 1 < size ? newIndex + 1 : 0
        }

        return newIndex
    }
    
    func setCurrentHighlighting() -> Void {
        var indexToSet = focusedIndex
        if acrossFocused /* across */ {
            indexToSet-=1
            // get all squares to the left of position
            while (indexToSet >= 0 && indexToSet % cols != (cols - 1)
                   && squareModels[indexToSet].isWhite) {
                squareModels[indexToSet].squareState = .highlighted
                indexToSet-=1
            }
            indexToSet = focusedIndex + 1
            // get all squares to the right of position
            while (indexToSet % cols != 0
                   && squareModels[indexToSet].isWhite) {
                squareModels[indexToSet].squareState = .highlighted
                indexToSet+=1
            }
        } else /* down */ {
            // get all squares above position
            while (indexToSet >= 0 && squareModels[indexToSet].isWhite) {
                squareModels[indexToSet].squareState = .highlighted
                indexToSet-=cols
            }
            indexToSet = focusedIndex
            // get all squares below position
            while (indexToSet <= size - 1
                   && squareModels[indexToSet].isWhite) {
                squareModels[indexToSet].squareState = .highlighted
                indexToSet+=cols
            }
        }
        squareModels[focusedIndex].squareState = .focused
    }
    
    func unsetPreviousHighlighting(acrossFocusedChanged: Bool) -> Void {
        // if acrossFocused was changed, get the one it changed from
        let positionToUnset = acrossFocusedChanged
            ? focusedIndex
            : previousFocusedIndex
        let orientationToUnset = acrossFocusedChanged
            ? !acrossFocused
            : acrossFocused
        var indexToUnset = positionToUnset
        if orientationToUnset /* (across) */ {
            // get all squares to the left of position
            indexToUnset-=1
            while (indexToUnset >= 0 && indexToUnset % cols != (cols - 1)
                  && squareModels[indexToUnset].isWhite) {
                squareModels[indexToUnset].squareState = .unfocused
                indexToUnset-=1
            }
            indexToUnset = positionToUnset + 1
            // get all squares to the right of position
            while (indexToUnset % cols != 0
                   && squareModels[indexToUnset].isWhite) {
                squareModels[indexToUnset].squareState = .unfocused
                indexToUnset+=1
            }
        } else /* down */ {
            // get all squares above position
            while (indexToUnset >= 0 && squareModels[indexToUnset].isWhite) {
                squareModels[indexToUnset].squareState = .unfocused
                indexToUnset-=cols
            }
            indexToUnset = positionToUnset
            // get all squares below position
            while (indexToUnset < size && squareModels[indexToUnset].isWhite) {
                squareModels[indexToUnset].squareState = .unfocused
                indexToUnset+=cols
            }
        }
        squareModels[previousFocusedIndex].squareState = .unfocused
    }
    
    func numberSquares() {
        
        // not ideal
        indexToDownCluesMap.removeAll()
        indexToAcrossCluesMap.removeAll()
        
        var startingIndex = cols*cols - 1
        while (!squareModels[startingIndex].isWhite) {
            startingIndex -= 1
        }
        var index = min(getNextAcrossClueSquare(from: startingIndex), getNextDownClueSquareFromCurrentPoint(from: startingIndex))
        var clueNumber = 1
        for i in 0...cols*cols - 1 {
            squareModels[i].clueNumber = 0
        }
        while squareModels[index].clueNumber == 0 {
            squareModels[index].clueNumber = clueNumber
            clueNumber += 1
            let nextAcrossClueSquare = getNextAcrossClueSquare(from: index)
            let nextDownClueSquare = getNextDownClueSquareFromCurrentPoint(from: index)
            if squareModels[nextAcrossClueSquare].clueNumber != 0 {
                index = nextDownClueSquare
            } else if squareModels[nextDownClueSquare].clueNumber != 0 {
                index = nextAcrossClueSquare
            } else {
                index = min(nextDownClueSquare, nextAcrossClueSquare)
            }
            
            if index == nextDownClueSquare {
                var downClueSettingIndex = index
                while (downClueSettingIndex <= size - 1 && squareModels[downClueSettingIndex].isWhite) {
                    squareModels[downClueSettingIndex].downClueIndex = index
                    downClueSettingIndex+=cols
                }
                indexToDownCluesMap[index] = ""
            }
            
            if index == nextAcrossClueSquare {
                var acrossClueSettingIndex = index
                squareModels[acrossClueSettingIndex].acrossClueIndex = index
                acrossClueSettingIndex+=1
                while (acrossClueSettingIndex % cols != 0 && squareModels[acrossClueSettingIndex].isWhite) {
                    squareModels[acrossClueSettingIndex].acrossClueIndex = index
                    acrossClueSettingIndex+=1
                }
                indexToAcrossCluesMap[index] = ""
            }
        }
    }

}
