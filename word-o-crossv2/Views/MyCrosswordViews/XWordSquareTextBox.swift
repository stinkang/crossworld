//
//  CrosswordSquareTextBox.swift
//  word-o-crossv2
//
//  Created by Austin Kang on 1/20/22.
//

import Foundation
import SwiftUI

struct XwordSquareTextBox: UIViewRepresentable {
    let width: CGFloat
    let answerText: String
    let index: Int
    let crossword: Crossword
    //let changeFocus: (Int) -> Void
    @ObservedObject var squareModel: SquareModel
    @State var givenText: String
    @EnvironmentObject var xWordViewModel: XWordViewModel
//    func changeFocusInternal() -> Void {
//        changeFocus(index)
//    }

    func makeUIView(context: Context) -> XWordSquareTextField {
        let textField = XWordSquareTextField(frame: .zero)
        textField.delegate = context.coordinator
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .allCharacters
        //textField.addTarget(context.coordinator, action: #selector(context.coordinator.touchTextField), for: .allTouchEvents)
        //textField.addTarget(self, action: #selector(context.coordinator.textFieldDidChange), for: .editingChanged)
        textField.font = UIFont(name: "Helvetica", size: CGFloat(width))
        textField.textColor = .black
        textField.textAlignment = .center;
        textField.tintColor = UIColor.clear
        textField.keyboardType = .asciiCapable
        //textField.inputView = UIInputView(frame: .init(x: 0, y: 0, width: UIScreen.screenWidth, height: 200), inputViewStyle: .keyboard)
        //textField.addToolbar()
        //textField.becomeFirstResponder()

        return textField
    }
    
    func updateUIView(_ uiTextField: XWordSquareTextField, context: Context) {
        if (squareModel.squareState == .focused) {
            uiTextField.becomeFirstResponder()
        }
        if (squareModel.squareState == .focused && xWordViewModel.textState == .backspacedTo) {
            uiTextField.text = ""
            xWordViewModel.changeTextState(to: .tappedOn)
        }
        if (squareModel.textFromOtherPlayer != "") {
            uiTextField.text = squareModel.textFromOtherPlayer
            squareModel.changeTextFromOtherPlayer(to: "")
        }
    }

    func updateTypedText(typedText: String) {
        xWordViewModel.changeShouldSendMessage(to: true)
        xWordViewModel.changeTypedText(to: typedText)
    }
    
    func handleBackspace() {
        xWordViewModel.handleBackspace()
    }
    
    func handleShouldGoBackOne() {
        xWordViewModel.changeTextState(to: .shouldGoBackOne)
    }
    
    func handleLetterTyped() {
        xWordViewModel.changeTextState(to: .letterTyped)
    }
    
//    static func dismantleUIView(_ uiTextField: XWordSquareTextField, coordinator: Coordinator) {
//
//    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self /*changeFocusInternal: changeFocusInternal*/)
    }
//
    class Coordinator: NSObject, UITextFieldDelegate {
        //let changeFocusInternal: () -> Void
        var parentTextBox: XwordSquareTextBox
        @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

        init(_ parentTextBox: XwordSquareTextBox /*changeFocusInternal: @escaping () -> Void, */) {
            self.parentTextBox = parentTextBox
        }
        
//        @objc func touchTextField(_ textField: UITextField) {
//            changeFocusInternal()
//        }

        func didPressBackspace(_ textField: UITextField) {
            if (textField.text == "") {
                parentTextBox.handleBackspace()
            }
            else {
                textField.text = ""
                parentTextBox.handleShouldGoBackOne()
            }
        }
        
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                               replacementString string: String) -> Bool
        {
            let maxLength = 1
            let currentString: NSString = textField.text! as NSString
            let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
            parentTextBox.handleLetterTyped()
            return newString.length <= maxLength
        }

        func textFieldDidEndEditing(_ textField: UITextField) {
            let currentString = textField.text!
            if (parentTextBox.xWordViewModel.typedText != currentString) {
                parentTextBox.updateTypedText(typedText: currentString)
            }
        }
    }
}
