//
//  SquareStateModel.swift
//  word_o_crossv2
//
//  Created by Austin Kang on 1/28/22.
//

import Foundation

class SquareState: ObservableObject {

    @Published var state: Bool = false

    func change(to state: Bool) {
        self.state = state
    }
}
