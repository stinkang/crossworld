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
            VStack {
                XWordViewToolbarButton(boxWidth: boxWidth, action: xWordViewModel.goToPreviousSquare,
                                       imageName: xWordViewModel.acrossFocused ? "chevron.backward" : "chevron.up")
                XWordViewToolbarButton(boxWidth: boxWidth, action: xWordViewModel.jumpToPreviousSquare,
                                       imageName: "chevron.backward.2")
            }
            Spacer()
            Text(xWordViewModel.clue)
                .onTapGesture(perform: xWordViewModel.changeOrientation)
            Spacer()
            VStack {
                XWordViewToolbarButton(boxWidth: boxWidth, action: xWordViewModel.goToNextSquare,
                                       imageName: xWordViewModel.acrossFocused ? "chevron.forward" : "chevron.down")
                XWordViewToolbarButton(boxWidth: boxWidth, action: xWordViewModel.jumpToNextSquare,
                                       imageName: "chevron.forward.2")
            }
        }
        //.frame(width: UIScreen.screenWidth, height: self.keyboardHeightHelper.keyboardHeight, alignment: .center)
        .offset(y: 0)
    }
}

struct XWordViewToolbarButton: View {
    let boxWidth: CGFloat
    let action: () -> Void
    let imageName: String
    var body: some View {
        Button(action: {
            action()
        }) {
            Image(systemName: imageName)
                .frame(width: boxWidth * 2, height: boxWidth * 2)
        }
        .padding(.horizontal)
    }
}
