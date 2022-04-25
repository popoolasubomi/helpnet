//
//  SignupViewController.swift
//  Helpnet
//
//  Created by Subomi Popoola on 4/24/22.
//

import UIKit

class SignupViewController: UIViewController {

    @IBOutlet weak var firstNamefield: UITextField!
    
    @IBOutlet weak var lastNameField: UITextField!
    
    @IBOutlet weak var emailFIeld: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func signUP(_ sender: Any) {
        if firstNamefield.text != "" && lastNameField.text != "" && emailFIeld.text != "" && passwordField.text != "" {
            self.performSegue(withIdentifier: "signup", sender: nil)
        }
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let vc = segue.destination as! ClothTypeViewController
        vc.firstName = firstNamefield.text
        vc.lastName = lastNameField.text
        vc.email = emailFIeld.text
        vc.password = passwordField.text
    }
    

}
