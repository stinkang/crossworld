//
//  CrosswordView.swift
//  word-o-crossv2
//
//  Created by Austin Kang on 11/23/21.
//

import SwiftUI
import GameKit
import UIKit

struct XWordView: View {
    var crossword: Crossword
    @Binding var crosswordBinding: Crossword
    var xWordMatch: GKMatch
    @Binding var shouldSendGoBackToLobbyMessage: Bool
    @Binding var shouldSendCrosswordData: Bool
    @Binding var opponentName: String
    @Binding var connectedStatus: Bool
    //@Binding var isAcceptee: Bool
    @State var shouldGoBackToLobby: Bool = false
    var boxWidth: CGFloat {
        let maxSize: CGFloat = 40.0
        let defaultSize: CGFloat = (UIScreen.screenWidth-5)/CGFloat(crossword.size.cols)
        return min(defaultSize, maxSize) }
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @StateObject var xWordViewModel: XWordViewModel
    var selectedInputBinding: Binding<String> {
        Binding<String>(
            get: {
                xWordViewModel.squareModels[xWordViewModel.focusedSquareIndex].currentText
            },
            set: {
                xWordViewModel.squareModels[xWordViewModel.focusedSquareIndex].currentText = $0
            }
        )
    }
    
    init(
        crossword: Crossword,
        crosswordBinding: Binding<Crossword>,
        xWordMatch: GKMatch,
        shouldSendGoBackToLobbyMessage: Binding<Bool>,
        shouldSendCrosswordData: Binding<Bool>,
        opponentName: Binding<String>,
        connectedStatus: Binding<Bool>
    ) {
        self.crossword = crossword
        self._crosswordBinding = crosswordBinding
        self.xWordMatch = xWordMatch
        self._shouldSendGoBackToLobbyMessage = shouldSendGoBackToLobbyMessage
        self._shouldSendCrosswordData = shouldSendCrosswordData
        self._opponentName = opponentName
        self._connectedStatus = connectedStatus
        _xWordViewModel = StateObject(wrappedValue: XWordViewModel(crossword: crossword))
    }

    var body: some View {
        ZStack {
            GameView(
                xWordMatch: xWordMatch,
                shouldSendGoBackToLobbyMessage: $shouldSendGoBackToLobbyMessage,
                shouldGoBackToLobby: $shouldGoBackToLobby,
                shouldSendCrosswordData: $shouldSendCrosswordData,
                crosswordBinding: $crosswordBinding,
                opponentName: $opponentName,
                connectedStatus: $connectedStatus
            )
            if (crossword.title != "") {
                PermanentKeyboard(text: selectedInputBinding)
            }
            VStack(alignment: .leading, spacing: 0) {
                if (crossword.title != "") {
                    VStack(alignment: .leading, spacing: 0) {
                        if (UIScreen.screenHeight > 700) {
                            Text(crossword.title)
                        }
                        if (UIScreen.screenHeight > 800) {
                            Text("By " + crossword.author)
                        }
                        if (UIScreen.screenHeight > 900) {
                            Text("Edited By " + crossword.editor)
                        }
                    }
                    .padding(.leading, 2)
                    VStack(spacing: 0) {
                        ForEach(0..<crossword.size.cols, id: \.self) { col in
                            HStack(spacing: 0) {
                                ForEach(0..<crossword.size.rows, id: \.self) { row in
                                    let index = col * crossword.size.rows + row
                                    let clueNumber = crossword.gridnums[index] != 0 ? crossword.gridnums[index] : 0
                                    XWordSquare(
                                        crossword: crossword,
                                        index: index,
                                        boxWidth: boxWidth,
    //                                    squareModel: xWordViewModel.squareModels[index],
                                        clueNumber: clueNumber
                                    )
                                }
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    XWordViewToolbar(
                        boxWidth: UIScreen.screenWidth / 15
                    )
                    .frame(maxWidth: .infinity, alignment: .center)
                } else {
                    Text("<<< Enter CrossWorld!")
                }
            }
        }
        .padding(.top, 10)
        .navigationBarTitle("")
        .navigationBarHidden(true)
        .frame(width: UIScreen.screenWidth, height: UIScreen.screenWidth + boxWidth * 3)
        .position(x: UIScreen.screenWidth / 2, y: (UIScreen.screenWidth + boxWidth * 3) / 2)
        .environmentObject(xWordViewModel)
        .onChange(of: xWordViewModel.textState, perform: { newState in
            if (newState == .letterTyped) {
                xWordViewModel.handleLetterTyped()
            } else if (newState == .shouldGoBackOne) {
                xWordViewModel.handleShouldBackspaceState()
                xWordViewModel.changeShouldSendMessage(to: true)
            }
        })
        .onChange(of: xWordViewModel.otherPlayersMove, perform: { moveData in
            if (!moveData.wasTappedOn) {
                xWordViewModel.changeCurrentlyOtherPlayersChanges(currentlyOtherPlayersChanges: true)
                xWordViewModel.squareModels[moveData.previousIndex].changeCurrentText(to: moveData.text)
            }
            xWordViewModel.changeOtherPlayersFocusedSquareIndex(to: moveData.currentIndex)
            xWordViewModel.changeOtherPlayersAcrossFocused(to: moveData.acrossFocused)
            xWordViewModel.changeOtherPlayersFocus()
        })
        .onChange(of: xWordViewModel.focusedSquareIndex, perform: { focusedSquareIndex in
            xWordViewModel.changeFocus()
            //if (xWordViewModel.textState == .tappedOn) {
                //xWordViewModel.changeShouldSendMessage(to: true)
                //xWordViewModel.textState = .typedTo
            //}
        })
        .onChange(of: xWordViewModel.acrossFocused, perform: { _ in
            xWordViewModel.changeHighlightingAndClue()
            xWordViewModel.changeShouldSendMessage(to: true)
        })
        .onChange(of: xWordViewModel.otherPlayersAcrossFocused, perform: { _ in
            xWordViewModel.changeOtherPlayersHighlighting()
        })
        .onChange(of: shouldGoBackToLobby, perform: { _ in
            if (shouldGoBackToLobby) {
                self.presentationMode.wrappedValue.dismiss()
                shouldGoBackToLobby = false
            }
        })
//        .onDisappear(perform: {
//            shouldSendGoBackToLobbyMessage = true
//        })
//        .onChange(of: crossword.title) { _ in
//            xWordViewModel.crossword = crossword
//        }
//        .onChange(of: xWordViewModel.typedText, perform: { newTypedText in
//            self.socketManager.sendMessage(xWordViewModel.typedText)
//        })
        .sheet(isPresented: $xWordViewModel.solved) {
            StatsSheetView(crossword: crossword, xWordViewModel: xWordViewModel)
        }
    }
}

//struct MyCrosswordView_Previews: PreviewProvider {
////    static var previews: some View {
////        XWordView(
////            crossword: Crossword(),
////            crosswordBinding: .constant(Crossword()),
////            xWordMatch: GKMatch(),
////            shouldSendGoBackToLobbyMessage: .constant(true),
////            shouldSendCrosswordData: .constant(true),
////            opponentName: .constant("")
////        )
////    }
//}

extension UIScreen {
   static let screenWidth = UIScreen.main.bounds.size.width
   static let screenHeight = UIScreen.main.bounds.size.height
   static let screenSize = UIScreen.main.bounds.size
}

extension UINavigationController {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = nil
    }
}
