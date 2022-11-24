//
//  BaseXWordToolbarView.swift
//  word_o_crossv2
//
//  Created by Austin Kang on 11/16/22.
//

import SwiftUI

struct BaseXWordToolbarView: View {
    
    var boxWidth: CGFloat
    @EnvironmentObject var viewModel: MakeXWordViewModel
    
    var body: some View {
        HStack() {
            Spacer()
            VStack {
                XWordViewToolbarButton(action: {
                    viewModel.acrossFocused ? viewModel.goLeftASquare() : viewModel.goUpASquare()},
                                       imageName: viewModel.acrossFocused ? "chevron.backward": "chevron.up")
                XWordViewToolbarButton(action: {
                    viewModel.acrossFocused ? viewModel.goToPreviousAcrossClueSquare() : viewModel.goToPreviousDownClueSquare()
                },
                                       imageName: "chevron.backward.2")
            }
            ZStack(alignment: .topTrailing) {
                ZStack {
                    Button(action: {
                        viewModel.changeAcrossFocused(to: !viewModel.acrossFocused)
                    }) {
                        RoundedRectangle(cornerRadius: 4).stroke().foregroundColor(.emptyGray)
                            .frame(maxHeight: .infinity)
                            .frame(width: UIScreen.screenWidth / 1.5)
                    }
                    TextField("Enter Clue", text: ($viewModel.clueText))
//                                                viewModel.acrossFocused
//                                                   ? Binding($viewModel.indexToAcrossCluesMap[viewModel.squareModels[viewModel.focusedIndex].acrossClueIndex])!
//                                                   : Binding($viewModel.indexToDownCluesMap[viewModel.squareModels[viewModel.focusedIndex].downClueIndex])!))
                        .foregroundColor(.squareBackground2)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity) // << default center !!
                Button(action: {
                    viewModel.editClueTapped = !viewModel.editClueTapped
                }) {
                //if viewModel.tapState == .tapped {
                    Image(systemName: "pencil")
                        .resizable()
                        .frame(width: boxWidth / 1.8, height: boxWidth / 1.8)
                        .foregroundColor(viewModel.editClueTapped ? .red : .emptyGray)
                        .padding(2)
                        .overlay(
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke()
                                    .foregroundColor(viewModel.editClueTapped ? .red : .emptyGray)
                        )
                        .padding(3)
                //}
                }
            }
            VStack {
                XWordViewToolbarButton(action: {
                    viewModel.acrossFocused ? viewModel.goRightASquare(): viewModel.goDownASquare()
                },
                                       imageName: viewModel.acrossFocused ? "chevron.forward" : "chevron.down")
                XWordViewToolbarButton(action: {
                    viewModel.acrossFocused ? viewModel.goToNextAcrossClueSquare() : viewModel.goToNextDownClueSquare()
                },
                                       imageName: "chevron.forward.2")
            }
            
            Spacer()
        }
        .frame(width: UIScreen.screenWidth)

    }
}

struct BaseXWordToolbarView_Previews: PreviewProvider {
    static var previews: some View {
        BaseXWordToolbarView(boxWidth: 25)
    }
}
