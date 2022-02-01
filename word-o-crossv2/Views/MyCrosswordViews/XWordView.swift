//
//  CrosswordView.swift
//  word-o-crossv2
//
//  Created by Austin Kang on 11/23/21.
//

import SwiftUI

class SquareStateStore {

    var states: [SquareState] = []

    init(count: Int) {
        (0...count).forEach { _ in states.append(SquareState()) }
    }
}

struct MyCrosswordView: View {
    var crossword: Crossword
    let squareStateStore: SquareStateStore
    @State var focusedSquareIndex: Int?
    @State var acrossFocused: Bool
    
    var boxWidth: CGFloat {
        let maxSize: CGFloat = 40.0
        let defaultSize: CGFloat = (UIScreen.screenWidth-5)/CGFloat(crossword.cols)
        return min(defaultSize, maxSize)
    }
    
    init(crossword: Crossword) {
        self.crossword = crossword
        self.focusedSquareIndex = 0
        self.acrossFocused = true
        self.squareStateStore = SquareStateStore(count: crossword.grid.count)
    }

    func changeFocus(index: Int) -> Void {
        squareStateStore.states[focusedSquareIndex!].change(to: false)
        focusedSquareIndex = index
        squareStateStore.states[focusedSquareIndex!].change(to: true)
    }
    
    func changeFocusInternal(index: Int) -> () -> Void {
        func changeFocusInternalInternal() -> Void {
            changeFocus(index: index)
        }
        return changeFocusInternalInternal
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text(crossword.title)
            VStack(spacing: 0) {
                ForEach(0..<crossword.cols, id: \.self) { col in
                    HStack(spacing: 0) {
                        ForEach(0..<crossword.rows, id: \.self) { row in
                            let index = col * crossword.rows + row
                            if (crossword.grid[index] == ".") {
                                CrosswordSquareBlackBox(width: boxWidth)
                            } else {
                                ZStack {
                                    CrosswordSquareColorBox(width: boxWidth, squareState: squareStateStore.states[index], index: index /*changeFocus: changeFocus*/)
                                    XwordSquareTextBox(width: boxWidth, answerText: crossword.grid[index], index: index, crossword: crossword, changeFocus: changeFocus, squareState: squareStateStore.states[index], givenText: "")
                                }.onTapGesture(perform: changeFocusInternal(index: index))
                            }
                        }
                    }
                }
            }
            Spacer()
        }
    }
}

struct MyCrosswordView_Previews: PreviewProvider {
    static var previews: some View {
        MyCrosswordView(crossword: Crossword())
    }
}

extension UIScreen {
   static let screenWidth = UIScreen.main.bounds.size.width
   static let screenHeight = UIScreen.main.bounds.size.height
   static let screenSize = UIScreen.main.bounds.size
}
