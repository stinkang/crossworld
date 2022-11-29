//
//  BaseXWordToolbarButtonView.swift
//  word_o_crossv2
//
//  Created by Austin Kang on 11/24/22.
//

import SwiftUI

struct BaseXWordToolbarButtonView: View {
    let action: () -> Void
    let imageName: String
    let angle: Double
    var body: some View {
        Button(action: {
            action()
        }) {
            Image(systemName: imageName)
                .rotationEffect(.degrees(angle))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(RoundedRectangle(cornerRadius: 4).stroke())
                .foregroundColor(.emptyGray)
        }
    }
}

//struct BaseXWordToolbarButtonView_Previews: PreviewProvider {
//    static var previews: some View {
//        BaseXWordToolbarButtonView()
//    }
//}
