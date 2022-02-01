//
//  CrosswordCellView.swift
//  crosswords
//
//  Created by Rohan Narayan on 7/23/20.
//  Copyright © 2020 Rohan Narayan. All rights reserved.
//

import SwiftUI

struct CrosswordCellView: View {
    @ObservedObject var cellObject: CellObject
    @Binding var crossword: Crossword
    var boxWidth: CGFloat
    var rowNum: Int
    var colNum: Int
    var currentClue: String
    var tag: Int {
        rowNum*Int(crossword.cols)+colNum
    }

    var circle: Int? {
        if crossword.circles != nil {
            return crossword.circles![tag]
        }
        return nil
    }

    @Binding var focusedTag: Int
    @Binding var isHighlighted: Array<Int>
    @Binding var goingAcross: Bool
    @Binding var forceUpdate: Bool
    @Binding var isKeyboardOpen: Bool
    var changeFocusTag: (Int, Int) -> ()

    var body: some View {
        ZStack(alignment: .topLeading){
            CrosswordTextFieldView(crossword: $crossword, cellObject: cellObject, boxWidth: self.boxWidth, rowNum: rowNum, colNum: colNum, currentClue: currentClue, focusedTag: self.$focusedTag, isHighlighted: self.$isHighlighted, goingAcross: self.$goingAcross, forceUpdate: self.$forceUpdate, isKeyboardOpen: self.$isKeyboardOpen, changeFocusTag: self.changeFocusTag)
            if circle != nil  && circle == 1 {
                Circle()
                    .stroke(Color.black, lineWidth: 0.5)
            }
        }
        .contentShape(Rectangle())
//        .contextMenu {
//            Button(action: {
//                self.crossword.entries[self.focusedTag] = self.crossword.grid[self.focusedTag]
//                if (self.crossword.entries == self.crossword.grid) {
//                    self.crossword.solved = true
//                }
//           }) {
//               Text("Solve Square")
//           }
//        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("nextClue"))) { notification in
            if (self.tag == 0) {
                goToNextClue(tag: self.focusedTag, crossword: self.crossword, goingAcross: self.goingAcross, focusedTag: self.$focusedTag, isHighlighted: self.$isHighlighted)
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("previousClue"))) { notification in
            if (self.tag == 0) {
                goToPreviousClue(tag: self.focusedTag, crossword: self.crossword, goingAcross: self.goingAcross, focusedTag: self.$focusedTag, isHighlighted: self.$isHighlighted)
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("rightCell"))) { notification in
            if (self.tag == 0) {
                goToRightCell(tag: self.focusedTag, crossword: self.crossword, goingAcross: self.goingAcross, focusedTag: self.$focusedTag, isHighlighted: self.$isHighlighted)
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("leftCell"))) { notification in
            if (self.tag == 0) {
                goToLeftCell(tag: self.focusedTag, crossword: self.crossword, goingAcross: self.goingAcross, focusedTag: self.$focusedTag, isHighlighted: self.$isHighlighted)
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("upCell"))) { notification in
            if (self.tag == 0) {
                goToUpCell(tag: self.focusedTag, crossword: self.crossword, goingAcross: self.goingAcross, focusedTag: self.$focusedTag, isHighlighted: self.$isHighlighted)
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("downCell"))) { notification in
            if (self.tag == 0) {
                goToDownCell(tag: self.focusedTag, crossword: self.crossword, goingAcross: self.goingAcross, focusedTag: self.$focusedTag, isHighlighted: self.$isHighlighted)
            }
        }
    }
}

struct CrosswordTextFieldView: UIViewRepresentable {
    @Binding var crossword: Crossword
    @ObservedObject var cellObject: CellObject
    var boxWidth: CGFloat
    var rowNum: Int
    var colNum: Int
    var currentClue: String
    var tag: Int {
        rowNum*Int(crossword.cols)+colNum
    }

