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
        viewModel.getCrosswords() { crosswordIds in
            var crosswordListItems:[CrosswordListItem] = []
            for (index, crossword) in crosswordIds.enumerated() {
                crosswordListItems.append(CrosswordListItem(id: index, name: "Crossword " + String(index), boardId: crossword))
            }
            viewModel.crosswords = crosswordListItems
        }
    }

    var body: some View {
        VStack{
            Button(action: {
                getCrosswords()
            }) {
                Text("Refresh Crosswords")
            }
            List(viewModel.crosswords) { crossword in
    //            NavigationLink {
    //
    //            }
                Text(crossword.name)
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
