//
//  CrosswordListView.swift
//  word_o_crossv2
//
//  Created by Austin Kang on 3/9/22.
//

import SwiftUI
import GameKit
import CoreData

struct CrosswordListView: View {
    var xWordMatch: GKMatch
    @Binding var shouldSendGoBackToLobbyMessage: Bool
    @Binding var shouldSendCrosswordData: Bool
    @Binding var opponent: GKPlayer
    @Binding var connectedStatus: Bool
    @FetchRequest(
      entity: CrosswordModel.entity(),
      sortDescriptors: [
        NSSortDescriptor(keyPath: \CrosswordModel.title, ascending: true)
      ]
    ) var crosswords: FetchedResults<CrosswordModel>
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    var didSave = NotificationCenter.default.publisher(for: .NSManagedObjectContextDidSave)
    @State var refreshID = UUID()
    
    var body: some View {
        VStack {
            List {
                Section(header: Text("Crossword Archive")) {
                    ForEach(crosswords, id: \.title) {
                        CrosswordListRow(
                            crosswordModel: $0,
                            xWordMatch: xWordMatch,
                            shouldSendGoBackToLobbyMessage: $shouldSendGoBackToLobbyMessage,
                            shouldSendCrosswordData: $shouldSendCrosswordData,
                            opponent: $opponent,
                            connectedStatus: $connectedStatus
                        )
                    }
                    .onDelete(perform: deleteCrossword)
                    .id(refreshID)
                    .onReceive(self.didSave) { _ in   //the listener
                        self.refreshID = UUID()
                        print("generated a new UUID")
                    }
                }
            }
        }
    }
    
    func deleteCrossword(at offsets: IndexSet) {
      // 1
      offsets.forEach { index in
        // 2
        let crossword = self.crosswords[index]
        // 3
        self.managedObjectContext.delete(crossword)
      }
      // 4
      saveContext()
    }
    
    func saveContext() {
      do {
        try managedObjectContext.save()
      } catch {
        print("Error saving managed object context: \(error)")
      }
    }
}

//struct CrosswordListView_Previews: PreviewProvider {
//    static var previews: some View {
//        CrosswordListView()
//    }
//}
