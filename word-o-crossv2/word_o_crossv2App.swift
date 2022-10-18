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
        if let user = Auth.auth().currentUser {
            print("You're signed in as \(user.uid), email: \(user.email ?? "unknown")")
        }
    }

    var body: some Scene {
        WindowGroup {
            NavigationView {
                CrossWorldView()
                    .navigationTitle("CrossWorld!")
            }
            .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
        .onChange(of: scenePhase) { _ in
            persistenceController.save()
        }
    }

}
