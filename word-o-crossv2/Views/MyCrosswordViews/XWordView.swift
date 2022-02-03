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
    @State var focusedSquareIndex: Int
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
        self.focusedSquareIndex = 0
        self.acrossFocused = true
        self.squareModelStore = SquareModelStore(crossword: crossword)
        self.textState = .typedTo
        self.changeFocus(index: 0)
    }

    func changeFocus(index: Int) -> Void {
        if (index == focusedSquareIndex) {
            changeOrientation()
        } else {
            unsetHighlighting(index: focusedSquareIndex)
            focusedSquareIndex = index
            setHighlighting(index: focusedSquareIndex)
            let newModel = squareModelStore.models[focusedSquareIndex]
            newModel.changeSquareState(to: .focused)
            let newClue = acrossFocused ? newModel.acrossClue : newModel.downClue
            xWordViewModel.change(to: newClue)
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
        var potentialNewIndex = focusedSquareIndex - crossword.cols
        var newIndex: Int
        if (focusedSquareIndex == 0) {
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
        var potentialNewIndex = focusedSquareIndex + crossword.cols
        var newIndex: Int
        if (focusedSquareIndex == crossword.grid.count - 1) {
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
        var potentialNewIndex = focusedSquareIndex - 1
        var newIndex: Int = focusedSquareIndex == 0
            ? crossword.grid.count - 1
            : potentialNewIndex
        while (crossword.grid[newIndex] == ".") {
            potentialNewIndex = newIndex - 1
            newIndex = focusedSquareIndex == 0
                ? crossword.grid.count - 1
                : potentialNewIndex
        }
        changeFocus(index: newIndex)
    }
    
    func goRightASquare() -> Void {
        var potentialNewIndex = focusedSquareIndex + 1
        var newIndex: Int = focusedSquareIndex == crossword.grid.count - 1
            ? 0
            : potentialNewIndex
        while (crossword.grid[newIndex] == ".") {
            potentialNewIndex = newIndex + 1
            newIndex = focusedSquareIndex == crossword.grid.count - 1
                ? 0
                : potentialNewIndex
        }
        changeFocus(index: newIndex)
    }
    
    func changeOrientation() -> Void {
        unsetHighlighting(index: focusedSquareIndex)
        acrossFocused = !acrossFocused
        setHighlighting(index: focusedSquareIndex)
        squareModelStore.models[focusedSquareIndex].changeSquareState(to: .focused)
        let newModel = squareModelStore.models[focusedSquareIndex]
        let newClue = acrossFocused ? newModel.acrossClue : newModel.downClue
        xWordViewModel.change(to: newClue)
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

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 0) {
                Text(crossword.title)
                VStack(spacing: 0) {
                    ForEach(0..<crossword.cols, id: \.self) { col in
                        HStack(spacing: 0) {
                            ForEach(0..<crossword.rows, id: \.self) { row in
                                let index = col * crossword.rows + row
                                XWordSquare(
                                    crossword: crossword,
                                    index: index,
                                    boxWidth: boxWidth,
                                    squareModel: squareModelStore.models[index],
                                    changeFocus: changeFocus,
                                    handleBackspace: handleBackspace,
                                    textState: $textState
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
                    goRightASquare: goRightASquare,
                    changeOrientation: changeOrientation
                )
            }
            .frame(width: UIScreen.screenWidth, height: UIScreen.screenWidth + boxWidth * 3)
            .position(x: UIScreen.screenWidth/2, y: 120)
        }
        .environmentObject(xWordViewModel)
        .onChange(of: textState, perform: { newState in
            if (newState == .letterTyped) {
                if (acrossFocused) {
                    goRightASquare()
                } else {
                    goDownASquare()
                }
                textState = .typedTo
            } else if (newState == .shouldGoBackOne) {
                if (acrossFocused) {
                    goLeftASquare()
                } else {
                    goUpASquare()
                }
                textState = .typedTo
            }
        })
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
