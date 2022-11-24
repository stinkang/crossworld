//
//  MakeXWordInfoView.swift
//  word_o_crossv2
//
//  Created by Austin Kang on 11/9/22.
//

import SwiftUI

struct MakeXWordInfoView: View {
    @ObservedObject var viewModel: MakeXWordViewModel
    @State var title = ""
    @State var author = ""
    @State var date = Date()
    
    var body: some View {
        VStack {
            TextField("Title", text: $title)
            TextField("Author", text: $author)
            Button("Save", action: {
            })
        }
    }
}

//struct MakeXWordInfoView_Previews: PreviewProvider {
//    static var previews: some View {
//        MakeXWordInfoView(viewModel: .constant(MakeXWordViewModel()))
//    }
//}
