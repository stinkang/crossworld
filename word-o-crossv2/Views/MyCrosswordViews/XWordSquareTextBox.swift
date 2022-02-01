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
    let changeFocus: (Int) -> Void
    @ObservedObject var squareState: SquareState
    @State var givenText: String

    func changeFocusInternal() -> Void {
        changeFocus(index)
    }

    func makeUIView(context: Context) -> XWordSquareTextField {
        let textField = XWordSquareTextField(frame: .zero)
        textField.delegate = context.coordinator
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .allCharacters
        textField.addTarget(context.coordinator, action: #selector(context.coordinator.touchTextField), for: .allTouchEvents)
        textField.font = UIFont(name: "Helvetica", size: CGFloat(70 * width / 100))
        //textField.addToolbar()
        //textField.becomeFirstResponder()

        return textField
    }
    
    func updateUIView(_ uiTextField: XWordSquareTextField, context: Context) {
//        if (squareState.state) {
//            uiTextField.becomeFirstResponder()
//        }
    }
    
//    static func dismantleUIView(_ uiTextField: XWordSquareTextField, coordinator: Coordinator) {
//
//    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UITextFieldDelegate {
        var parentTextBox: XwordSquareTextBox
        @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

        init(_ parentTextBox: XwordSquareTextBox) {
            self.parentTextBox = parentTextBox
        }

        @objc func touchTextField(textField: XWordSquareTextField) {
            parentTextBox.changeFocusInternal()
        }
        
        @objc func pressToggleButton(textField: XWordSquareTextField) {
        }

        @objc func goToNextClue(textField: XWordSquareTextField) {
        }

        @objc func goToPreviousClue(textField: XWordSquareTextField) {
        }
        
        func didPressBackspace(_ textField: UITextField) {
        }

    }
}
