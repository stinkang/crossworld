//
//  CrosswordView.swift
//  word-o-crossv2
//
//  Created by Austin Kang on 11/23/21.
//

import SwiftUI
import GameKit
import UIKit
import CoreData

struct XWordView: View {
    var crossword: Crossword
    @Binding var crosswordBinding: Crossword
    var xWordMatch: GKMatch
    @Binding var shouldSendGoBackToLobbyMessage: Bool
    @Binding var shouldSendCrosswordData: Bool
    @Binding var opponent: GKPlayer
    @Binding var connectedStatus: Bool
    //@Binding var isAcceptee: Bool
    @State var shouldGoBackToLobby: Bool = false
    var boxWidth: CGFloat {
        let maxSize: CGFloat = 40.0
        let defaultSize: CGFloat = (UIScreen.screenWidth-5)/CGFloat(crossword.size.cols)
        return min(defaultSize, maxSize) }
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.managedObjectContext) var managedObjectContext
    let persistenceController = PersistenceController.shared
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
        opponent: Binding<GKPlayer>,
        connectedStatus: Binding<Bool>
    ) {
        self.crossword = crossword
        self._crosswordBinding = crosswordBinding
        self.xWordMatch = xWordMatch
        self._shouldSendGoBackToLobbyMessage = shouldSendGoBackToLobbyMessage
        self._shouldSendCrosswordData = shouldSendCrosswordData
        self._opponent = opponent
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
                opponent: $opponent,
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
                        if (UIScreen.screenHeight > 900) {
//                            VStack {
                                Text("By " + crossword.author)
                                Text("Edited By " + crossword.editor)
//                            }
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
                    Spacer()
                } else {
                    Text("<<< Enter CrossWorld!")
                }
            }
        }
        .navigationBarTitle("")
        .navigationBarHidden(true)
        //.frame(width: UIScreen.screenWidth, height: UIScreen.screenWidth + boxWidth * 3)
        //.position(x: UIScreen.screenWidth / 2, y: (UIScreen.screenWidth * 3) / 2)
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
        .onDisappear(perform: {
            if (crossword.title != "") {
                saveCrossword()
            }
        })
        .onAppear(perform: {
            for (index, entry) in crossword.entries.enumerated() {
                if (entry != "" && entry != ".") {
                    xWordViewModel.squareModels[index].changeCurrentText(to: entry)
                }
            }
        })
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
    
    func saveCrossword() {
        var newCrossword = CrosswordModel()
        var fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CrosswordModel")
        fetchRequest.predicate = NSPredicate(format: "title = %@", crossword.title)
        do {
            if let fetchResults = try managedObjectContext.fetch(fetchRequest) as? [NSManagedObject] {
                if fetchResults.count != 0 {
                    newCrossword = fetchResults[0] as! CrosswordModel
                } else {
                    newCrossword = CrosswordModel(context: managedObjectContext)
                }
            }
        } catch {
            print("Fetch Failed: \(error)")
        }

        newCrossword.title = crossword.title
        newCrossword.author = crossword.author
        newCrossword.editor = crossword.editor
        newCrossword.publisher = crossword.publisher
        //newCrossword.uniclue = crossword.uniclue
        newCrossword.notes = crossword.notes
        //newCrossword.navigate = crossword.navigate
        //newCrossword.hastitle = crossword.hastitle
        newCrossword.solved = crossword.solved
        newCrossword.setValue(xWordViewModel.entries, forKey: "entries")
        newCrossword.target = crossword.target
        newCrossword.gridnums = crossword.gridnums
        newCrossword.grid = crossword.grid
        newCrossword.rows = Int64(crossword.size.rows)
        newCrossword.cols = Int64(crossword.size.cols)
        newCrossword.downclues = crossword.clues.down
        newCrossword.downanswers = crossword.answers.down
        newCrossword.acrossclues = crossword.clues.across
        newCrossword.acrossanswers = crossword.answers.across
        newCrossword.dow = crossword.dow
        newCrossword.date = crossword.date
        newCrossword.copyright = crossword.copyright
        newCrossword.circles = crossword.circles
        //newCrossword.auto = crossword.auto
        newCrossword.admin = crossword.admin
        
        persistenceController.save()
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
////            opponent: .constant("")
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
