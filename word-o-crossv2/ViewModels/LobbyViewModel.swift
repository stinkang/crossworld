//
//  LobbyViewModel.swift
//  word_o_crossv2
//
//  Created by Austin Kang on 3/2/22.
//

import Foundation
import SwiftUI
import GameKit

@MainActor
class LobbyViewModel: ObservableObject {
    @Published var playerPhoto = UIImage()

    func loadPhoto(player: GKPlayer) async {
        do {
            let image = try await player.loadPhoto(for: .small).resize(targetSize: CGSize(width: 23, height: 23))
            playerPhoto = image
        } catch {
            print(error.localizedDescription)
        }
    }
}

extension UIImage {

    func resize(targetSize: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size:targetSize).image { _ in
            self.draw(in: CGRect(origin: .zero, size: targetSize))
        }
    }
}
