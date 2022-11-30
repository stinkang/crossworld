//
//  MakeCrosswordListView.swift
//  word_o_crossv2
//
//  Created by Austin Kang on 11/28/22.
//

import SwiftUI
import GameKit
import CoreData

struct MakeCrosswordListView: View {
    @Binding var makeCrosswordModel: MakeCrosswordModel
    @Binding var showArchive: Bool
    @FetchRequest(
      entity: MakeCrosswordModel.entity(),
      sortDescriptors: [
        NSSortDescriptor(keyPath: \MakeCrosswordModel.date, ascending: false)
      ]
    ) var makeCrosswordModels: FetchedResults<MakeCrosswordModel>
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    var didSave = NotificationCenter.default.publisher(for: .NSManagedObjectContextDidSave)
    @State var refreshID = UUID()
    
    var body: some View {
        VStack {
            List {
                Section(header: Text("My Drafts")) {
                    ForEach(makeCrosswordModels, id: \.lastAccessed) {
                        MakeCrosswordListRow(
                            makeCrosswordModel: $0,
                            chosenMakeCrosswordModel: $makeCrosswordModel,
                            showArchive: $showArchive
                        )
                    }
                    .onDelete(perform: deleteMakeCrossword)
                    .id(refreshID)
                    .onReceive(self.didSave) { _ in   // the listener
                        self.refreshID = UUID()
                        print("generated a new UUID")
                    }
                }
            }
        }
    }
    
    func deleteMakeCrossword(at offsets: IndexSet) {
      // 1
      offsets.forEach { index in
        // 2
        let makeCrosswordModel = self.makeCrosswordModels[index]
        // 3
        self.managedObjectContext.delete(makeCrosswordModel)
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
