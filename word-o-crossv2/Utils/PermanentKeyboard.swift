//
//  PermanentKeyboard.swift
//  word_o_crossv2
//
//  Created by Austin Kang on 2/8/22.
//

import Foundation
import SwiftUI


struct PermanentKeyboard: UIViewRepresentable {
    @Binding var text: String
    @EnvironmentObject var xWordViewModel: XWordViewModel
    
    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: PermanentKeyboard
        
        init(_ parent: PermanentKeyboard) {
            self.parent = parent
        }
        
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            //Async to prevent updating state during view update
            DispatchQueue.main.async { [self] in
                if let last = string.last {
                    
                    //Check if last character is alpha
                    if last.isLetter {
                        
                        //Changes the binding to the last character of input, UPPERCASED
                        if (!self.parent.xWordViewModel.solved) {
                            self.parent.text = String(last).uppercased()
                            self.parent.xWordViewModel.changeTypedText(to: parent.text)
                            self.parent.xWordViewModel.changeTextState(to: .letterTyped)
                        }
                    }
                    
                //Allows backspace
                } else if string == "" {
                    if (!self.parent.xWordViewModel.solved) {
                        self.parent.text = ""
                        self.parent.xWordViewModel.changeTextState(to: .shouldGoBackOne)
                    }
                }
            }
            
            return false
        }
        
        func textFieldDidDelete(_ textField: UITextField) -> Void {
            parent.xWordViewModel.handleBackspace()
        }

    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> PermanentTextField {
        let textfield = PermanentTextField()
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
    
    func updateUIView(_ uiView: PermanentTextField, context: Context) {
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

class PermanentTextField: UITextField {
    override func deleteBackward() {
        if let delegate = self.delegate as? PermanentKeyboard.Coordinator {
            
            delegate.textFieldDidDelete(self)
        }
    }
}
