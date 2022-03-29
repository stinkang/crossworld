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
    @State private var showArchive = false
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
    let crosswordService = CrosswordService()

    var body: some View {
        VStack {
            LeaderboardListView(crossword: $crossword)
            Spacer()
            HStack {
                if (crossword.title == "") {
                    Text("Select a crossword to begin")
                        .foregroundColor(.emptyGray)
                        .italic()
                        .padding()
                } else {
                    VStack(alignment: .leading) {
                        Text(crossword.title)
                            .padding(.leading, 15)
                            .padding(.bottom, 1)
                        HStack {
                            TimerTimeView(secondsElapsed: crossword.secondsElapsed)
                                .padding(.leading, 15)
                                .foregroundColor(crossword.solved ? .green : .yellow)
                            if (crossword.solved) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                                    .frame(width: 12, height: 12)
                            } else {
                                if (crossword.percentageComplete == nil || crossword.percentageComplete == 0.0) {
                                    Circle()
                                        .stroke(Color.emptyGray ,style: StrokeStyle(lineWidth: 2, lineCap: .butt))
                                        .frame(width: 12, height: 12)
                                } else {
                                    Circle()
                                        .trim(from: 0.0, to: CGFloat(crossword.percentageComplete!))
                                        .rotation(.degrees(270))
                                        .stroke(Color.green ,style: StrokeStyle(lineWidth: 2, lineCap: .butt))
                                        .frame(width: 12, height: 12)
                                }
                            }
                        }
                    }
                }
                Spacer()
                if (connectedStatus && opponent.displayName != "") {
                    HStack {
                        Image(uiImage: viewModel.playerPhoto)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.green, lineWidth: 2))
                    }
                }
                NavigationLink(destination:
                    XWordView(
                        crossword: crossword,
                        crosswordBinding: $crossword,
                        xWordMatch: xWordMatch,
                        shouldSendGoBackToLobbyMessage: $shouldSendGoBackToLobbyMessage,
                        shouldSendCrosswordData: $shouldSendCrosswordData,
                        opponent: $opponent,
                        connectedStatus: $connectedStatus,
                        isShowingXwordView: $isShowingXWordView,
                        showArchive: $showArchive
                    ), isActive: $isShowingXWordView) {
                        Text("Start Crossword")
                            .foregroundColor(.white)
                            .frame(width: 150, height: 40)
                            .background(crossword.title == "" ? Color.gray : Color.green)
                            .cornerRadius(15)
                            .padding(.trailing, 10)
                            .padding(.bottom, 10)
                }
                .disabled(crossword.title == "")
            }
        }
            .ignoresSafeArea(.keyboard, edges: .bottom)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        showDocumentPicker = true
                    }) {
                        Image(systemName: "folder")
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        showArchive = true
                    }) {
                        Image(systemName: "square.3.layers.3d.down.right")
                    }
                }
                ToolbarItem(placement: .principal) {
                    Text("CrossWorld!").font(.title)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        print("info tapped")
                    }) {
                        Image(systemName: "info.circle")
                    }
                }
//                ToolbarItem(placement: .automatic) {
//                    Button(action: {
//                        print("icon clicked")
//                    }) {
//                        if (connectedStatus && opponent.displayName != "") {
//                            HStack {
//                                Image(uiImage: viewModel.playerPhoto)
//                                    .clipShape(Circle())
//                                    .overlay(Circle().stroke(Color.green, lineWidth: 2))
//                            }
//                        }
//                    }
//                }
                
                // TODO: Fix up multiplayer before uncommenting this!!
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
                            crossword = Crossword()
                            gcButtonPressed = true
                        }) {
                            Image(systemName: "person.crop.circle.badge.plus")
                        }
                        .disabled(true)
                    }
                }
            }
            .task {
                await viewModel.loadPhoto(player: opponent)
            }
            .sheet(isPresented: self.$showDocumentPicker) {
                CrosswordDocumentPicker(crossword: $crossword)
            }
            .sheet(isPresented: self.$showArchive) {
                CrosswordListView(
                    crossword: $crossword,
                    showArchive: $showArchive,
                    shouldSendCrosswordData: $shouldSendCrosswordData
                )
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
            //.frame(width: UIScreen.screenWidth, height: UIScreen.screenWidth)
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

//struct LobbyView_Previews: PreviewProvider {
//    static var previews: some View {
//        LobbyView(xWordMatch: GKMatch())
//    }
//}
