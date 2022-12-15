//
//  MakeXWordView.swift
//  word_o_crossv2
//
//  Created by Austin Kang on 10/18/22.
//

import SwiftUI

struct MakeXWordView: View {
    @StateObject var viewModel: MakeXWordViewModel
    @StateObject var appState: AppState
    @Environment(\.managedObjectContext) var managedObjectContext
    @State var publishXWordSheetShowing = false
    
    var boxWidth: CGFloat { return (UIScreen.screenWidth - 5) / CGFloat(viewModel.cols) }

    init(makeCrossword: MakeCrosswordCodable) {
        _viewModel = StateObject(wrappedValue: MakeXWordViewModel(makeCrossword: makeCrossword))
        _appState = StateObject(wrappedValue: AppState())
    }
    init(makeCrosswordModel: MakeCrosswordModel) {
        _viewModel = StateObject(wrappedValue: MakeXWordViewModel(makeCrosswordModel: makeCrosswordModel))
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
                    Toggle("Edit grid mode " + (viewModel.editGridModeOn ? "on" : "off"), isOn: $viewModel.editGridModeOn)
                        .onChange(of: viewModel.editGridModeOn) { value in
                            viewModel.changeEditGridMode(to: !viewModel.editGridMode)
                        }
                        .toggleStyle(.switch)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { publishXWordSheetShowing = true }) {
                        Image(systemName: "square.and.arrow.up.fill").foregroundColor(.green)
                    }
                }
            }
            MakeXWordPermanentKeyboard(text: viewModel.selectedInputBinding)
        }
        .sheet(isPresented: $publishXWordSheetShowing) {
            PublishXWordView(publishXWordSheetShowing: $publishXWordSheetShowing)
        }
        .environmentObject(viewModel)
        .onChange(of: appState.isActive, perform: { _ in
            viewModel.saveCrossword(managedObjectContext: managedObjectContext)
        })
        .onWillDisappear {
            viewModel.saveCrossword(managedObjectContext: managedObjectContext)
        }
    }
}
