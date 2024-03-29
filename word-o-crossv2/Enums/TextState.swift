//
//  TextState.swift
//  word_o_crossv2
//
//  Created by Austin Kang on 2/8/22.
//

import Foundation

enum TextState {
    case typedTo
    case tappedOn
    case letterTyped
    case letterTyped2
    case backspacedTo
    case shouldGoBackOne
}

enum BackspaceState {
    case backspacedTo
    case notBackspacedTo
}
