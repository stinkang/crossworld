//
//  MakeXWordSquare.swift
//  word_o_crossv2
//
//  Created by Austin Kang on 10/23/22.
//

import SwiftUI

struct MakeXWordSquareView: View {
    @ObservedObject var makeXWordViewModel: MakeXWordViewModel
    @StateObject var viewModel: MakeXWordSquareViewModel
    var boxWidth: CGFloat
    var index: Int
    
    init(boxWidth: CGFloat, index: Int, makeXWordViewModel: MakeXWordViewModel) {
        self.boxWidth = boxWidth
        self.index = index
        self.makeXWordViewModel = makeXWordViewModel
        self._viewModel = StateObject(wrappedValue: makeXWordViewModel.squareModels[index])
    }
    
    var body: some View {
        ZStack {
            Rectangle()
                .frame(width: boxWidth, height: boxWidth, alignment: Alignment.center)
                .border(.black)
                .foregroundColor(viewModel.isWhite ?
                                    (viewModel.squareState == .focused ?
                                        .focusedBlue : (viewModel.squareState == .highlighted ? .lightBlue :
                                                .white)) : .black)
            Text(viewModel.currentText)
                .foregroundColor(.black)
                .font(Font.custom("Helvetica", size: boxWidth))
            if (viewModel.clueNumber != 0) {
                ZStack(alignment: .topLeading) {
                    Rectangle()
                        .frame(width: boxWidth, height: boxWidth, alignment: .center)
                        .border(.black)
                        .foregroundColor(.clear)
                    VStack {
                        Spacer().frame(height: 2)
                        HStack {
                            Spacer().frame(width: 3)
                            Text(String(viewModel.clueNumber))
                                .font(Font.custom("Helvetica", size: boxWidth / 3))
                                .frame(width: boxWidth / 2, height: boxWidth / 3, alignment: .topLeading)
                                .foregroundColor(.black)
                        }
                    }
                }
            }
        }
        .onTapGesture {
            if makeXWordViewModel.editGridMode {
                viewModel.isWhite = !viewModel.isWhite
                viewModel.currentText = ""
                let oppositeIndex = (makeXWordViewModel.size - 1) - index
                if oppositeIndex != index {
                    makeXWordViewModel.squareModels[oppositeIndex].isWhite = !makeXWordViewModel.squareModels[oppositeIndex].isWhite
                }
                // for each square affected, add the clue index it corresponds to to the set of clues to erase
                makeXWordViewModel.affectedAcrossClueIndexes.insert(makeXWordViewModel.squareModels[index].acrossClueIndex)
                makeXWordViewModel.affectedAcrossClueIndexes.insert(makeXWordViewModel.squareModels[oppositeIndex].acrossClueIndex)
                makeXWordViewModel.affectedDownClueIndexes.insert(makeXWordViewModel.squareModels[index].downClueIndex)
                makeXWordViewModel.affectedDownClueIndexes.insert(makeXWordViewModel.squareModels[oppositeIndex].downClueIndex)
            } else {
                if viewModel.isWhite {
                    if (viewModel.squareState == .focused) {
                        makeXWordViewModel.changeAcrossFocused(to: !makeXWordViewModel.acrossFocused)
                    } else {
                        makeXWordViewModel.changeFocusedIndex(to: index)
                        viewModel.squareState = .focused
                        print(viewModel.acrossClueIndex)
                        print(viewModel.downClueIndex)
                    }
                }
            }
        }
    }
}

//struct MakeXWordSquareView_Previews: PreviewProvider {
//    static var previews: some View {
//        MakeXWordSquareView(boxWidth: 25, index: 0, makeXWordViewModel: MakeXWordViewModel(cols: 3))
//    }
//}
