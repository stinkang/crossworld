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
    
    var body: some View {
        VStack {
            TextField("Title", text: $title)
                .multilineTextAlignment(.center)
            Button("Save", action: {
                viewModel.title = title
            })
        }
    }
}

//struct MakeXWordInfoView_Previews: PreviewProvider {
//    static var previews: some View {
//        MakeXWordInfoView(viewModel: .constant(MakeXWordViewModel()))
//    }
//}
