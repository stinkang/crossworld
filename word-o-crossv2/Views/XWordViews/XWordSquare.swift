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
        xWordViewModel.changeShouldSendMessage(to: true)
        xWordViewModel.changeTextState(to: .tappedOn)
        xWordViewModel.changeTapState(to: .tapped)
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
                XWordSquareColorBox(
                    boxAcrossClue: acrossClue!,
                    boxDownClue: downClue!,
                    width: boxWidth,
                    index: index,
                    clueNumber: clueNumber
                )
                XWordSquareTextBoxV2(
                    answerText: crossword.grid[index],
                    index: index,
                    previousText: "",
                    boxWidth: boxWidth
                )
                .frame(width: boxWidth, height: boxWidth, alignment: .center)
            }
            .contentShape(Rectangle())
            .frame(width: boxWidth, height: boxWidth, alignment: .center)
            .onTapGesture(perform: changeFocus)
        }
    }
}