    var toggleImage: UIImage {
        if (self.goingAcross) {
            return UIImage(systemName: "chevron.forward")!
        } else {
            return UIImage(systemName: "chevron.down")!
        }
    }

    var skipCompletedCells: Bool {
        UserDefaults.standard.object(forKey: "skipCompletedCells") as? Bool ?? true
    }


    @Binding var focusedTag: Int
    @Binding var isHighlighted: Array<Int>
    @Binding var goingAcross: Bool
    @Binding var forceUpdate: Bool
    @Binding var isKeyboardOpen: Bool
    var changeFocusTag: (Int, Int) -> ()
    @Environment(\.colorScheme) var colorScheme
    //@EnvironmentObject var timerWrapper : TimerWrapper
    //@ObservedObject var userSettings = UserSettings()

    func makeUIView(context: Context) -> NoActionTextField {
        let textField = NoActionTextField(frame: .zero)
        textField.tag = self.tag
        textField.delegate = context.coordinator
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .allCharacters
        textField.text = self.crossword.entries[self.tag]
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.borderWidth = 0.25
        textField.textAlignment = NSTextAlignment.center
        textField.font = UIFont(name: "Helvetica", size: 70*boxWidth/100)
        textField.keyboardType = UIKeyboardType.alphabet
        textField.tintColor = UIColor.clear
        textField.textColor = UIColor.black
        if (textField.text! == (".")) {
            textField.textColor = UIColor.black
            textField.backgroundColor = UIColor.black
        } else {
            textField.backgroundColor = UIColor.white
        }

        textField.addTarget(context.coordinator, action: #selector(context.coordinator.touchTextFieldWhileFocused), for: .allTouchEvents)
        textField.addToolbar()
        return textField
    }

    func updateUIView(_ uiTextField: NoActionTextField, context: Context) {
        if (uiTextField.isFirstResponder) {
            if (!uiTextField.gestureRecognizers!.contains(where: { (gestureRecognizer) -> Bool in
                gestureRecognizer is SingleTouchDownGestureRecognizer
            })) {
                let gesture = SingleTouchDownGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.touchTextFieldWhileFocused))
                uiTextField.addGestureRecognizer(gesture)
            }
            let currentClueForce = self.forceUpdate ? currentClue : currentClue + " "
            uiTextField.changeToolbar(clueTitle: currentClueForce, toggleImage: toggleImage, coordinator: context.coordinator, barColor: self.crossword.solved ? UIColor.systemGreen : UIColor.systemGray6)
        }

        if uiTextField.text != self.crossword.entries[self.tag] {
            uiTextField.text = self.crossword.entries[self.tag]
        }

        if focusedTag < 0 {
            uiTextField.resignFirstResponder()
        }

        if self.isEditable() {
            // remove after debugging focusedTag
            if (self.tag == focusedTag) {
                uiTextField.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.8)
            } else {
                uiTextField.backgroundColor = UIColor.white
            }
//            if isHighlighted.contains(self.tag) {
//                if (colorScheme == .dark) {
//                    if (self.tag == focusedTag) {
//                        uiTextField.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.8)
//                    } else {
//                        uiTextField.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.5)
//                    }
//                } else {
//                    if (self.tag == focusedTag) {
//                        uiTextField.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.6)
//                    } else {
//                        uiTextField.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.2)
//                    }
//                }
//            } else {
//                uiTextField.backgroundColor = UIColor.white
//            }
        }

