//
//  TimerTimeView.swift
//  word_o_crossv2
//
//  Created by Austin Kang on 3/21/22.
//

import SwiftUI

struct TimerTimeView: View {
    var secondsElapsed: Int64
    var numberFormatter: NumberFormatter
    
    init(secondsElapsed: Int64) {
        self.secondsElapsed = secondsElapsed
        self.numberFormatter  = NumberFormatter()
        numberFormatter.minimumIntegerDigits = 2
    }
    var body: some View {
        let hours = (secondsElapsed % 86400) / 3600
        let minutes = (secondsElapsed % 3600) / 60
        let seconds = (secondsElapsed % 3600) % 60
        Text("\(numberFormatter.string(from: NSNumber(value: hours))!):\(numberFormatter.string(from: NSNumber(value: minutes))!):\(numberFormatter.string(from: NSNumber(value: seconds))!)")
    }
}
//
//struct TimerTimeView_Previews: PreviewProvider {
//    static var previews: some View {
//        TimerTimeView()
//    }
//}
