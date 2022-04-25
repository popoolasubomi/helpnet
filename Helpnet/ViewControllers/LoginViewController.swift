//
//  LoginViewController.swift
//  Helpnet
//
//  Created by Subomi Popoola on 4/23/22.
//

import UIKit
import Parse

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var signInField: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func signIN(_ sender: Any) {
        PFUser.logInWithUsername(inBackground: self.emailField.text!, password: self.passwordField.text!) {
                  (user: PFUser?, error: Error?) -> Void in
          if user != nil {
              self.performSegue(withIdentifier: "login", sender: nil)
          }
        }
    }

}
