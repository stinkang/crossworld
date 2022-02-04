//
//  XWordSquare.swift
//  word_o_crossv2
//
//  Created by Austin Kang on 2/1/22.
//

import Foundation
import SwiftUI

struct XWordSquare: View {
    let crossword: Crossword
    let index: Int
    let boxWidth: CGFloat
    let squareModel: SquareModel
    let changeFocus: (Int, Bool) -> Void
    let handleBackspace: () -> Void
    @Binding var textState: TextState
    
    func changeFocusInternal(index: Int) -> () -> Void {
        func changeFocusInternalInternal() -> Void {
            changeFocus(index, false)
        }
        return changeFocusInternalInternal
    }

    var body: some View {
        if (crossword.grid[index] == ".") {
            CrosswordSquareBlackBox(width: boxWidth)
        } else {
            let acrossClue = crossword.clueNamesToCluesMap[crossword.tagsToCluesMap[index]["A"]!]
            let downClue = crossword.clueNamesToCluesMap[crossword.tagsToCluesMap[index]["D"]!]
            ZStack {
                CrosswordSquareColorBox(
                    boxAcrossClue: acrossClue!,
                    boxDownClue: downClue!,
                    width: boxWidth,
                    squareModel: squareModel,
                    index: index
                    //changeFocus: changeFocus
                )
                XwordSquareTextBox(
                    width: boxWidth,
                    answerText: crossword.grid[index],
                    index: index,
                    crossword: crossword,
                    handleBackspace: handleBackspace,
                    /*changeFocus: changeFocus,*/
                    squareModel: squareModel,
                    givenText: "",
                    textState: $textState
                )
                .frame(width: boxWidth, height: boxWidth, alignment: .center)
            }
            .contentShape(Rectangle())
            .frame(width: boxWidth, height: boxWidth, alignment: .center)
            .onTapGesture(perform: changeFocusInternal(index: index))
        }
    }
}
