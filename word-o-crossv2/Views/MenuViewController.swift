//
//  MenuViewController.swift
//  word_o_crossv2
//
//  Created by Austin Kang on 2/23/22.
//

import UIKit
import GameKit
import SwiftUI

struct MenuView: UIViewControllerRepresentable {
    @Binding var isShowingXWordView: Bool
    @Binding var xWordMatch: GKMatch
    @Binding var crossword: Crossword
    @Binding var buttonPressed: Bool
    @Binding var gcAuthenticated: Bool
    func makeUIViewController(context: Context) -> MenuViewController {
        return MenuViewController(isShowingXWordView: $isShowingXWordView, xWordMatch: $xWordMatch, crossword: $crossword, gcAuthenticated: $gcAuthenticated)
    }

    func updateUIViewController(_ uiViewController: MenuViewController, context: Context) {
        if (buttonPressed) {
            uiViewController.buttonMultiplayerPressed()
            buttonPressed = false
        }
    }
}

class MenuViewController: UIViewController {
    @Binding var isShowingXWordView: Bool
    @Binding var xWordMatch: GKMatch
    @Binding var crossword: Crossword
    @Binding var gcAuthenticated: Bool

    init(isShowingXWordView: Binding<Bool>, xWordMatch: Binding<GKMatch>, crossword: Binding<Crossword>, gcAuthenticated: Binding<Bool>) {
        self._isShowingXWordView = isShowingXWordView
        self._xWordMatch = xWordMatch
        self._crossword = crossword
        self._gcAuthenticated = gcAuthenticated
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var gameCenterHelper: GameCenterHelper!
    var buttonMultiplayer: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        buttonMultiplayer?.isEnabled = crossword.title != ""
//        buttonMultiplayer = UIButton(frame: CGRect(x: 0, y: UIScreen.screenHeight/2, width: UIScreen.screenWidth, height: 64))
//        buttonMultiplayer!.setImage(UIImage(systemName: "doc.circle.fill", for: <#UIControl.State#>))
//        buttonMultiplayer!.setTitleColor(.link, for: .normal)
//
//        buttonMultiplayer!.isEnabled = false
//        buttonMultiplayer!.layer.cornerRadius = 10
//        buttonMultiplayer!.addTarget(self, action: #selector(buttonMultiplayerPressed), for: .touchUpInside)
//        self.view.addSubview(buttonMultiplayer!)

        gameCenterHelper = GameCenterHelper()
        gameCenterHelper.delegate = self
        gameCenterHelper.authenticatePlayer()
    }

    func buttonMultiplayerPressed() {
        gameCenterHelper.presentMatchmaker()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let vc = segue.destination as? GameViewController,
              let match = sender as? GKMatch else { return }

        vc.match = match
    }
}

extension MenuViewController: GameCenterHelperDelegate {
    func didChangeAuthStatus(isAuthenticated: Bool) {
       gcAuthenticated = isAuthenticated
    }
    
    func presentGameCenterAuth(viewController: UIViewController?) {
        guard let vc = viewController else {return}
        self.present(vc, animated: true)
    }
    
    func presentMatchmaking(viewController: UIViewController?) {
        guard let vc = viewController else {return}
        self.present(vc, animated: true)
    }
    
    func presentGame(match: GKMatch) {
        xWordMatch = match
        isShowingXWordView = true
        //performSegue(withIdentifier: "showGame", sender: match)
    }
}
