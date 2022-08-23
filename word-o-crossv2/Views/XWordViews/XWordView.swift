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
    @Binding var isShowingXwordView: Bool
    @Binding var showArchive: Bool
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
    @StateObject var appState: AppState
    @ObservedObject var keyboardHeightHelper: KeyboardHeightHelper = KeyboardHeightHelper()
    var crosswordAlreadySolved = false
    var selectedInputBinding: Binding<String> {
        Binding<String>(
            get: {
                xWordViewModel.squareModels[xWordViewModel.focusedSquareIndex].currentText
            },
            set: {
                xWordViewModel.squareModels[xWordViewModel.focusedSquareIndex].changeCurrentText(to: $0)
            }
        )
    }
    var numberFormatter: NumberFormatter
    @State var secondsElapsed: Int64 = 0;
    @State var hours: Int64 = 0;
    @State var minutes: Int64 = 0;
    @State var seconds: Int64 = 0;
    @State var timer: Timer? = nil
    let crosswordService = FirebaseService()
    
    func updateSecondsElapsed() {
        secondsElapsed += 1
        hours = (secondsElapsed % 86400) / 3600
        minutes = (secondsElapsed % 3600) / 60
        seconds = (secondsElapsed % 3600) % 60
    }
    
    init(
        crossword: Crossword,
        crosswordBinding: Binding<Crossword>,
        xWordMatch: GKMatch,
        shouldSendGoBackToLobbyMessage: Binding<Bool>,
        shouldSendCrosswordData: Binding<Bool>,
        opponent: Binding<GKPlayer>,
        connectedStatus: Binding<Bool>,
        isShowingXwordView: Binding<Bool>,
        showArchive: Binding<Bool>
    ) {
        self.crossword = crossword
        self._crosswordBinding = crosswordBinding
        self.xWordMatch = xWordMatch
        self._shouldSendGoBackToLobbyMessage = shouldSendGoBackToLobbyMessage
        self._shouldSendCrosswordData = shouldSendCrosswordData
        self._opponent = opponent
        self._connectedStatus = connectedStatus
        self._isShowingXwordView = isShowingXwordView
        self._showArchive = showArchive
        self.numberFormatter  = NumberFormatter()
        self.crosswordAlreadySolved = crossword.solved
        numberFormatter.minimumIntegerDigits = 2
        _xWordViewModel = StateObject(wrappedValue: XWordViewModel(crossword: crossword))
        _appState = StateObject(wrappedValue: AppState())
        //self.secondsElapsed = crossword.secondsElapsed
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
                connectedStatus: $connectedStatus,
                isShowingXWordView: $isShowingXwordView
            )
            if (crossword.title != "") {
                PermanentKeyboard(text: selectedInputBinding)
            }
            VStack(alignment: .leading, spacing: 0) {
                if (crossword.title != "") {
                    VStack(alignment: .leading, spacing: 0) {
                        if (UIScreen.screenHeight > 700) {
                            HStack {
                                Text(crossword.title)
                                if (UIScreen.screenHeight < 900) {
                                    Spacer()
                                    Text("\(numberFormatter.string(from: NSNumber(value: hours))!):\(numberFormatter.string(from: NSNumber(value: minutes))!):\(numberFormatter.string(from: NSNumber(value: seconds))!)")
                                        .foregroundColor(.yellow)
                                        .frame(width: UIScreen.screenWidth / 5, height: 16, alignment: .leading)
                                }
                            }
                        }
                        if (UIScreen.screenHeight > 900) {
//                            VStack {
                                Text("By " + crossword.author)
                                HStack {
                                    Text("Edited By " + crossword.editor)
                                    Spacer()
                                    // timer
                                    Text("\(numberFormatter.string(from: NSNumber(value: hours))!):\(numberFormatter.string(from: NSNumber(value: minutes))!):\(numberFormatter.string(from: NSNumber(value: seconds))!)")
                                        .foregroundColor(.yellow)
                                        .frame(width: UIScreen.screenWidth / 7, height: 16, alignment: .leading)
                                }
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
                    Spacer()
                    XWordViewToolbar(
                        boxWidth: UIScreen.screenWidth / 15,
                        keyboardHeight: keyboardHeightHelper.keyboardHeight
                    )
                    .padding(.bottom, 2)
                    //.frame(maxWidth: .infinity, alignment: .center)
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
            if (newState == .letterTyped || newState == .letterTyped2) {
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
        .onChange(of: appState.isActive, perform: { _ in
            saveCrossword()
        })
        .onWillDisappear {
            if (crossword.title != "") {
                saveCrossword()
            }
            //timer!.invalidate()
        }
        .onDisappear(perform: {
            timer!.invalidate()
        })
        .onAppear(perform: {
            showArchive = false
            for (index, entry) in crossword.entries.enumerated() {
                if (entry != "" && entry != ".") {
                    xWordViewModel.squareModels[index].changeCurrentText(to: entry)
                }
            }
            xWordViewModel.changeFocusedSquareIndex(to: 0)
            
            self.secondsElapsed = crossword.secondsElapsed
            
            if (!xWordViewModel.solved) {
                timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
                    updateSecondsElapsed()
                })
                if (crossword.solved) {
                    timer!.invalidate()
                }
            }
        })
        .onChange(of: xWordViewModel.solved) { solved in
            if (solved) {
                if (!crosswordAlreadySolved) {
                    crosswordService.uploadOrUpdateCrosswordLeaderboard(crossword: crossword, userName: GKLocalPlayer.local.displayName, score: secondsElapsed)
                }
                timer!.invalidate()
            }
        }
//        .onChange(of: xWordViewModel.typedText, perform: { newTypedText in
//            self.socketManager.sendMessage(xWordViewModel.typedText)
//        })
        .popover(isPresented: $xWordViewModel.solvedSheetPresented) {
            StatsSheetView(crossword: $crosswordBinding, xWordViewModel: xWordViewModel)
        }
    }
    
    func saveCrossword() {
        var newCrossword = CrosswordModel()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CrosswordModel")
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
        newCrossword.solved = xWordViewModel.solved
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
        newCrossword.secondsElapsed = secondsElapsed
        newCrossword.leaderboardId = crossword.leaderboardId
        newCrossword.percentageComplete = calculatePercentageComplete()
        newCrossword.lastAccessed = Date()
        
        persistenceController.save()
    }
    
    func calculatePercentageComplete() -> Float {
        let numberOfEntries = Float(xWordViewModel.entries.filter { $0 != "" && $0 != "." }.count)
        let numberOfSquares = Float(xWordViewModel.entries.filter { $0 != "." }.count)
        return numberOfEntries / numberOfSquares
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

extension Date {
    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }
}
