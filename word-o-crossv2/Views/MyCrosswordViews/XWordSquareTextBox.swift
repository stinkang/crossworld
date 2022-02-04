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
    let handleBackspace: () -> Void
    @ObservedObject var squareModel: SquareModel
    @State var givenText: String
    @Binding var textState: TextState

//    func changeFocusInternal() -> Void {
//        changeFocus(index)
//    }

    func makeUIView(context: Context) -> XWordSquareTextField {
        let textField = XWordSquareTextField(frame: .zero)
        textField.delegate = context.coordinator
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .allCharacters
        //textField.addTarget(context.coordinator, action: #selector(context.coordinator.touchTextField), for: .allTouchEvents)
        textField.font = UIFont(name: "Helvetica Bold", size: CGFloat(70 * width / 100))
        textField.textColor = .black
        textField.textAlignment = .center;
        //textField.addToolbar()
        //textField.becomeFirstResponder()

        return textField
    }
    
    func updateUIView(_ uiTextField: XWordSquareTextField, context: Context) {
        if (squareModel.squareState == .focused) {
            uiTextField.becomeFirstResponder()
        }
        if (squareModel.squareState == .focused && textState == .backspacedTo) {
            uiTextField.text = ""
            textState = .tappedOn
        }
    }
    
//    static func dismantleUIView(_ uiTextField: XWordSquareTextField, coordinator: Coordinator) {
//
//    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self, /*changeFocusInternal: changeFocusInternal*/ textState: $textState)
    }
//
    class Coordinator: NSObject, UITextFieldDelegate {
        @Binding var textState: TextState
        //let changeFocusInternal: () -> Void
        var parentTextBox: XwordSquareTextBox
        @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

        init(_ parentTextBox: XwordSquareTextBox, /*changeFocusInternal: @escaping () -> Void, */textState: Binding<TextState>) {
            self.parentTextBox = parentTextBox
            //self.changeFocusInternal = changeFocusInternal
            self._textState = textState
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
                parentTextBox.textState = .shouldGoBackOne
            }
        }
        
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                               replacementString string: String) -> Bool
        {
            let maxLength = 1
            let currentString: NSString = textField.text! as NSString
            let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
            parentTextBox.textState = .letterTyped
            return newString.length <= maxLength
        }

    }
}