//        if self.doErrorTracking {
//            let entry = self.crossword.entries[self.tag]
//            if (entry != "" && entry != self.crossword.grid[self.tag]) {
//                if isHighlighted.contains(self.tag) {
//                    if (self.tag == focusedTag) {
//                        uiTextField.backgroundColor = UIColor.systemRed.withAlphaComponent(0.6)
//                    } else {
//                        uiTextField.backgroundColor = UIColor.systemRed.withAlphaComponent(0.5)
//                    }
//                } else {
//                    uiTextField.backgroundColor = UIColor.systemRed.withAlphaComponent(0.4)
//                }
//            }
//        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(crossword: $crossword, self)
    }

    func isEditable() -> Bool {
        return self.crossword.entries[self.tag] != "."
    }

    func getNextClueID() -> String {
        return self.getNextClueID(tag: self.focusedTag)
    }

    func getNextClueID(tag: Int) -> String {
        return CrossWorld_.getNextClueID(tag: tag, crossword: self.crossword, goingAcross: self.goingAcross)
    }

    func getPreviousClueID() -> String {
        return CrossWorld_.getPreviousClueID(tag: self.focusedTag, crossword: self.crossword, goingAcross: self.goingAcross)
    }

    class Coordinator: NSObject, UITextFieldDelegate {
        @Binding var crossword: Crossword
        var parent: CrosswordTextFieldView
        @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

        @objc func touchTextFieldWhileFocused(textField: NoActionTextField) {
            if (parent.tag == parent.focusedTag) {
                toggleDirection(tag: parent.focusedTag, crossword: parent.crossword, goingAcross: parent.$goingAcross, isHighlighted: parent.$isHighlighted)
            } else {
                changeFocusToTag(parent.tag)
            }
        }

        @objc func pressToggleButton(textField: NoActionTextField) {
            toggleDirection(tag: parent.focusedTag, crossword: parent.crossword, goingAcross: parent.$goingAcross, isHighlighted: parent.$isHighlighted)
        }

        @objc func goToNextClue(textField: NoActionTextField) {
            CrossWorld_.goToNextClue(tag: parent.focusedTag, crossword: parent.crossword, goingAcross: parent.goingAcross, focusedTag: parent.$focusedTag, isHighlighted: parent.$isHighlighted)
        }

        @objc func goToPreviousClue(textField: NoActionTextField) {
            CrossWorld_.goToPreviousClue(tag: parent.focusedTag, crossword: parent.crossword, goingAcross: parent.goingAcross, focusedTag: parent.$focusedTag, isHighlighted: parent.$isHighlighted)
        }

        @objc func hideKeyboard(textField: NoActionTextField) {
            changeFocusToTag(-1)
        }

        init(crossword: Binding<Crossword>, _ textField: CrosswordTextFieldView) {
            self._crossword = crossword
            self.parent = textField
        }

        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            moveFocusToNextField(textField)
            return true
        }

