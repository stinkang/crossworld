//
//  XSquareTextField.swift
//  word-o-crossv2
//
//  Created by Austin Kang on 1/20/22.
//

import Foundation
import UIKit

class XWordSquareTextField: UITextField {
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        OperationQueue.main.addOperation {
            UIMenuController.shared.hideMenu()
        }
        return false
    }

    override func deleteBackward() {
        if let delegate = self.delegate as? XwordSquareTextBox.Coordinator {
            delegate.didPressBackspace(self)
        }
    }
}
