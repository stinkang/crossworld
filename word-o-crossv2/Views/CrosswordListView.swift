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
    @Binding var crossword: Crossword
    @Binding var showArchive: Bool
    @Binding var shouldSendCrosswordData: Bool
    @FetchRequest(
      entity: CrosswordModel.entity(),
      sortDescriptors: [
        NSSortDescriptor(keyPath: \CrosswordModel.lastAccessed, ascending: false)
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
                            chosenCrossword: $crossword,
                            showArchive: $showArchive,
                            shouldSendCrosswordData: $shouldSendCrosswordData
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
