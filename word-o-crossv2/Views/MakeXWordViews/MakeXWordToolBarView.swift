//
//  MakeXWordToolBarView.swift
//  word_o_crossv2
//
//  Created by Austin Kang on 11/8/22.
//

import SwiftUI

struct MakeXWordToolBarView: View {
    
    @EnvironmentObject var viewModel: MakeXWordViewModel
    var boxWidth: CGFloat
    
    var body: some View {
        HStack {
            Spacer()
            VStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 4).stroke().foregroundColor(.emptyGray)
                        .frame(maxHeight: .infinity)
                        .frame(width: UIScreen.screenWidth / 1.5)
                    HStack(alignment: .center) {
                        Text("").foregroundColor(.squareBackground2)
                    }
                }
            }
            
            Spacer()
        }
        .frame(width: UIScreen.screenWidth)
    }
}

struct MakeXWordToolBarView_Previews: PreviewProvider {
    static var previews: some View {
        MakeXWordToolBarView(boxWidth: 25)
    }
}
