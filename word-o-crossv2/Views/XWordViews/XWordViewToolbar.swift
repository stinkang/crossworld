//
//  XWordViewToolbar.swift
//  word_o_crossv2
//
//  Created by Austin Kang on 1/31/22.
//

import Foundation
import SwiftUI

struct XWordViewToolbar: View {
    let boxWidth: CGFloat
    @ObservedObject var keyboardHeightHelper: KeyboardHeightHelper = KeyboardHeightHelper()
    @EnvironmentObject var xWordViewModel: XWordViewModel

    var body: some View {
        HStack(spacing: 10) {
            XWordViewToolbarButton(boxWidth: boxWidth, action: xWordViewModel.goLeftASquare)
            Spacer()
            Text(xWordViewModel.clue)
                .onTapGesture(perform: xWordViewModel.changeOrientation)
            Spacer()
            XWordViewToolbarButton(boxWidth: boxWidth, action: xWordViewModel.goToNextClueSquare)
        }
        //.frame(width: UIScreen.screenWidth, height: self.keyboardHeightHelper.keyboardHeight, alignment: .center)
        .offset(y: UIScreen.screenHeight > 700 ? boxWidth : 0)
    }
}

struct XWordViewToolbarButton: View {
    let boxWidth: CGFloat
    let action: () -> Void
    var body: some View {
        Button(action: {
            action()
        }) {
            Rectangle()
                .foregroundColor(.clear)
                .scaledToFit()
                .frame(width: boxWidth * 2, height: boxWidth * 2)
        }
        .padding(.horizontal)
    }
}
