//
//  FriendsTableViewController.swift
//  Lab-6
//
//  Created by user239680 on 7/8/24.
//

import UIKit

class FriendsTableViewController: UITableViewController {
    //    hardcoded items
    var friends = [
           ["name": "John Doe", "phone": "123-456-7890", "email": "johndoe@example.com"],
           ["name": "Jane Smith", "phone": "234-567-8901", "email": "janesmith@example.com"],
           ["name": "Alice Johnson", "phone": "345-678-9012", "email": "alicejohnson@example.com"],
           ["name": "Bob Brown", "phone": "456-789-0123", "email": "bobbrown@example.com"],
           ["name": "Charlie Davis", "phone": "567-890-1234", "email": "charliedavis@example.com"],
           ["name": "Diana Evans", "phone": "678-901-2345", "email": "dianaevans@example.com"],
           ["name": "Evan Foster", "phone": "789-012-3456", "email": "evanfoster@example.com"],
           ["name": "Fiona Green", "phone": "890-123-4567", "email": "fionagreen@example.com"]
       ]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Friends"

        loadFriends()
        
        self.navigationItem.leftBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as! FriendsTableViewCell

        let friend = friends[indexPath.row]
        cell.friendNameLabel.text = friend["name"]
        cell.phoneLabel.text = friend["phone"]
        cell.emailLabel.text = friend["email"]
        
        cell.cityImage.image = UIImage(named: "defaultCityImage")
        cell.sportImage.image = UIImage(named: "defaultSportImage")
        cell.foodImage.image = UIImage(named: "defaultFoodImage")

        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            friends.remove(at: indexPath.row)
            saveFriends()
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let movedFriend = friends.remove(at: fromIndexPath.row)
        friends.insert(movedFriend, at: to.row)
        saveFriends()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showAddFriend" {
            let addFriendVC = segue.destination as! AddFriendsViewController
            addFriendVC.delegate = self
        }
    }

    func saveFriends() {
        UserDefaults.standard.set(friends, forKey: "friends")
    }

    func loadFriends() {
        if let savedFriends = UserDefaults.standard.array(forKey: "friends") as? [[String: String]] {
            friends = savedFriends
        }
    }
}

extension FriendsTableViewController: AddFriendDelegate {
    func didAddFriend(friend: [String: String]) {
        friends.append(friend)
        saveFriends()
        tableView.reloadData()
    }
}
