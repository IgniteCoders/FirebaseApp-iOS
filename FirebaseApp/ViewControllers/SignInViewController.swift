//
//  ViewController.swift
//  FirebaseApp
//
//  Created by Tardes on 5/2/26.
//

import FirebaseAuth
import FirebaseFirestore
import FirebaseCore
import GoogleSignIn
import UIKit

class SignInViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    let authManager = AuthManager()
    let userRepository = UserRepository()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if authManager.getCurrentUserId() != nil {
            performSegue(withIdentifier: "NavigateToHome", sender: nil)
        }
    }

    @IBAction func signIn(_ sender: Any) {
        let username = usernameTextField.text ?? ""
        let password = passwordTextField.text ?? ""

        Task {
            do {
                try await authManager.signIn(username: username, password: password)
                performSegue(withIdentifier: "NavigateToHome", sender: nil)
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    @IBAction func signInWithGoogle(_ sender: Any) {
        Task {
            do {
                let user = try await authManager.signInWithGoogle(presentingIn: self)
                
                guard let userId = user?.id else { return }
                
                if try await userRepository.getUserBy(id: userId) != nil {
                    performSegue(withIdentifier: "NavigateToHome", sender: nil)
                } else if let user = user {
                    try userRepository.create(user: user)
                    
                    performSegue(withIdentifier: "NavigateToHome", sender: nil)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
