//
//  word_o_crossv2App.swift
//  word-o-crossv2
//
//  Created by Austin Kang on 11/23/21.

import SwiftUI

@main
struct word_o_crossv2App: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            NavigationView {
                CrossWorldView()
            }
        }
    }
}
