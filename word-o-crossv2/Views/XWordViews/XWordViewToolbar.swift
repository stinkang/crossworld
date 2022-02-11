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
    let goUpASquare: () -> Void
    let goDownASquare: () -> Void
    let goLeftASquare: () -> Void
    let goRightASquare: () -> Void
    let changeOrientation: () -> Void
    @EnvironmentObject var xWordViewModel: XWordViewModel

    var body: some View {
        HStack(spacing: 10) {
            VStack {
                XWordViewToolbarButton(boxWidth: boxWidth, systemName: "arrow.down", action: xWordViewModel.goDownASquare)
                Spacer()
                XWordViewToolbarButton(boxWidth: boxWidth, systemName: "arrow.left", action: xWordViewModel.goLeftASquare)
            }
            Spacer()
            Text(xWordViewModel.clue)
                .onTapGesture(perform: changeOrientation)
            Spacer()
            VStack {
                XWordViewToolbarButton(boxWidth: boxWidth, systemName: "arrow.up", action: xWordViewModel.goUpASquare)
                Spacer()
                XWordViewToolbarButton(boxWidth: boxWidth, systemName: "arrow.right", action: xWordViewModel.goRightASquare)
            }
        }
        .frame(width: UIScreen.screenWidth, height: UIScreen.screenWidth / 8, alignment: .center)
    }
}

struct XWordViewToolbarButton: View {
    let boxWidth: CGFloat
    let systemName: String
    let action: () -> Void
    var body: some View {
        Button(action: {
            action()
        }) {
            Image(systemName: systemName)
                .resizable()
                .scaledToFit()
                .frame(width: boxWidth - 10, height: boxWidth - 10)
        }
        .padding(.horizontal)
    }
}
