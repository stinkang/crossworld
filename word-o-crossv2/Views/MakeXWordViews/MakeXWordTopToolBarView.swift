//
//  MakeXWordTopTooBarView.swift
//  word_o_crossv2
//
//  Created by Austin Kang on 11/9/22.
//

import SwiftUI

struct MakeXWordTopToolBarView: View {
    
    @EnvironmentObject var viewModel: MakeXWordViewModel
    
    var body: some View {
        HStack {
            Button(action: {
                viewModel.editGridMode = !viewModel.editGridMode
            }) {
                Image(systemName: viewModel.editGridMode ? "rectangle.and.pencil.and.ellipsis" : "square.grid.3x3.square")
                    .frame(maxWidth: .infinity, maxHeight: 20)
            }
            Button(action: {
                print("button pressed")
            }) {
                Image(systemName: "plus.bubble")
                    .frame(maxWidth: .infinity, maxHeight: 20)
            }
            Button(action: {
                print("button pressed")
            }) {
                Image(systemName: "pencil")
                    .frame(maxWidth: .infinity, maxHeight: 20)
            }
            Button(action: {
                print("button pressed")
            }) {
                Image(systemName: "info")
                    .frame(maxWidth: .infinity, maxHeight: 20)
            }
        }.foregroundColor(.white)
    }
}

struct MakeXWordTopTooBarView_Previews: PreviewProvider {
    static var previews: some View {
        MakeXWordTopToolBarView()
    }
}
