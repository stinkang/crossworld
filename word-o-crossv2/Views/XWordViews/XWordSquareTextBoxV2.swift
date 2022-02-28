//
//  XWordSquareTextBoxV2.swift
//  word_o_crossv2
//
//  Created by Austin Kang on 2/8/22.
//

import SwiftUI

struct XWordSquareTextBoxV2: View {
    let answerText: String
    let index: Int
    var previousText = ""
    @State var currentlyCorrect = false
    @EnvironmentObject var xWordViewModel: XWordViewModel
    var text: String {
        get {
            xWordViewModel.squareModels[index].currentText
        }
    }
    
    var body: some View {
        Text(text)
            .foregroundColor(.black)
            .onChange(of: text, perform: { text in
                if text == answerText {
                    if (!xWordViewModel.squareModels[index].hasBeenCorrect) {
                        if (!xWordViewModel.currentlyOtherPlayersChanges) {
                            xWordViewModel.squareModels[index].changeSolvedByMe(to: true)
                        } else {
                            xWordViewModel.changeCurrentlyOtherPlayersChanges(currentlyOtherPlayersChanges: false)
                        }
                        xWordViewModel.squareModels[index].changeHasBeenCorrect(to: true)
                    }
                    xWordViewModel.incrementCorrectSquares()
                    currentlyCorrect = true
                    xWordViewModel.checkCrossword()
                } else {
                    if currentlyCorrect {
                        xWordViewModel.decrementCorrectSquares()
                        currentlyCorrect = false
                    }
                }
            })
    }
}
//
//struct XWordSquareTextBoxV2_Previews: PreviewProvider {
//    static var previews: some View {
//        XWordSquareTextBoxV2()
//    }
//}
