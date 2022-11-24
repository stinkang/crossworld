//
//  MakexWordPermanentKeyboard.swift
//  word_o_crossv2
//
//  Created by Austin Kang on 11/7/22.
//

import Foundation
import SwiftUI


struct MakeXWordPermanentKeyboard: UIViewRepresentable {
    @Binding var text: String
    @EnvironmentObject var viewModel: MakeXWordViewModel
    
    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: MakeXWordPermanentKeyboard
        
        init(_ parent: MakeXWordPermanentKeyboard) {
            self.parent = parent
        }
        
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            //Async to prevent updating state during view update
            DispatchQueue.main.async { [self] in
                if let last = string.last {
                    //Check if last character is alpha
                    if last.isLetter {
                        //Changes the binding to the last character of input, UPPERCASED
                        self.parent.text = String(last).uppercased()
                        self.parent.viewModel.handleLetterTyped()
//                        self.parent.viewModel.changeTypedText(to: parent.text)
//                        self.parent.viewModel.changeTextState(to: .letterTyped)
                    }
                    
                //Allows backspace
                } else if string == "" {
                    let prevText = self.parent.text
                    self.parent.text = ""
                    if (prevText == "") {
                        // notify the viewModel to go back one square
                        self.parent.viewModel.handleBackspace()
                    } else {
                        self.parent.viewModel.changeFocusedIndex(to: self.parent.viewModel.focusedIndex)
                    }
                }
            }
            
            return false
        }
        
        // only called when the textfield is already empty
        func textFieldDidDelete(_ textField: UITextField) -> Void {
            parent.viewModel.handleBackspaceFromEmptySquare()
        }

    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> MakeXWordPermanentTextField {
        let textfield = MakeXWordPermanentTextField()
        textfield.delegate = context.coordinator
        textfield.autocorrectionType = .no
        //Makes textfield invisible
        textfield.tintColor = .clear
        textfield.textColor = .clear
        textfield.spellCheckingType = .no
        textfield.autocapitalizationType = .none
        
        return textfield
    }
    
//    @objc func resetTapped() {
//        print("ere")
//    }
    
    func updateUIView(_ uiView: MakeXWordPermanentTextField, context: Context) {
        uiView.text = text
        
        //Makes keyboard permanent
        if !uiView.isFirstResponder {
            uiView.becomeFirstResponder()
        }
        
        //Reduces space textfield takes up as much as possible
        uiView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        uiView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
}

class MakeXWordPermanentTextField: UITextField {
    override func deleteBackward() {
        if let delegate = self.delegate as? MakeXWordPermanentKeyboard.Coordinator {
            
            delegate.textFieldDidDelete(self)
        }
    }
}
