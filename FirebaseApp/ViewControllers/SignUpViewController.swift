//
//  SignUpViewController.swift
//  FirebaseApp
//
//  Created by Tardes on 6/2/26.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class SignUpViewController: UIViewController {
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var genderSegmentedControl: UISegmentedControl!
    @IBOutlet weak var birthdateDatePicker: UIDatePicker!
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordRepeatTextField: UITextField!
    
    let authManager = AuthManager()
    let userRepository = UserRepository()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func signUp(_ sender: Any) {
        if !validateForm() {
            return
        }
        
        let username = usernameTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        Task {
            do {
                let userId = try await authManager.signUp(username: username, password: password)
                
                print("Account created successfully")
                let firstName = firstNameTextField.text ?? ""
                let lastName = lastNameTextField.text ?? ""
                let gender = genderSegmentedControl.selectedSegmentIndex
                let birthdate = birthdateDatePicker.date.millisecondsSince1970
                
                let user = User(
                    id: userId,
                    firstName: firstName,
                    lastName: lastName,
                    email: username,
                    gender: gender,
                    birthdate: birthdate,
                    photoUrl: nil
                )
                
                try userRepository.create(user: user)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func validateForm() -> Bool {
        let firstName = firstNameTextField.text ?? ""
        let lastName = lastNameTextField.text ?? ""
        let username = usernameTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        let passwordRepeat = passwordRepeatTextField.text ?? ""
        
        if firstName.isEmpty {
            // Mostrar mensaje de error
            return false
        }
        if lastName.isEmpty {
            return false
        }
        if username.isEmpty {
            return false
        }
        if !username.isValidEmail() {
            return false
        }
        if password.count < 6 {
            return false
        }
        if password != passwordRepeat {
            return false
        }
        return true
    }
}
