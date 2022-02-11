//
//  CrosswordBlackBox.swift
//  word-o-crossv2
//
//  Created by Austin Kang on 1/20/22.
//

import Foundation
import SwiftUI

struct CrosswordSquareBlackBox: View {
    let width: CGFloat
    var body: some View {
        Rectangle()
            .frame(width: width, height: width, alignment: Alignment.center)
            .foregroundColor(Color.black)
            .disabled(true)
    }
}
