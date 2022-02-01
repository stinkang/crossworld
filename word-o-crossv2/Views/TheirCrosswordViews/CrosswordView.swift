//
//  CrosswordView.swift
//  crosswords
//
//

import SwiftUI

struct CrosswordView: View {
    @Binding var crossword: Crossword
    var componentHeights: CGFloat {
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        let statusBarHeight: CGFloat = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0

        // 40 is height of keyboard toolbar
        // 45 is height of navigation bar
        return 40 + 45 + statusBarHeight + self.boxWidth*CGFloat(self.crossword.rows)
    }

    @Environment(\.managedObjectContext) var managedObjectContext
    @ObservedObject var keyboardHeightHelper = KeyboardHeightHelper()
    @State var focusedTag: Int = -1
    @State var highlighted: Array<Int> = Array()
    @State var goingAcross: Bool = true
    @State var forceUpdate = false
    @State var isKeyboardOpen = false

    var boxWidth: CGFloat {
        let maxSize: CGFloat = 40.0
        let defaultSize: CGFloat = (UIScreen.screenWidth-5)/CGFloat(crossword.cols)
        return min(defaultSize, maxSize)
    }
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    let showTimer = UserDefaults.standard.object(forKey: "showTimer") as? Bool ?? true

    @ViewBuilder
    var body: some View {
        VStack {
            ScrollView {
                ScrollViewReader { scrollreader in
                    {() -> CrosswordGridView in
                        let currentClue = getCurrentClue()
                        return CrosswordGridView(crossword: self.$crossword, boxWidth: self.boxWidth, currentClue: currentClue, focusedTag: self.$focusedTag, highlighted: self.$highlighted, goingAcross: self.$goingAcross, forceUpdate: self.$forceUpdate, isKeyboardOpen: self.$isKeyboardOpen)
                    }()
                    .onChange(of: focusedTag, perform: {newFocusedTag in
                        if (newFocusedTag < 0) {
                            self.isKeyboardOpen = false
                        }
                    })
                    .padding(.top, 30)
                    Spacer()
                    VStack (alignment: .center){
                        if (self.focusedTag == -1) {
                            Text(self.crossword.title).multilineTextAlignment(.center)
                            Text(self.crossword.author).multilineTextAlignment(.center)
                            Text(self.crossword.copyright).multilineTextAlignment(.center)
                        }
                    }
                }
            }
        }
            .navigationBarTitle(Text(verbatim: crossword.title), displayMode: .inline)
            .navigationBarColor(self.crossword.solved ? .systemGreen : .systemGray6)
    }

    func resetArray(count: Int) -> Array<Bool> {
        return Array(repeating: false, count: count)
    }

    func getCurrentClue() -> String {
        if (self.focusedTag < 0 || self.crossword.tagsToCluesMap[self.focusedTag] == nil) {
            return ""
        }
        let possibleClues : Dictionary<String, String> = (self.crossword.tagsToCluesMap[self.focusedTag])
        let directionalLetter : String = /*self.goingAcross ?*/ "A" /*: "D"*/
        return self.crossword.clueNamesToCluesMap[possibleClues[directionalLetter]!]!
    }

    func getRowNumberFromTag(_ tag: Int) -> Int {
        return tag / Int(self.crossword.cols)
    }
}

func toTime(_ currentTimeInSeconds: Int) -> String {
    let timeInSeconds = currentTimeInSeconds
    let numMin = timeInSeconds / 60
    let numSec = timeInSeconds % 60

    let secString: String = numSec < 10 ? "0"+String(numSec) : String(numSec)
    return String(numMin) + ":" + secString
}

class CellObject: ObservableObject {
    @Published var isHighlighted: Bool = false
    
    func changeHighlightStatus(status: Bool) {
        self.isHighlighted = status
    }
}

struct CrosswordGridView: View {

    @Binding var crossword: Crossword
    var boxWidth: CGFloat
    var currentClue: String

    @Binding var focusedTag: Int
    @Binding var highlighted: Array<Int>
    @Binding var goingAcross: Bool
    @Binding var forceUpdate: Bool
    @Binding var isKeyboardOpen: Bool
    @ObservedObject var cellObject: CellObject = CellObject()
    
//    mutating func updateHighlights(newFocusedTag: Int) {
//        var newHighlighted = Array<Int>()
//        let clues: Dictionary<String, String> = (crossword.tagsToCluesMap[newFocusedTag])
//        let directionalLetter: String = goingAcross ? "A" : "D"
//        let clue: String = clues[directionalLetter]!
//        let clueTags: Array<Int> = (crossword.cluesToTagsMap[clue])!
//        for clueTag in clueTags {
//            newHighlighted.append(clueTag)
//        }
//        for tag in newHighlighted {
//            self.highlightedList[tag] = true
//        }
//            //self.cellObjects[tag].changeHighlightStatus(status: true)
//    }
    func changeFocus(rowNum: Int, colNum: Int) {
        print("here")
    }

    var body: some View {
        VStack(spacing: 0) {
            ForEach((0...self.crossword.rows-1), id: \.self) { rowNum in
                HStack (spacing: 0) {
                    ForEach((0...self.crossword.cols-1), id: \.self) { colNum in
                        CrosswordCellView(
                            cellObject: self.cellObject,
                            crossword: self.$crossword,
                            boxWidth: self.boxWidth,
                            rowNum: Int(rowNum),
                            colNum: Int(colNum),
                            currentClue: self.currentClue,
                            focusedTag: self.$focusedTag,
                            isHighlighted: self.$highlighted,
                            goingAcross: self.$goingAcross,
                            forceUpdate: self.$forceUpdate,
                            isKeyboardOpen: self.$isKeyboardOpen,
                            changeFocusTag: self.changeFocus
                        ).frame(width: self.boxWidth, height: self.boxWidth)
                        .id("row"+String(rowNum))
                    }
                }
            }
        }//.onChange(of: focusedTag, perform: updateHighlights)
    }
}
