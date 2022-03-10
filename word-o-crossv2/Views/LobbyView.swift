//
//  LobbyView.swift
//  word-o-crossv2
//
//  Created by Austin Kang on 11/23/21.
//

import SwiftUI
import GameKit
import CoreData

struct LobbyView: View {
    @State var crossword = Crossword()
    @State private var showDocumentPicker = false
    @State var isShowingXWordView = false
    @State var xWordMatch: GKMatch = GKMatch()
    @State var gcButtonPressed: Bool = false
    @State var gcAuthenticated: Bool = false
    @State var shouldSendGoBackToLobbyMessage = false
    @State var shouldSendCrosswordData = false
    @State var opponent = GKPlayer()
    @State var connectedStatus = false
    @State var playerPhoto = UIImage()
    @StateObject var viewModel = LobbyViewModel()
    @Environment(\.managedObjectContext) var managedObjectContext
    var xWordViewModel: XWordViewModel = XWordViewModel(crossword: Crossword())

    var body: some View {
        VStack {
            VStack {
                Text("CrossWorld!").font(.largeTitle)
                NavigationLink(destination:
                    XWordView(
                        crossword: crossword,
                        crosswordBinding: $crossword,
                        xWordMatch: xWordMatch,
                        shouldSendGoBackToLobbyMessage: $shouldSendGoBackToLobbyMessage,
                        shouldSendCrosswordData: $shouldSendCrosswordData,
                        opponent: $opponent,
                        connectedStatus: $connectedStatus
                    ), isActive: $isShowingXWordView) {
                    Text(crossword.title).padding()
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        showDocumentPicker = true
                    }) {
                        Image(systemName: "folder")
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    NavigationLink(destination:
                        CrosswordListView(
                            xWordMatch: xWordMatch,
                            shouldSendGoBackToLobbyMessage: $shouldSendGoBackToLobbyMessage,
                            shouldSendCrosswordData: $shouldSendCrosswordData,
                            opponent: $opponent,
                            connectedStatus: $connectedStatus
                        )
                    ) {
                        Image(systemName: "square.3.layers.3d.down.right")
                    }
                }
                ToolbarItem(placement: .automatic) {
                    Button(action: {
                        print("icon clicked")
                    }) {
                        if (connectedStatus && opponent.displayName != "") {
                            HStack {
                                Image(uiImage: viewModel.playerPhoto)
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(Color.green, lineWidth: 2))
//                                Circle()
//                                    .fill()
//                                    .frame(width: 8, height: 8, alignment: .center)
//                                    .foregroundColor(.green)
                            }
                        }
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    ZStack{
                        MenuView(
                            isShowingXWordView: $isShowingXWordView,
                            shouldSendCrosswordData: $shouldSendCrosswordData,
                            xWordMatch: $xWordMatch,
                            crossword: $crossword,
                            buttonPressed: $gcButtonPressed,
                            gcAuthenticated: $gcAuthenticated,
                            connectedStatus: $connectedStatus,
                            opponent: $opponent
                        )
                        Button(action: {
                            gcButtonPressed = true
                        }) {
                            Image(systemName: "person.crop.circle.badge.plus")
                        }
                        .disabled(crossword.title != "")
                    }
                }
            }
            .task {
                await viewModel.loadPhoto(player: opponent)
            }
            .sheet(isPresented: self.$showDocumentPicker) {
                CrosswordDocumentPicker(crossword: $crossword)
            }
            .onAppear(perform: {
                shouldSendGoBackToLobbyMessage = true
                checkForExistingCrosswordAndUpdate()
            })
            .onChange(of: crossword.title, perform: { _ in
                if crossword.title == "" {
                    shouldSendCrosswordData = false
                } else {
                    checkForExistingCrosswordAndUpdate()
                    shouldSendCrosswordData = true
                }
            })
            .frame(width: UIScreen.screenWidth, height: UIScreen.screenWidth)
            .position(x: UIScreen.screenWidth / 2, y: (UIScreen.screenWidth) / 2)
        }
    }
    
    func checkForExistingCrosswordAndUpdate() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CrosswordModel")
        fetchRequest.predicate = NSPredicate(format: "title = %@", crossword.title)
        var newCrossword = crossword
        if (crossword.title != "") {
            do {
                if let fetchResults = try managedObjectContext.fetch(fetchRequest) as? [NSManagedObject] {
                    if fetchResults.count != 0 {
                        newCrossword = Crossword(crosswordModel: fetchResults[0] as! CrosswordModel)
                    }
                }
            } catch {
                print("Fetch Failed: \(error)")
            }
            self.crossword = newCrossword
        }
    }
}

struct LobbyView_Previews: PreviewProvider {
    static var previews: some View {
        LobbyView(xWordMatch: GKMatch())
    }
}
