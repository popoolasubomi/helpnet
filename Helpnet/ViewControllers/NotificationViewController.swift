//
//  NotificationViewController.swift
//  Helpnet
//
//  Created by Subomi Popoola on 4/24/22.
//

import UIKit
import Parse

class NotificationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var people = [PFObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        loadRequests()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.delegate = self
        tableView.dataSource = self
        loadRequests()
    }
    
    func loadRequests() {
        let query = PFQuery(className:"requests")
        query.whereKey("receiveId", equalTo: PFUser.current()?.objectId!)
        query.findObjectsInBackground(block: { (objects, error) in
            if error == nil {
                let reqs: [PFObject] = objects!
                var ids = [String]()
                for obj in reqs {
                    let sender = obj.object(forKey: "senderId") as! String
                    ids.append(sender)
                }
                let query = PFUser.query()
                query?.whereKey("objectId", containedIn: ids)
                query?.findObjectsInBackground(block: { (objects, error) in

                    if error == nil {
                        self.people = objects!
                        self.tableView.reloadData()
                    }
                })
            }
        })
    }
    
    func addFriend(person: String) {
        let user = PFUser.current()
        var friends = user?.object(forKey: "friends") as! [String]
        if !friends.contains(person) {
            friends.append(person)
        }
        user?.setObject(friends, forKey: "friends")
        user?.saveInBackground{ (succeeded, error)  in
                               if (succeeded) {
                                   // The object has been saved.
                               } else {
                                   // There was a problem, check error.description
                               }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "notifcell") as! NotificationCell
        let firstName = people[indexPath.row].object(forKey: "firstName") as! String
        cell.person.text = "\(firstName) sent friend request"
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let person = people[indexPath.row].objectId!
        addFriend(person: person)
        people.remove(at: indexPath.row)
        tableView.reloadData()
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
