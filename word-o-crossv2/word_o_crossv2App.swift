//
//  word_o_crossv2App.swift
//  word-o-crossv2
//
//  Created by Austin Kang on 11/23/21.

import SwiftUI
import GameKit

@main
struct word_o_crossv2App: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                LobbyView()
            }
            //.environment(\.colorScheme, .dark)
        }
    }
}
