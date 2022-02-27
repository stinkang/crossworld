//
//  GameViewController.swift
//  GameCenterMultiplayer
//
//  Created by Austin Kang on 25/02/22.
//

import UIKit
import GameKit
import SwiftUI

struct GameView: UIViewControllerRepresentable {
    @Binding var xWordMatch: GKMatch
    //@Binding var crossword: Crossword
    //@Binding var shouldSendCrossword: Bool
    //@Binding var shouldSendGoBackToLobby: Bool
    @EnvironmentObject var xWordViewModel: XWordViewModel
    func makeUIViewController(context: Context) -> GameViewController {
        return GameViewController(xWordViewModel: xWordViewModel, match: $xWordMatch)
    }

    func updateUIViewController(_ uiViewController: GameViewController, context: Context) {
        if (xWordViewModel.shouldSendMessage /*|| shouldSendGoBackToLobby*/) {
            let typedTextData = MoveData(
                text: xWordViewModel.typedText,
                previousIndex: xWordViewModel.previousFocusedSquareIndex,
                currentIndex: xWordViewModel.focusedSquareIndex,
                acrossFocused: xWordViewModel.acrossFocused,
                wasTappedOn: xWordViewModel.textState == .tappedOn,
                wentBackToLobby: false
            )
            uiViewController.sendData(data: typedTextData)
            xWordViewModel.changeShouldSendMessage(to: false)
        }
    }
}

class GameViewController: UIViewController {
    @ObservedObject var xWordViewModel: XWordViewModel
    //@Binding var crossword: Crossword
    @Binding var match: GKMatch
    //@Binding var showLobbyView: Bool
    
    init(xWordViewModel: XWordViewModel, match: Binding<GKMatch>/*, showLobbyView: Binding<Bool>*//*, crossword: Binding<Crossword>*/) {
        self.xWordViewModel = xWordViewModel
        self._match = match
        //self._showLobbyView = showLobbyView
        //self._crossword = crossword
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var timer: Timer!

    private var gameModel: MoveData! {
        didSet {
            updateUI()
        }
    }
    
    private var crosswordModel: Crossword! {
        didSet {
            updateCrossword()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        gameModel = MoveData(text: "", previousIndex: 0, currentIndex: 0, acrossFocused: true, wasTappedOn: false, wentBackToLobby: false)
        crosswordModel = Crossword()
        match.delegate = self
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

    func sendData(data: MoveData) {
        //guard let match = match else { return }
        do {
            guard let dataToSend = data.encode() else { return }
            try match.sendData(toAllPlayers: dataToSend, with: .reliable)
        } catch {
            print("Send data failed")
        }
    }
    
    private func updateCrossword() {
        // TODO: should dosomething when crossword is a binding
        //crossword = crosswordModel
    }
    
//    func sendData(data: Crossword) {
//        //guard let match = match else { return }
//        do {
//            let dataToSend = Data()
//            //guard /*data.encode()*/ else { return }
//            try match.sendData(toAllPlayers: dataToSend, with: .reliable)
//        } catch let error {
//            print("crossword send data failed with error: \(error)")
//        }
//    }
//
//    func sendData(data: Bool) {
//        //guard let match = match else { return }
//        do {
//            guard let dataToSend = try? JSONEncoder().encode(data) else { return }
//            try match.sendData(toAllPlayers: dataToSend, with: .reliable)
//        } catch {
//            print("Send data failed")
//        }
//    }
}

extension GameViewController: GKMatchDelegate {
    func match(_ match: GKMatch, didReceive data: Data, fromRemotePlayer player: GKPlayer) {
        let model = MoveData.decode(data: data)
        if (model != nil) {
            gameModel = model
            return
        }
        let crosswordDecodedModel = Crossword.decode(data: data)
        if (crosswordDecodedModel != nil) {
            crosswordModel = crosswordDecodedModel
        }
//        let shouldGoBackToLobby = try? JSONDecoder().decode(Bool.self, from: data)
//        if (shouldGoBackToLobby != nil) {
//            showLobbyView = shouldGoBackToLobby!
//        }
    }
}