//        func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//            if (!parent.isEditable()){
//                return false
//            }
//
//            if (parent.focusedTag == parent.tag) {
//                toggleDirection(tag: parent.tag, crossword: parent.crossword, goingAcross: parent.$goingAcross, isHighlighted: parent.$isHighlighted)
//            }
//
//            changeFocusToTag(parent.tag)
//            if (parent.isKeyboardOpen) {
//                return false
//            } else {
//                parent.isKeyboardOpen = true
//                return true
//            }
//        }
        
        func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
            parent.changeFocusTag(parent.rowNum, parent.colNum)
            return true
        }

        func didPressBackspace(_ textField: UITextField) {
            if (parent.focusedTag < 0) {
                return
            }

            if (crossword.entries[parent.focusedTag] != "" && crossword.entries[parent.focusedTag] != ".") {
                crossword.entries[parent.focusedTag] = ""
                parent.forceUpdate = !parent.forceUpdate
            } else {
                let lastSquare = parent.crossword.grid.count - 1
                var acrossPreviousTag = parent.focusedTag - 1
                if acrossPreviousTag < 0 {
                    acrossPreviousTag = parent.crossword.grid.count - 1
                }
                var downPreviousTag = parent.focusedTag - Int(crossword.cols)
                if downPreviousTag < 0 {
                    downPreviousTag = parent.crossword.grid.count - 1
                }
                var previousTag: Int
                if (parent.goingAcross) {
                    while (crossword.entries[acrossPreviousTag] == ".") {
                        acrossPreviousTag -= 1
                        if (acrossPreviousTag < 0) {
                            acrossPreviousTag = lastSquare
                        }
                    }
                    previousTag = acrossPreviousTag
                } else {
                    while (crossword.entries[downPreviousTag] == ".") {
                        downPreviousTag -= Int(crossword.cols)
                        if (downPreviousTag < 0) {
                            downPreviousTag = lastSquare
                        }
                    }
                    previousTag = downPreviousTag
                }
                if (previousTag < crossword.entries.count) {
                    crossword.entries[previousTag] = ""
                    changeFocusToTag(previousTag)
                } else {
                    let prevClueId: String = parent.getPreviousClueID()
                    previousTag = crossword.cluesToTagsMap[prevClueId]!.max()!
                    changeFocusToTag(previousTag)
                }
            }
        }

        func textField(_ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String) -> Bool {
            if (textField.text == "." || string == "." || parent.focusedTag < 0) {
                return false
            }

            if (string == " " /*&& parent.userSettings.spaceTogglesDirection*/) {
                toggleDirection(tag: parent.focusedTag, crossword: parent.crossword, goingAcross: parent.$goingAcross, isHighlighted: parent.$isHighlighted)
                return false
            }

            if (string == " ") {
                moveFocusToNextField(textField)
                return false
            }

            if (string.isEmpty) {
                didPressBackspace(textField)
            } else {
                crossword.entries[parent.focusedTag] = string.uppercased()
            }

            if (parent.crossword.entries == parent.crossword.grid) {
                parent.crossword.solved = true
                //parent.timerWrapper.stop()
            } else if (parent.crossword.solved) {
                parent.crossword.solved = false
            }
            //parent.crossword.solvedTime = Int16(parent.timerWrapper.count)

            delegate.saveContext()

            if (!string.isEmpty) {
                moveFocusToNextField(textField)
            }
            return false
        }

        func moveFocusToNextField(_ textField: UITextField) {
            let nextTag: Int = getNextTagId()
            if (nextTag >= parent.crossword.grid.count || parent.crossword.tagsToCluesMap[nextTag] == nil || parent.crossword.tagsToCluesMap[nextTag].count == 0 || parent.crossword.entries[nextTag] != "") {
                if (parent.skipCompletedCells) {
                    // skip to next uncompleted square
                    var possibleTag: Int = getNextTagId(parent.focusedTag)
                    var oldTag: Int = parent.focusedTag
                    for _ in (1..<parent.crossword.entries.count) {
                        if (possibleTag >= parent.crossword.entries.count ||
                                parent.crossword.grid[possibleTag] == "." ||
                                parent.crossword.tagsToCluesMap[possibleTag] == nil ||
                                parent.crossword.tagsToCluesMap[possibleTag].count == 0) {
                            // if we're checking the end, start checking again from the start
                            // if we're at a block, start checking the next clue
                            // if we're beyond the bounds of the puzzle, start checking next clue
                            let possibleNextClueId: String = parent.getNextClueID(tag: oldTag)
                            possibleTag = parent.crossword.cluesToTagsMap[possibleNextClueId]!.min()!
                        } else if (parent.crossword.entries[possibleTag] == "") {
                            // if the possibleTag is empty, go there
                            changeFocusToTag(possibleTag)
                            return
                        } else {
                            // possibleTag's cell is full, so move to next cell
                            oldTag = possibleTag
                            possibleTag = getNextTagId(possibleTag)
                        }
                    }
                // if it reaches here, just try the next cell
                changeFocusToTag(nextTag)
                } else if (nextTag >= parent.crossword.grid.count || parent.crossword.tagsToCluesMap[nextTag] == nil || parent.crossword.tagsToCluesMap[nextTag].count == 0) {
                    // they don't want to skip completed cells, so when we're at the end of the puzzle/at a square, go to start of the next clue
                    let nextClueId: String = parent.getNextClueID()
                    let nextTag: Int = parent.crossword.cluesToTagsMap[nextClueId]!.min()!
                    changeFocusToTag(nextTag)
                } else {
                    // they don't want to skip completed cells, and we're checking a valid square, so just go to that square
                    changeFocusToTag(nextTag)
                }
            } else {
                // the next cell is a valid empty square
                changeFocusToTag(nextTag)
            }
        }

        func getNextTagId() -> Int {
            return getNextTagId(parent.focusedTag)
        }

        func getNextTagId(_ tag: Int) -> Int {
            if (parent.goingAcross) {
                return tag + 1
            } else {
                return tag + Int(parent.crossword.cols)
            }
        }

        // does not take settings / completed squares into account
        func changeFocusToTag(_ tag: Int) {
            changeFocus(tag: tag, crossword: parent.crossword, goingAcross: parent.goingAcross, focusedTag: parent.$focusedTag, isHighlighted: parent.$isHighlighted)
        }
    }
}

