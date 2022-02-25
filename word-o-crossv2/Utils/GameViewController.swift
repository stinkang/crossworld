//
//  GameViewController.swift
//  GameCenterMultiplayer
//
//  Created by Pedro Contine on 29/06/20.
//

import UIKit
import GameKit
import SwiftUI

struct GameView: UIViewControllerRepresentable {
    var xWordMatch: GKMatch
    @EnvironmentObject var xWordViewModel: XWordViewModel
    func makeUIViewController(context: Context) -> GameViewController {
        return GameViewController(xWordViewModel: xWordViewModel, match: xWordMatch)
    }

    func updateUIViewController(_ uiViewController: GameViewController, context: Context) {
        if (xWordViewModel.shouldSendMessage) {
                let typedTextData = MoveData(
                    text: xWordViewModel.typedText,
                    previousIndex: xWordViewModel.previousFocusedSquareIndex,
                    currentIndex: xWordViewModel.focusedSquareIndex,
                    acrossFocused: xWordViewModel.acrossFocused,
                    wasTappedOn: xWordViewModel.textState == .tappedOn
                )
                uiViewController.sendData(data: typedTextData)
            xWordViewModel.changeShouldSendMessage(to: false)
        }
    }
}

class GameViewController: UIViewController {
    @ObservedObject var xWordViewModel: XWordViewModel
    var match: GKMatch
    
    init(xWordViewModel: XWordViewModel, match: GKMatch) {
        self.xWordViewModel = xWordViewModel
        self.match = match
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

//    @IBOutlet weak var player1: UIImageView!
//    @IBOutlet weak var progressPlayer1: UIProgressView!
//    @IBOutlet weak var player2: UIImageView!
//    @IBOutlet weak var progressPlayer2: UIProgressView!
//    @IBOutlet weak var buttonAttack: UIButton!
//    @IBOutlet weak var labelTime: UILabel!
    private var timer: Timer!

    private var gameModel: MoveData! {
        didSet {
            updateUI()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        gameModel = MoveData(text: "", previousIndex: 0, currentIndex: 0, acrossFocused: true, wasTappedOn: false)
        match.delegate = self

        //Mirror player 2 images
        //player2.transform = CGAffineTransform(scaleX: -1, y: 1)

        //savePlayers()

//        if getLocalPlayerType() == .one, timer == nil {
//            self.initTimer()
//        }
    }

//    private func initTimer() {
//        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
//            let player = self.getLocalPlayerType()
//            if player == .one, self.gameModel.time >= 1 {
//                self.gameModel.time -= 1
//                self.sendData()
//            }
//        })
//    }
//
//    private func savePlayers() {
//        guard let player2Name = match?.players.first?.displayName else { return }
//        let player1 = Player(displayName: GKLocalPlayer.local.displayName)
//        let player2 = Player(displayName: player2Name)
//
//        gameModel.players = [player1, player2]
//
//        gameModel.players.sort { (player1, player2) -> Bool in
//            player1.displayName < player2.displayName
//        }
//
//        sendData()
//    }

//    private func getLocalPlayerType() -> PlayerType {
//        if gameModel.players.first?.displayName == GKLocalPlayer.local.displayName {
//            return .one
//        } else {
//            return .two
//        }
//    }

    private func updateUI() {
        xWordViewModel.changeOtherPlayersMove(to: gameModel)
    }

//    @IBAction func buttonAttackPressed() {
//        let localPlayer = getLocalPlayerType()
//
//        //Change status to attacking
//        gameModel.players[localPlayer.index()].status = .attack
//        gameModel.players[localPlayer.enemyIndex()].status = .hit
//        gameModel.players[localPlayer.enemyIndex()].life -= 10
//        sendData()
//
//        //Reset status after 1 second
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            self.gameModel.players[localPlayer.index()].status = .idle
//            self.gameModel.players[localPlayer.enemyIndex()].status = .idle
//            self.sendData()
//        }
//    }

    func sendData(data: MoveData) {
        //guard let match = match else { return }

        do {
            guard let dataToSend = data.encode() else { return }
            try match.sendData(toAllPlayers: dataToSend, with: .reliable)
        } catch {
            print("Send data failed")
        }
    }
}

extension GameViewController: GKMatchDelegate {
    func match(_ match: GKMatch, didReceive data: Data, fromRemotePlayer player: GKPlayer) {
        guard let model = MoveData.decode(data: data) else { return }
        gameModel = model
    }
}
