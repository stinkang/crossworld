////
////  CrosswordGettingGameViewController.swift
////
////  Created by Austin Kang on 26/02/22
////
//
//import UIKit
//import GameKit
//import SwiftUI
//
//struct CrosswordGettingGameView: UIViewControllerRepresentable {
//    @Binding var xWordMatch: GKMatch
//    @Binding var crossword: Crossword
//
//    @Binding var shouldResetDelegate: Bool
//    func makeUIViewController(context: Context) -> CrosswordGettingGameViewController {
//        return CrosswordGettingGameViewController(crossword: $crossword, match: $xWordMatch)
//    }
//
//    func updateUIViewController(_ uiViewController: CrosswordGettingGameViewController, context: Context) {
//        if (shouldResetDelegate) {
//            xWordMatch.delegate = uiViewController
//            shouldResetDelegate = false
//        }
//
//    }
//}
//
//class CrosswordGettingGameViewController: UIViewController {
//    
//    @Binding var match: GKMatch
//    
//    init(crossword: Binding<Crossword>, match: Binding<GKMatch>) {
//        
//        self._match = match
//        super.init(nibName: nil, bundle: nil)
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        
//        match.delegate = self
//    }
//}
//
//extension CrosswordGettingGameViewController: GKMatchDelegate {
//    func match(_ match: GKMatch, didReceive data: Data, fromRemotePlayer player: GKPlayer) {
//        guard let data = Crossword.decode(data: data) else { return }
//        crosswordModel = data
//    }
//}
