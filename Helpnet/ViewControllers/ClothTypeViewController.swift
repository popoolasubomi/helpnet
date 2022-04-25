//
//  ClothTypeViewController.swift
//  Helpnet
//
//  Created by Subomi Popoola on 4/24/22.
//

import UIKit
import Parse

class ClothTypeViewController: UIViewController {
    
    var firstName: String!
    var lastName: String!
    var email: String!
    var password: String!
    
    @IBOutlet weak var hasLightPants: UISwitch!
    
    @IBOutlet weak var hasLightSHirts: UISwitch!
    
    @IBOutlet weak var hasMediumPants: UISwitch!
    
    @IBOutlet weak var hasMediumShirts: UISwitch!
    
    @IBOutlet weak var hasThickPants: UISwitch!
    
    @IBOutlet weak var hasThickSHirts: UISwitch!
    
    @IBOutlet weak var readyToGive: UISwitch!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func tapContinue(_ sender: Any) {
        let user = PFUser()
        user.username = email
        user.email = email
        user.password = password
        user.setObject(firstName, forKey: "firstName")
        user.setObject(lastName, forKey: "lastName")
        user.setObject([], forKey: "friends")
        user.setObject(hasLightPants.isOn, forKey: "lightPants")
        user.setObject(hasLightSHirts.isOn, forKey: "lightShirts")
        user.setObject(hasMediumPants.isOn, forKey: "mediumPants")
        user.setObject(hasMediumShirts.isOn, forKey: "mediumShirts")
        user.setObject(hasThickPants.isOn, forKey: "thickPants")
        user.setObject(hasThickSHirts.isOn, forKey: "thickShirts")
        user.setObject(readyToGive.isOn, forKey: "readyToGive")
        user.signUpInBackground {(succeeded: Bool, error: Error?) -> Void in
            if error == nil {
                self.performSegue(withIdentifier: "finishsignup", sender: nil)
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
