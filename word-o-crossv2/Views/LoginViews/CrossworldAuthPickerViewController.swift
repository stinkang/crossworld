//
//  CrossworldAuthPickerViewController.swift
//  word_o_crossv2
//
//  Created by Austin Kang on 10/14/22.
//

import Foundation
import FirebaseAuthUI


class CrossworldAuthPickerViewController: FUIAuthPickerViewController {
    override func viewDidLoad() {
        navigationController?.setToolbarHidden(true, animated: false)
        super.viewDidLoad()
    }
}
