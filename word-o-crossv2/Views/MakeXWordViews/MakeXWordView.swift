//
//  MakeXWordView.swift
//  word_o_crossv2
//
//  Created by Austin Kang on 10/18/22.
//

import SwiftUI

struct MakeXWordView: View {
    @StateObject var viewModel: MakeXWordViewModel
    @State var isShowingInfoView = false
    @StateObject var appState: AppState
    @Environment(\.managedObjectContext) var managedObjectContext
    let userService = UserService()
    let persistenceController = PersistenceController.shared
    
    var boxWidth: CGFloat {
        return (UIScreen.screenWidth-5)/CGFloat(viewModel.cols)
    }
    
    var selectedInputBinding: Binding<String> {
        Binding<String>(
            get: {
                if viewModel.editClueTapped {
                    if viewModel.acrossFocused {
                        return viewModel.indexToAcrossCluesMap[viewModel.squareModels[viewModel.focusedIndex].acrossClueIndex]!
                    } else {
                        return viewModel.indexToDownCluesMap[viewModel.squareModels[viewModel.focusedIndex].downClueIndex]!
                    }
                } else {
                    return viewModel.squareModels[viewModel.focusedIndex].currentText
                }
            },
            set: {
                if viewModel.editClueTapped {
                    if viewModel.acrossFocused {
                        viewModel.indexToAcrossCluesMap[viewModel.squareModels[viewModel.focusedIndex].acrossClueIndex] = $0
                    } else {
                        viewModel.indexToDownCluesMap[viewModel.squareModels[viewModel.focusedIndex].downClueIndex] = $0
                    }
                } else {
                    viewModel.squareModels[viewModel.focusedIndex].currentText = $0
                }
            }
        )
    }

    init(makeCrossword: MakeCrossword) {
        _viewModel = StateObject(wrappedValue: MakeXWordViewModel(makeCrossword: makeCrossword))
        _appState = StateObject(wrappedValue: AppState())
    }

    var body: some View {
        ZStack {
            VStack {
                VStack(spacing: 0) {
                    ForEach(0..<viewModel.cols, id: \.self) { col in
                        HStack(spacing: 0) {
                            ForEach(0..<viewModel.cols, id: \.self) { row in
                                let index = col * viewModel.cols + row
                                MakeXWordSquareView(      
                                    boxWidth: boxWidth,
                                    index: index,
                                    makeXWordViewModel: viewModel
                                )
                            }
                        }
                    }
                }
                Spacer()
                BaseXWordToolbarView(boxWidth: boxWidth)
                Spacer()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        viewModel.changeEditGridMode(to: !viewModel.editGridMode)
                    }) {
                        Image(systemName: viewModel.editGridMode ? "square.grid.3x3.square" : "rectangle.and.pencil.and.ellipsis")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: MakeXWordInfoView(viewModel: viewModel), isActive: $isShowingInfoView) {
                        Image(systemName: "info")
                    }
                }
            }
            MakeXWordPermanentKeyboard(text: selectedInputBinding)
        }
        .environmentObject(viewModel)
        .onChange(of: appState.isActive, perform: { _ in
            saveCrossword()
        })
        .onWillDisappear {
            saveCrossword()
        }
    }
    
    func saveCrossword() {
        let newCrossword = MakeCrosswordModel(context: managedObjectContext)
        newCrossword.cols = Int32(viewModel.cols)
        newCrossword.author = userService.getCurrentUser()?.displayName
        newCrossword.date = Date()
        newCrossword.lastAccessed = Date()
        newCrossword.notes = viewModel.notes
        newCrossword.title = viewModel.title
        newCrossword.grid = viewModel.getGrid()
        persistenceController.save()
    }
}

//struct MakeXWordView_Previews: PreviewProvider {
//    static var previews: some View {
//        MakeXWordView(cols: 3)
//    }
//}
