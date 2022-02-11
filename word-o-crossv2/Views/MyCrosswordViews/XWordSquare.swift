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
    //let squareModel: SquareModel
    let clueNumber: Int
    
    @EnvironmentObject var xWordViewModel: XWordViewModel
    
    func changeFocus() -> Void {
        if (xWordViewModel.focusedSquareIndex == index) {
            xWordViewModel.changeAcrossFocused(to: !xWordViewModel.acrossFocused)
        } else {
            xWordViewModel.changeFocusedSquareIndex(to: index)
        }
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
                    //squareModel: xWordViewModel.squareModels[index],
                    index: index,
                    clueNumber: clueNumber
                )
                XWordSquareTextBoxV2(
                    answerText: crossword.grid[index],
                    index: index,
                    previousText: ""
                )
//                XwordSquareTextBox(
//                    width: boxWidth,
//                    answerText: crossword.grid[index],
//                    index: index,
//                    crossword: crossword,
//                    squareModel: xWordViewModel.squareModels[index],
//                    givenText: ""
//                )
                .frame(width: boxWidth, height: boxWidth, alignment: .center)
            }
            .contentShape(Rectangle())
            .frame(width: boxWidth, height: boxWidth, alignment: .center)
            .onTapGesture(perform: changeFocus)
        }
    }
}
