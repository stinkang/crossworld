//
//  CrosswordSquareColorBox.swift
//  word-o-crossv2
//
//  Created by Austin Kang on 1/20/22.
//

import Foundation
import SwiftUI

struct CrosswordSquareColorBox: View {
    let boxAcrossClue: String
    let boxDownClue: String
    let width: CGFloat
    @ObservedObject var squareModel: SquareModel
    let index: Int
    //let changeFocus: (Int) -> Void
    //@EnvironmentObject var currentClue: XWordViewModel

//    func changeFocusInternal() -> Void {
//        changeFocus(self.index)
//    }

    var body: some View {
        Rectangle()
            .frame(width: width, height: width, alignment: Alignment.center)
            .border(Color.black)
            .foregroundColor(squareModel.squareState == .highlighted ? Color.lightBlue : (squareModel.squareState == .focused ? Color.blue : Color.white))
            //.onTapGesture(perform: changeFocusInternal)
    }
}
