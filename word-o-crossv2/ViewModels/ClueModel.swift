//
//  ClueModel.swift
//  word_o_crossv2
//
//  Created by Austin Kang on 2/1/22.
//

import Foundation
class XWordViewModel: ObservableObject {

    @Published var clue: String = ""

    func change(to clue: String) {
        self.clue = clue
    }
}
