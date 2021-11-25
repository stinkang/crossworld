//
//  word_o_crossv2App.swift
//  word-o-crossv2
//
//  Created by Austin Kang on 11/23/21.
//

import SwiftUI

@main
struct word_o_crossv2App: App {
    var body: some Scene {
        WindowGroup {
            CrosswordView(crossword: loadJson(fileName: "Nov24th")!)
        }
    }
}
