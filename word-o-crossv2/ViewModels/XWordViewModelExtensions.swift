//
//  XWordViewModelExtensions.swift
//  word_o_crossv2
//
//  Created by Austin Kang on 7/27/22.
//

import Foundation

extension XWordViewModel {
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
    
    func getPreviousDownEmptySquare(from: Int? = nil) -> Int {
        var newIndex = from != nil ? from! : focusedSquareIndex
        var lastBlankSquare = -1
        repeat {
            let potentialNewIndex = newIndex - crosswordWidth
            if (potentialNewIndex < 0 || crossword.grid[potentialNewIndex] == ".") {
                if (lastBlankSquare != -1) {
                    break
                }
                newIndex = getPreviousDownClueSquare(from: newIndex)
                // get to the bottom of the current word
                while (newIndex < crosswordSize - crosswordWidth && crossword.grid[newIndex + crosswordWidth] != ".") {
                    newIndex += crosswordWidth
                }
            } else {
                newIndex = potentialNewIndex
            }
            if squareModels[newIndex].currentText == "" {
                lastBlankSquare = newIndex
            }
        } while (newIndex != focusedSquareIndex)
        
        newIndex = newIndex == focusedSquareIndex ? getPreviousDownClueSquare() : lastBlankSquare
        
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
        let startingIndex = from != nil ? (from! == -1 ? 0 : from!) : focusedSquareIndex
        var newIndex = startingIndex
        repeat {
            newIndex = newIndex == crosswordSize - 1 ? 0 : newIndex + 1
        } while (squareModels[newIndex].currentText != "" && newIndex != startingIndex)
        
        if (newIndex == startingIndex) {
            newIndex = getNextAcrossClueSquare()
        }
        return newIndex
    }
    
    func getPreviousAcrossEmptySquare(from: Int? = nil) -> Int {
        let startingIndex = from != nil ? from! : focusedSquareIndex
        var newIndex = startingIndex == 0 ? crosswordSize - 1 : startingIndex - 1
        var lastBlankSquare = -1

        while (newIndex != startingIndex) {
            if squareModels[newIndex].currentText == "" {
                lastBlankSquare = newIndex
            }
            let nextIndex = newIndex == 0 ? crosswordSize - 1 : newIndex - 1
            if (squareModels[nextIndex].currentText == "." || nextIndex % crosswordWidth == crosswordWidth - 1) {
                if (lastBlankSquare != -1) {
                    break
                }
            }
            newIndex = nextIndex
        }
        newIndex = newIndex == startingIndex ? getPreviousAcrossClueSquare() : lastBlankSquare

        return newIndex
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
    
    func getPreviousDownClueSquare(from: Int? = nil) -> Int {
        let startingIndex = from != nil ? from! : focusedSquareIndex
        var newIndex = startingIndex
        // get to the top of the current word
        while (newIndex >= crosswordWidth && crossword.grid[newIndex - crosswordWidth] != ".") {
            newIndex -= crosswordWidth
        }

        if newIndex == startingIndex {
            // start looking at the square left of this one
            newIndex = newIndex - 1 >= 0 ? newIndex - 1 : crosswordSize - 1

            // get to the first space with a black square or nothing above it from this point
            while(crossword.grid[newIndex] == "." || (newIndex >= crosswordWidth && crossword.grid[newIndex - crosswordWidth] != ".")) {
                newIndex = newIndex - 1 >= 0 ? newIndex - 1 : crosswordSize - 1
            }
        }

        return newIndex
    }
}
