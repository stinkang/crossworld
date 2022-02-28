//
//  CrosswordSquareColorBox.swift
//  word-o-crossv2
//
//  Created by Austin Kang on 1/20/22.
//

import Foundation
import SwiftUI

struct XWordSquareColorBox: View {
    let boxAcrossClue: String
    let boxDownClue: String
    let width: CGFloat
    let index: Int
    let clueNumber: Int
    @EnvironmentObject var xWordViewModel: XWordViewModel
    //let changeFocus: (Int) -> Void
    //@EnvironmentObject var currentClue: XWordViewModel

//    func changeFocusInternal() -> Void {
//        changeFocus(self.index)
//    }


    var body: some View {
        ZStack(alignment: .topLeading) {
//            var color: Color
//            switch xWordViewModel.squareModels[index].squareState {
//            case .highlighted:
//                color = .lightBlue
//            case .focused:
//                color = .focusedBlue
//            case .correct:
//                color = .green
//            case .otherPlayerFocused:
//                color = .yellow
//            default:
//                color = .white
//            }
            let color = xWordViewModel.squareModels[index].squareState == .highlighted
                ? Color.lightBlue
                : (xWordViewModel.squareModels[index].squareState == .focused
                   ? Color.focusedBlue
                   : (xWordViewModel.squareModels[index].squareState == .otherPlayerFocused
                      ? Color.redFocused
                      : (xWordViewModel.squareModels[index].squareState == .otherPlayerHighlighted
                         ? Color.redHighlighted
                         : (xWordViewModel.squareModels[index].squareState == .correct
                            ? .correctGreen
                            : Color.white))))
            Rectangle()
                .frame(width: width, height: width, alignment: Alignment.center)
                .border(Color.black)
                .foregroundColor(color)
                //.onTapGesture(perform: changeFocusInternal)
            if (clueNumber != 0) {
                VStack {
                    Spacer().frame(height: 2)
                    HStack {
                        Spacer().frame(width: 3)
                        Text(String(clueNumber))
                            .font(Font.custom("Helvetica", size: width / 3))
                            .frame(width: width / 3, height: width / 3, alignment: .topLeading)
                            .foregroundColor(.black)
                    }
                }
            }
        }
    }
}
