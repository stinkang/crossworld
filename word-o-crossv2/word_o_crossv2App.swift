//
//  word_o_crossv2App.swift
//  word-o-crossv2
//
//  Created by Austin Kang on 11/23/21.

import SwiftUI
import Firebase

@main
struct word_o_crossv2App: App {
    @Environment(\.scenePhase) var scenePhase

    let persistenceController = PersistenceController.shared
    
    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            NavigationView {
                LobbyView()
            }
            .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
        .onChange(of: scenePhase) { _ in
            persistenceController.save()
        }
    }

}
