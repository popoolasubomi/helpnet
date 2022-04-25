//
//  SearchViewController.swift
//  Helpnet
//
//  Created by Subomi Popoola on 4/24/22.
//

import UIKit
import Parse

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    
    var temp: Double!
    
    @IBOutlet weak var tableView: UITableView!
    var people = [PFObject]()
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        loadPeople()
    }
    
    func loadPeople() {
        let query = PFUser.query()
        query?.whereKey("objectId", notEqualTo: PFUser.current()?.objectId)
        query?.findObjectsInBackground(block: { (objects, error) in

            if error == nil {
                self.people = objects!
                self.tableView.reloadData()
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
        
        let gameScore = PFObject(className:"requests")
        gameScore["senderId"] = user?.objectId
        gameScore["receiveId"] = person
        gameScore["cheatMode"] = false
        gameScore.saveInBackground { (succeeded, error)  in
            if (succeeded) {
                // The object has been saved.
            } else {
                // There was a problem, check error.description
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchcell") as! SearchCell
        let firstName = people[indexPath.row].object(forKey: "firstName") as! String
        let lastName = people[indexPath.row].object(forKey: "lastName") as! String
        cell.name.text = "\(firstName) \(lastName)"
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