func changeFocus(tag: Int, crossword: Crossword, goingAcross: Bool, focusedTag: Binding<Int>,
                      isHighlighted: Binding<Array<Int>>) {
    if (tag < 0 || tag >= crossword.grid.count || crossword.tagsToCluesMap[tag] == nil
        || crossword.tagsToCluesMap[tag].count == 0) {
        focusedTag.wrappedValue = -1
        isHighlighted.wrappedValue = Array<Int>()
        return
    }
    focusedTag.wrappedValue = tag
    setHighlighting(tag: tag, crossword: crossword, goingAcross: goingAcross, isHighlighted: isHighlighted)
}

func toggleDirection(tag: Int, crossword: Crossword, goingAcross: Binding<Bool>, isHighlighted: Binding<Array<Int>>) {
    if (crossword.entries[tag] == ".") {
        return
    }
    //goingAcross.wrappedValue = !goingAcross.wrappedValue
    //setHighlighting(tag: tag, crossword: crossword, goingAcross: goingAcross.wrappedValue, isHighlighted: isHighlighted)
}

func getNextClueID(tag: Int, crossword: Crossword, goingAcross: Bool) -> String {
    let directionalLetter: String = goingAcross == true ? "A" : "D"
    let currentClueID: String = crossword.tagsToCluesMap[tag][directionalLetter]!
    let currentClueNum: Int = Int(String(currentClueID.dropLast()))!
    for i in (currentClueNum+1..<crossword.clueNamesToCluesMap.count) {
        let trialClueID: String = String(i)+directionalLetter
        if crossword.clueNamesToCluesMap[trialClueID] != nil {
            return trialClueID
        }
    }
    return String(1)+directionalLetter
}

func goToNextClue(tag: Int, crossword: Crossword, goingAcross: Bool, focusedTag: Binding<Int>, isHighlighted: Binding<Array<Int>>) {
    let nextClueId: String = getNextClueID(tag: tag, crossword: crossword, goingAcross: goingAcross)
    let nextTag: Int = crossword.cluesToTagsMap[nextClueId]!.min()!
    changeFocus(tag: nextTag, crossword: crossword, goingAcross: goingAcross, focusedTag: focusedTag, isHighlighted: isHighlighted)
}

func goToRightCell(tag: Int, crossword: Crossword, goingAcross: Bool, focusedTag: Binding<Int>, isHighlighted: Binding<Array<Int>>) {
    for i in (tag+1..<crossword.grid.count) {
        if (crossword.grid[i] != ".") {
            changeFocus(tag: i, crossword: crossword, goingAcross: goingAcross, focusedTag: focusedTag, isHighlighted: isHighlighted)
            return
        }
    }
}

func goToLeftCell(tag: Int, crossword: Crossword, goingAcross: Bool, focusedTag: Binding<Int>, isHighlighted: Binding<Array<Int>>) {
    for i in (0..<tag).reversed() {
        if (crossword.grid[i] != ".") {
            changeFocus(tag: i, crossword: crossword, goingAcross: goingAcross, focusedTag: focusedTag, isHighlighted: isHighlighted)
            return
        }
    }
}

