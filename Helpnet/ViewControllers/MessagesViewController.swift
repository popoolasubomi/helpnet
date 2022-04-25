//
//  MessagesViewController.swift
//  Helpnet
//
//  Created by Subomi Popoola on 4/24/22.
//

import UIKit
import Parse

class MessagesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var receiver: String!
    var messages = [PFObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        loadChats()
        Timer.scheduledTimer(timeInterval: 3,
                                     target: self,
                                     selector: #selector(self.loadChats),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    @objc func loadChats() {
        let query = PFQuery(className: "messages")
        let user = PFUser.current()
        let userID = user!.objectId as! String
        let receiver = receiver as! String
        var peeps = [userID, receiver]
        query.order(byAscending: "createdAt")
        query.whereKey("people", containsAllObjectsIn: peeps)
        query.findObjectsInBackground(block: { (objects, error) in
            if error == nil {
                self.messages = objects!
                self.tableView.reloadData()
            }
        })
    
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "messagecell") as! MessageCell
        let message = messages[indexPath.row]
        let user = PFUser.current()
        let senderID = message.object(forKey: "sender") as! String
        cell.message.text = message.object(forKey: "message") as! String
        if user?.objectId == senderID {
            cell.message.textAlignment = .right
            cell.message.textColor = .purple
        } else {
            cell.message.textAlignment = .left
            cell.message.textColor = .blue
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

    
    @IBAction func didTapSend(_ sender: Any) {
        if textField.text != "" {
            let user = PFUser.current()
            let userID = user!.objectId as! String
            let receiver = receiver as! String
            var peeps = [userID, receiver]
            peeps.sort()
            
            var gameScore = PFObject(className:"messages")
            gameScore["message"] = textField.text
            gameScore["sender"] = userID
            gameScore["people"] = peeps
            gameScore.saveInBackground { success, error in
                if success {
                    print("yes")
                    self.textField.text = ""
                }
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
