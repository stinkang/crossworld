//
//  CrosswordView.swift
//  word-o-crossv2
//
//  Created by Austin Kang on 11/23/21.
//

import SwiftUI

enum TextState {
    case typedTo
    case tappedOn
    case letterTyped
    case backspacedTo
    case shouldGoBackOne
}

class SquareModelStore {

    var models: [SquareModel] = []

    init(crossword: Crossword) {
        (0...crossword.grid.count - 1).forEach { index in
            var acrossClue: String = ""
            var downClue: String = ""
            if (crossword.grid[index] != ".") {
                acrossClue = crossword.clueNamesToCluesMap[crossword.tagsToCluesMap[index]["A"]!]!
                downClue = crossword.clueNamesToCluesMap[crossword.tagsToCluesMap[index]["D"]!]!
            }
            models.append(SquareModel(acrossClue: acrossClue, downClue: downClue))
        }
    }
}

struct XWordView: View {
    var crossword: Crossword
    let squareModelStore: SquareModelStore
    @State var acrossFocused: Bool
    @State var textState: TextState
    @StateObject var xWordViewModel: XWordViewModel = XWordViewModel()

    
    var boxWidth: CGFloat {
        let maxSize: CGFloat = 40.0
        let defaultSize: CGFloat = (UIScreen.screenWidth-5)/CGFloat(crossword.cols)
        return min(defaultSize, maxSize)
    }
    
    init(crossword: Crossword) {
        self.crossword = crossword
        self.acrossFocused = true
        self.squareModelStore = SquareModelStore(crossword: crossword)
        self.textState = .typedTo
        self.changeFocus(index: 0)
    }

    func changeFocus(index: Int, keepOrientation: Bool = false) -> Void {
        if (index == xWordViewModel.focusedSquareIndex && !keepOrientation) {
            changeOrientation()
        } else {
            unsetHighlighting(index: xWordViewModel.focusedSquareIndex)
            xWordViewModel.changeFocusedSquareIndex(to: index)
            setHighlighting(index: xWordViewModel.focusedSquareIndex)
            let newModel = squareModelStore.models[xWordViewModel.focusedSquareIndex]
            newModel.changeSquareState(to: .focused)
            let newClue = acrossFocused ? newModel.acrossClue : newModel.downClue
            xWordViewModel.changeClue(to: newClue)
            xWordViewModel.changeTypedText(to: "")
        }
        //let currentClueName = crossword.tagsToCluesMap[focusedSquareIndex]["A"]
        //currentClue.change(to: crossword.clueNamesToCluesMap[currentClueName!]!)
    }
    
    func unsetHighlighting(index: Int) -> Void {
        let clues: Dictionary<String, String> = (crossword.tagsToCluesMap[index])
        let clueName = clues[acrossFocused ? "A" : "D"]
        let clueTags: Array<Int> = (crossword.cluesToTagsMap[clueName!])!
        for clueTag in clueTags {
            squareModelStore.models[clueTag].changeSquareState(to: .unfocused)
        }
    }
    
    func setHighlighting(index: Int) -> Void {
        let clues: Dictionary<String, String> = (crossword.tagsToCluesMap[index])
        let clueName = clues[acrossFocused ? "A" : "D"]
        let clueTags: Array<Int> = (crossword.cluesToTagsMap[clueName!])!
        for clueTag in clueTags {
            squareModelStore.models[clueTag].changeSquareState(to: .highlighted)
        }
    }
    
    func goUpASquare() -> Void {
        var potentialNewIndex = xWordViewModel.focusedSquareIndex - crossword.cols
        var newIndex: Int
        if (xWordViewModel.focusedSquareIndex == 0) {
            newIndex = crossword.grid.count - 1
        } else {
            newIndex = potentialNewIndex < 0
                ? crossword.grid.count + potentialNewIndex - 1
                : potentialNewIndex
        }
        while (crossword.grid[newIndex] == ".") {
            potentialNewIndex = newIndex - crossword.cols
            newIndex = potentialNewIndex < 0
                ? crossword.grid.count + potentialNewIndex - 1
                : potentialNewIndex
        }
        changeFocus(index: newIndex)
    }
    
    func goDownASquare() -> Void {
        var potentialNewIndex = xWordViewModel.focusedSquareIndex + crossword.cols
        var newIndex: Int
        if (xWordViewModel.focusedSquareIndex == crossword.grid.count - 1) {
            newIndex = 0
        } else {
            newIndex = potentialNewIndex >= crossword.grid.count
                ? potentialNewIndex - (crossword.grid.count - 1)
                : potentialNewIndex
        }
        while (crossword.grid[newIndex] == ".") {
            potentialNewIndex = newIndex + crossword.cols
            newIndex = potentialNewIndex >= crossword.grid.count
                ? potentialNewIndex - (crossword.grid.count - 1)
                : potentialNewIndex
        }
        changeFocus(index: newIndex)
    }
    
    func goLeftASquare() -> Void {
        var potentialNewIndex = xWordViewModel.focusedSquareIndex - 1
        var newIndex: Int = xWordViewModel.focusedSquareIndex == 0
            ? crossword.grid.count - 1
            : potentialNewIndex
        while (crossword.grid[newIndex] == ".") {
            potentialNewIndex = newIndex - 1
            newIndex = xWordViewModel.focusedSquareIndex == 0
                ? crossword.grid.count - 1
                : potentialNewIndex
        }
        changeFocus(index: newIndex)
    }
    
