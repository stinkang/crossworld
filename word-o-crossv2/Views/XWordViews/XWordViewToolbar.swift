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
    let keyboardHeight: CGFloat
    @EnvironmentObject var xWordViewModel: XWordViewModel

    var body: some View {
        HStack(spacing: 10) {
            VStack {
                XWordViewToolbarButton(boxWidth: boxWidth, action: xWordViewModel.goToPreviousSquare,
                                       imageName: xWordViewModel.acrossFocused ? "chevron.backward" : "chevron.up")
                XWordViewToolbarButton(boxWidth: boxWidth, action: xWordViewModel.jumpToPreviousSquare,
                                       imageName: "chevron.backward.2")
            }
            Button(action: {
                xWordViewModel.changeOrientation()
            }) {
                Text(xWordViewModel.clue)
                    .frame(width: UIScreen.screenWidth / 1.5, height: UIScreen.screenHeight / 13)
                    .background(RoundedRectangle(cornerRadius: 4).stroke())
            }
            VStack {
                XWordViewToolbarButton(boxWidth: boxWidth, action: xWordViewModel.goToNextSquare,
                                       imageName: xWordViewModel.acrossFocused ? "chevron.forward" : "chevron.down")
                XWordViewToolbarButton(boxWidth: boxWidth, action: xWordViewModel.jumpToNextSquare,
                                       imageName: "chevron.forward.2")
            }
        }
        //.frame(width: UIScreen.screenWidth, height: 100, alignment: .center)
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
                .frame(width: boxWidth, height: boxWidth)
        }
        .padding(.horizontal)
    }
}
