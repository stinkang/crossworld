//
//  CrosswordListView.swift
//  word_o_crossv2
//
//  Created by Austin Kang on 2/15/22.
//

import SwiftUI

struct CrosswordListView: View {
    @StateObject var viewModel: CrosswordListViewModel = CrosswordListViewModel()
    
    func getCrosswords() -> Void {
        viewModel.getCrosswords() { crosswords in
            viewModel.crosswords = crosswords
        }
    }

    var body: some View {
        VStack{
            Button(action: {
                getCrosswords()
            }) {
                Text("Refresh Crosswords")
            }
            List(viewModel.crosswords.indices, id: \.self) { index in
                let crossword = viewModel.crosswords[index]
                NavigationLink(destination: XWordView(crossword: crossword)) {
                    Text(crossword.title ?? "Crossword")
                }
            }
        }.onAppear(perform: {
            getCrosswords()
        })
    }
}

struct CrosswordListView_Previews: PreviewProvider {
    static var previews: some View {
        CrosswordListView()
    }
}