func goToUpCell(tag: Int, crossword: Crossword, goingAcross: Bool, focusedTag: Binding<Int>, isHighlighted: Binding<Array<Int>>) {
    var proposedTag = tag - Int(crossword.cols)
    while(proposedTag > 0) {
        if (crossword.grid[proposedTag] != ".") {
            changeFocus(tag: proposedTag, crossword: crossword, goingAcross: goingAcross, focusedTag: focusedTag, isHighlighted: isHighlighted)
            return
        }
        proposedTag -= Int(crossword.cols)
    }
}

func goToDownCell(tag: Int, crossword: Crossword, goingAcross: Bool, focusedTag: Binding<Int>, isHighlighted: Binding<Array<Int>>) {
    var proposedTag = tag + Int(crossword.cols)
    while(proposedTag < crossword.grid.count) {
        if (crossword.grid[proposedTag] != ".") {
            changeFocus(tag: proposedTag, crossword: crossword, goingAcross: goingAcross, focusedTag: focusedTag, isHighlighted: isHighlighted)
            return
        }
        proposedTag += Int(crossword.cols)
    }
}

func goToPreviousClue(tag: Int, crossword: Crossword, goingAcross: Bool, focusedTag: Binding<Int>, isHighlighted: Binding<Array<Int>>) {
    if (UserDefaults.standard.object(forKey: "enableHapticFeedback") as? Bool ?? true) {
        let impactMed = UIImpactFeedbackGenerator(style: .medium)
        impactMed.impactOccurred()
    }
    let prevClueId: String = getPreviousClueID(tag: tag, crossword: crossword, goingAcross: goingAcross)
    let prevTag: Int = crossword.cluesToTagsMap[prevClueId]!.min()!
    changeFocus(tag: prevTag, crossword: crossword, goingAcross: goingAcross, focusedTag: focusedTag, isHighlighted: isHighlighted)
}

func getPreviousClueID(tag: Int, crossword: Crossword, goingAcross: Bool) -> String {
    let directionalLetter: String = goingAcross == true ? "A" : "D"
    let currentClueID: String = crossword.tagsToCluesMap[tag][directionalLetter]!
    let currentClueNum: Int = Int(String(currentClueID.dropLast()))!
    for i in (1..<currentClueNum).reversed() {
        let trialClueID: String = String(i)+directionalLetter
        if crossword.clueNamesToCluesMap[trialClueID] != nil {
            return trialClueID
        }
    }
    return String(1)+directionalLetter
}

func setHighlighting(tag: Int, crossword: Crossword, goingAcross: Bool, isHighlighted: Binding<Array<Int>>) {
    var newHighlighted = Array<Int>()
    newHighlighted.append(tag)

    let clues: Dictionary<String, String> = (crossword.tagsToCluesMap[tag])
    let directionalLetter: String = goingAcross ? "A" : "D"
    let clue: String = clues[directionalLetter]!
    let clueTags: Array<Int> = (crossword.cluesToTagsMap[clue])!
    for clueTag in clueTags {
        newHighlighted.append(clueTag)
    }
    //isHighlighted.wrappedValue = newHighlighted
}

class NoActionTextField: UITextField {
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        OperationQueue.main.addOperation {
            UIMenuController.shared.setMenuVisible(false, animated: false)
        }
        return false
    }

    override func deleteBackward() {
        if let delegate = self.delegate as? CrosswordTextFieldView.Coordinator {
            delegate.didPressBackspace(self)
        }
    }
}

class SingleTouchDownGestureRecognizer: UIGestureRecognizer {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        if self.state == .possible {
            self.state = .recognized
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        self.state = .failed
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        self.state = .failed
    }
}

//extension UIScreen{
//   static let screenWidth = UIScreen.main.bounds.size.width
//   static let screenHeight = UIScreen.main.bounds.size.height
//   static let screenSize = UIScreen.main.bounds.size
//}
