//
//  SettingsViewController.swift
//  FirebaseApp
//
//  Created by Tardes on 6/2/26.
//

import UIKit
import FirebaseAuth

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func signOut(_ sender: Any) {
        do {
            defer {
                navigationController?.navigationController?.popToRootViewController(animated: true)
            }
            
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }

}
