//
//  MakeXWordStartView.swift
//  word_o_crossv2
//
//  Created by Austin Kang on 11/16/22.
//

import SwiftUI

struct MakeXWordStartView: View {
    @State var title = ""
    @State var date = Date()
    @State var cols = 5
    @State var isShowingMakeXWordView = false
    var makeCrossword: Binding<MakeCrossword> { Binding<MakeCrossword>(
        get: { MakeCrossword(title: title, author: "", cols: cols, grid: [String](repeating: "", count: cols*cols))},
        set: { $0 }
        )
    }
    
    var body: some View {
        VStack {
            Spacer()
            Text("New Crossword").font(.title)
            Spacer()
            Text("Title:")
            TextField("Title", text: $title)
                .multilineTextAlignment(.center)
            Text("Width:")
            TextField("Width", value: $cols, format: .number)
                .multilineTextAlignment(.center)
            Spacer()
            NavigationLink(destination: MakeXWordView(makeCrossword: makeCrossword.wrappedValue), isActive: $isShowingMakeXWordView) {
                Text("Start")
            }
            Spacer()
        }
    }
}

struct MakeXWordStartView_Previews: PreviewProvider {
    static var previews: some View {
        MakeXWordStartView()
    }
}