    func goRightASquare() -> Void {
        var potentialNewIndex = xWordViewModel.focusedSquareIndex + 1
        var newIndex: Int = xWordViewModel.focusedSquareIndex == crossword.grid.count - 1
            ? 0
            : potentialNewIndex
        while (crossword.grid[newIndex] == ".") {
            potentialNewIndex = newIndex + 1
            newIndex = xWordViewModel.focusedSquareIndex == crossword.grid.count - 1
                ? 0
                : potentialNewIndex
        }
        changeFocus(index: newIndex)
    }
    
    func goToNextClueSquare() -> Void {
        if (acrossFocused) {
            goToNextAcrossClueSquare()
        } else {
            goToNextDownClueSquare()
        }
    }
    
    private func goToNextAcrossClueSquare() -> Void {
        var newIndex = xWordViewModel.focusedSquareIndex
        while (crossword.grid[newIndex] != ".") {
            if ((newIndex + 1) % crossword.cols == 0) {
                break
            }
            newIndex += 1
        }
        newIndex += 1
        if (newIndex == crossword.grid.count) {
            newIndex = 0
            changeOrientation()
        }
        while (crossword.grid[newIndex] == ".") {
            newIndex += 1
        }
        changeFocus(index: newIndex)
    }
    
    private func goToNextDownClueSquare() -> Void {
        var newIndex = xWordViewModel.focusedSquareIndex
        // Get to the start of the down clue -- the top of the current word
        while (newIndex >= crossword.cols) {
            let potentialNewIndex = newIndex - crossword.cols
            if (crossword.grid[potentialNewIndex] == ".") {
                break
            }
            newIndex = newIndex - crossword.cols
        }

        // Start from the top of this word
        changeFocus(index: newIndex, keepOrientation: true)
        newIndex += 1

        // Get to the next square if this is the first row
        // or get to the first space with a black square above it from this point
        while(newIndex != crossword.grid.count) {
            if ((newIndex < crossword.cols || (crossword.grid[newIndex - crossword.cols] == "."))
                && (crossword.grid[newIndex] != ".")) {
                    changeFocus(index: newIndex, keepOrientation: true)
                    return
            }
            newIndex += 1
        }

        // Start at the beginning of the puzzle again, with across oriented this time.
        newIndex = 0
        changeOrientation()
        changeFocus(index: newIndex)
        
    }
    
    func changeOrientation() -> Void {
        unsetHighlighting(index: xWordViewModel.focusedSquareIndex)
        acrossFocused = !acrossFocused
        setHighlighting(index: xWordViewModel.focusedSquareIndex)
        squareModelStore.models[xWordViewModel.focusedSquareIndex].changeSquareState(to: .focused)
        let newModel = squareModelStore.models[xWordViewModel.focusedSquareIndex]
        let newClue = acrossFocused ? newModel.acrossClue : newModel.downClue
        xWordViewModel.changeClue(to: newClue)
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
        if (acrossFocused) {
            goRightASquare()
        } else {
            if (xWordViewModel.focusedSquareIndex > (crossword.grid.count - crossword.cols)
                || (xWordViewModel.focusedSquareIndex + crossword.cols  < crossword.grid.count && crossword.grid[xWordViewModel.focusedSquareIndex + crossword.cols] == ".")) {
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

    var body: some View {
        ZStack {
            SocketManager()
            VStack(alignment: .leading, spacing: 0) {
                Text(crossword.title)
                VStack(spacing: 0) {
                    ForEach(0..<crossword.cols, id: \.self) { col in
                        HStack(spacing: 0) {
                            ForEach(0..<crossword.rows, id: \.self) { row in
                                let index = col * crossword.rows + row
                                let clueNumber = crossword.gridNums[index] != 0 ? crossword.gridNums[index] : 0
                                XWordSquare(
                                    crossword: crossword,
                                    index: index,
                                    boxWidth: boxWidth,
                                    squareModel: squareModelStore.models[index],
                                    changeFocus: changeFocus,
                                    handleBackspace: handleBackspace,
                                    textState: $textState,
                                    clueNumber: clueNumber
                                )
                            }
                        }
                    }
                }
                .padding(.bottom, 10)
                XWordViewToolbar(
                    boxWidth: UIScreen.screenWidth / 15,
                    goUpASquare: goUpASquare,
                    goDownASquare: goDownASquare,
                    goLeftASquare: goLeftASquare,
                    goRightASquare: goToNextClueSquare,
                    changeOrientation: changeOrientation
                )
            }
        }
        .frame(width: UIScreen.screenWidth, height: UIScreen.screenWidth + boxWidth * 3)
        .position(x: UIScreen.screenWidth/2, y: 220)
        .environmentObject(xWordViewModel)
        .onChange(of: textState, perform: { newState in
            if (newState == .letterTyped) {
                handleLetterTyped()
            } else if (newState == .shouldGoBackOne) {
                handleShouldBackspaceState()
            }
        })
        .onChange(of: xWordViewModel.otherPlayersMove, perform: { moveData in
            squareModelStore.models[moveData.index].changeTextFromOtherPlayer(to: moveData.text)
        })
//        .onChange(of: xWordViewModel.typedText, perform: { newTypedText in
//            self.socketManager.sendMessage(xWordViewModel.typedText)
//        })
    }
}

struct MyCrosswordView_Previews: PreviewProvider {
    static var previews: some View {
        XWordView(crossword: Crossword())
    }
}

extension UIScreen {
   static let screenWidth = UIScreen.main.bounds.size.width
   static let screenHeight = UIScreen.main.bounds.size.height
   static let screenSize = UIScreen.main.bounds.size
}
