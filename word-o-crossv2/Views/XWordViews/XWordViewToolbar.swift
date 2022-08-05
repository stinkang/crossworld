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
        HStack() {
            Spacer()
            VStack {
                XWordViewToolbarButton(action: xWordViewModel.goToPreviousSquare,
                                       imageName: xWordViewModel.acrossFocused ? "chevron.backward" : "chevron.up")
                XWordViewToolbarButton(action: xWordViewModel.jumpToPreviousSquare,
                                       imageName: "chevron.backward.2")
            }
            ZStack(alignment: .topTrailing) {
                Button(action: {
                    xWordViewModel.changeOrientation()
                }) {
                    RoundedRectangle(cornerRadius: 4).stroke().foregroundColor(.emptyGray)
                        .frame(maxHeight: .infinity)
                        .frame(width: UIScreen.screenWidth / 1.5)
                        .overlay(
                            Text(xWordViewModel.clue)
                                .foregroundColor(.squareBackground2))
    //                    .overlay(
    //                        VStack {
    //                            if xWordViewModel.acrossFocused {
    //                                Text("ACROSS")
    //                                .font(.caption)
    //                                .foregroundColor(.correctGreen)
    //                                .italic()
    //                            } else {
    //                                VStack(spacing: 0) {
    //                                    Text("D")
    //                                        .font(.caption)
    //                                        .foregroundColor(.correctGreen)
    //                                        .italic()
    //                                    Text("O")
    //                                        .font(.caption)
    //                                        .foregroundColor(.correctGreen)
    //                                        .italic()
    //                                    Text("W")
    //                                        .font(.caption)
    //                                        .foregroundColor(.correctGreen)
    //                                        .italic()
    //                                    Text("N")
    //                                        .font(.caption)
    //                                        .foregroundColor(.correctGreen)
    //                                        .italic()
    //                                }
    //                            }
    //                        }
    //                            .padding(.horizontal, 3)
    //                            .padding(.vertical, 1)
    //                        , alignment: .topLeading)
                } // end of Button
                .frame(maxWidth: .infinity) // << default center !!
                Button(action: {
                    xWordViewModel.tapState == .tapped
                    ? xWordViewModel.changeTapState(to: .untapped)
                    : xWordViewModel.changeTapState(to: .tapped)
                }) {
                //if xWordViewModel.tapState == .tapped {
                    Image(systemName: "pencil")
                        .resizable()
                        .frame(width: boxWidth / 1.8, height: boxWidth / 1.8)
                        .foregroundColor(xWordViewModel.tapState == .tapped ? .red : .emptyGray)
                        .padding(2)
                        .overlay(
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke()
                                    .foregroundColor(xWordViewModel.tapState == .tapped ? .red : .emptyGray)
                        )
                        .padding(3)
                //}
                }
            }
            VStack {
                XWordViewToolbarButton(action: xWordViewModel.goToNextSquare,
                                       imageName: xWordViewModel.acrossFocused ? "chevron.forward" : "chevron.down")
                XWordViewToolbarButton(action: xWordViewModel.jumpToNextSquare,
                                       imageName: "chevron.forward.2")
            }
            
            Spacer()
        }
        .frame(width: UIScreen.screenWidth)
        
    }
}

struct XWordViewToolbarButton: View {
    let action: () -> Void
    let imageName: String
    var body: some View {
        Button(action: {
            action()
        }) {
            Image(systemName: imageName)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(RoundedRectangle(cornerRadius: 4).stroke())
                .foregroundColor(.emptyGray)
        }
    }
}
