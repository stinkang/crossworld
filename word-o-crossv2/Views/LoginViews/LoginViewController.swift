//
//  LoginViewController.swift
//  word_o_crossv2
//
//  Created by Austin Kang on 10/13/22.
//

import Foundation
import UIKit
import SwiftUI
import FirebaseAuthUI
import FirebaseOAuthUI

struct LoginView: UIViewControllerRepresentable {
    @Binding var loginTapped: Bool
    @EnvironmentObject var viewModel: LobbyViewModel
    func makeUIViewController(context: Context) -> LoginViewController {
        return LoginViewController(viewModel: viewModel)
    }
    
    func updateUIViewController(_ uiViewController: LoginViewController, context: Context) {
        if loginTapped {
            uiViewController.presentAuthViewController()
            loginTapped = false
        }
    }
}

class LoginViewController: UIViewController, FUIAuthDelegate {
    @ObservedObject var viewModel: LobbyViewModel
    
    let userService = UserService()
    
    init(viewModel: LobbyViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func authPickerViewController(forAuthUI authUI: FUIAuth) -> FUIAuthPickerViewController {
        return CrossworldAuthPickerViewController(authUI: authUI)
    }
    
    func presentAuthViewController() {
        if let authUI = FUIAuth.defaultAuthUI() {
            authUI.providers = [FUIOAuth.appleAuthProvider()]
            authUI.delegate = self
            
            let authViewController = authUI.authViewController()
            self.present(authViewController, animated: true)
        }
    }
    
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        if let user = authDataResult?.user {
            print("Nice! You've signed in as \(user.uid). Your email is: \(user)")
        }
        
        viewModel.userModel = userService.getCurrentUserModel()
    }
}
