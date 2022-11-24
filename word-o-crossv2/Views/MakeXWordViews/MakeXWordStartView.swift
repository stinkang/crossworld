//
//  MakeXWordStartView.swift
//  word_o_crossv2
//
//  Created by Austin Kang on 11/16/22.
//

import SwiftUI

struct MakeXWordStartView: View {
    @State var title = ""
    @State var author = ""
    @State var date = Date()
    @State var cols = 5
    @State var isShowingMakeXWordView = false
    
    var body: some View {
        VStack {
            TextField("Title", text: $title)
            TextField("Author", text: $author)
            TextField("Width", value: $cols, format: .number)
            NavigationLink(destination: MakeXWordView(cols: cols), isActive: $isShowingMakeXWordView) {
                Text("Start")
            }
        }
    }
}

struct MakeXWordStartView_Previews: PreviewProvider {
    static var previews: some View {
        MakeXWordStartView()
    }
}
