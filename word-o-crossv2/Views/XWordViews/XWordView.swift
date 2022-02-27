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
    @Binding var xWordMatch: GKMatch
    @State var showLobbyView: Bool = false
    @State var shouldSendGoBackToLobby: Bool = false
    var boxWidth: CGFloat {
        let maxSize: CGFloat = 40.0
        let defaultSize: CGFloat = (UIScreen.screenWidth-5)/CGFloat(crossword.cols)
        return min(defaultSize, maxSize) }
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
    
    init(crossword: Crossword, xWordMatch: Binding<GKMatch>) {
        self.crossword = crossword
        self._xWordMatch = xWordMatch
        _xWordViewModel = StateObject(wrappedValue: XWordViewModel(crossword: crossword))
    }

    var body: some View {
        ZStack {
            NavigationLink(destination: LobbyView(), isActive: $showLobbyView) {
                Text("Lobby")
            }
            .foregroundColor(Color(UIColor.clear))
            .disabled(true)
            GameView(xWordMatch: $xWordMatch/*, shouldSendGoBackToLobby: $shouldSendGoBackToLobby*/)
            PermanentKeyboard(text: selectedInputBinding)
            VStack(alignment: .leading, spacing: 0) {
                if (UIScreen.screenHeight > 700) {
                    Text(crossword.title)
                }
                VStack(spacing: 0) {
                    ForEach(0..<crossword.cols, id: \.self) { col in
                        HStack(spacing: 0) {
                            ForEach(0..<crossword.rows, id: \.self) { row in
                                let index = col * crossword.rows + row
                                let clueNumber = crossword.gridNums[index] != 0 ? crossword.gridNums[index] : 0
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
                .padding(.bottom, 10)
                XWordViewToolbar(
                    boxWidth: UIScreen.screenWidth / 15
                )
                Spacer()
            }
        }
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
            }
        })
        .onChange(of: xWordViewModel.otherPlayersMove, perform: { moveData in
            if (!moveData.wasTappedOn) {
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
            xWordViewModel.changeShouldSendMessage(to: true)
        })
//        .onChange(of: crossword.title) { _ in
//            xWordViewModel.crossword = crossword
//        }
//        .onChange(of: xWordViewModel.typedText, perform: { newTypedText in
//            self.socketManager.sendMessage(xWordViewModel.typedText)
//        })
    }
}

struct MyCrosswordView_Previews: PreviewProvider {
    static var previews: some View {
        XWordView(crossword: Crossword(), xWordMatch: .constant(GKMatch()))
    }
}

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
