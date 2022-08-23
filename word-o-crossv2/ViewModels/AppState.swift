//
//  AppState.swift
//  word_o_crossv2
//
//  Created by Austin Kang on 8/15/22.
//

import Foundation
import SwiftUI
import UIKit

class AppState: ObservableObject {
    @Published var isActive = true

    private var observers = [NSObjectProtocol]()

    init() {
        observers.append(
            NotificationCenter.default.addObserver(forName: UIApplication.didBecomeActiveNotification, object: nil, queue: .main) { _ in
                self.isActive = true
            }
        )
        observers.append(
            NotificationCenter.default.addObserver(forName: UIApplication.willResignActiveNotification, object: nil, queue: .main) { _ in
                self.isActive = false
            }
        )
    }
    
    deinit {
        observers.forEach(NotificationCenter.default.removeObserver)
    }
}
