//
//  ChatViewController.swift
//  Helpnet
//
//  Created by Subomi Popoola on 4/24/22.
//

import UIKit
import Parse
class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var friends = [PFObject]()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        loadChats()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        loadChats()
    }
    
    func loadChats() {
        let user = PFUser.current()
        let people = user?.object(forKey: "friends") as! [String]
        let query = PFUser.query()
        query?.whereKey("objectId", containedIn: people)
        query?.findObjectsInBackground(block: { (objects, error) in
            if error == nil {
                self.friends = objects!
                self.tableView.reloadData()
            }
        })
    
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chatcell") as! ChatCell
        let firstName = friends[indexPath.row].object(forKey: "firstName") as! String
        let lastName = friends[indexPath.row].object(forKey: "lastName") as! String
        cell.name.text = "\(firstName) \(lastName)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "messagesegue", sender: friends[indexPath.row].objectId)
    }
    @IBAction func didTapNotifs(_ sender: Any) {
        self.performSegue(withIdentifier: "notifsegue", sender: nil)
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "messagesegue" {
            let vc = segue.destination as! MessagesViewController
            vc.receiver = sender as! String
        }
    }
    

}
