//
//  CrosswordSquareColorBox.swift
//  word-o-crossv2
//
//  Created by Austin Kang on 1/20/22.
//

import Foundation
import SwiftUI

struct CrosswordSquareColorBox: View {
    let width: CGFloat
    @ObservedObject var squareState: SquareState
    let index: Int
//    let changeFocus: (Int) -> Void
//
//    func changeFocusInternal() -> Void {
//        changeFocus(self.index)
//    }

    var body: some View {
        Rectangle()
            .frame(width: width, height: width, alignment: Alignment.center)
            .border(Color.black)
            .foregroundColor(squareState.state ? Color.blue : Color.white)
            //.onTapGesture(perform: changeFocusInternal)
    }
}
