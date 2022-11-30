//
//  ProfileView.swift
//  word_o_crossv2
//
//  Created by Austin Kang on 10/14/22.
//

import SwiftUI

struct ProfileView: View {
    
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
    
    @ObservedObject var viewModel: LobbyViewModel
    @State var isShowingMakeXWordView = false
    @State var isShowingMakeNewXWordView = false
    @State var isShowingSettingsView = false
    @State private var showDrafts = false
    @State private var showArchive = false
    @State var makeCrosswordModel = MakeCrosswordModel()

    @FetchRequest(
      entity: MakeCrosswordModel.entity(),
      sortDescriptors: [
        NSSortDescriptor(keyPath: \MakeCrosswordModel.date, ascending: false)
      ]
    ) var makeCrosswordModels: FetchedResults<MakeCrosswordModel>
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    var didSave = NotificationCenter.default.publisher(for: .NSManagedObjectContextDidSave)
    @State var refreshID = UUID()
    var userService = UserService()
    
    var body: some View {
        VStack {
            List {
                Section(header: Text("My Drafts")) {
                    ForEach(makeCrosswordModels, id: \.lastAccessed) {
                      MakeCrosswordListRow(
                        makeCrosswordModel: $0,
                        chosenMakeCrosswordModel: $makeCrosswordModel,
                        showArchive: $showArchive)
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
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: MakeXWordStartView(), isActive: $isShowingMakeNewXWordView) {
                    HStack {
                        Text("New")
                        Image(systemName: "square.and.pencil")
                    }
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: ProfileSettingsView(viewModel: viewModel), isActive: $isShowingSettingsView) {
                    Image(systemName: "gearshape")
                }
            }
        }
//        .onChange(of: makeCrosswordModel, perform: { _ in
//            makeCrossword = MakeCrossword(makeCrosswordModel: makeCrosswordModel)
//        })
        .sheet(isPresented: self.$showDrafts) {
            MakeCrosswordListView(
                makeCrosswordModel: $makeCrosswordModel,
                showArchive: $showDrafts
            )
        }
    }
}
//
//struct ProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfileView()
//    }
//}
