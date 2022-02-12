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
    @EnvironmentObject var xWordViewModel: XWordViewModel
    var text: String {
        get {
            xWordViewModel.squareModels[index].currentText
        }
    }
    
    var body: some View {
        Text(text)
            .foregroundColor(.black)
    }
}
//
//struct XWordSquareTextBoxV2_Previews: PreviewProvider {
//    static var previews: some View {
//        XWordSquareTextBoxV2()
//    }
//}
