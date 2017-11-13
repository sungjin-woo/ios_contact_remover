//
//  GroupsViewController.swift
//  iOSContactRemover
//
//  Created by enishi01 on 2017. 11. 13..
//

import UIKit
import Contacts

class GroupsViewController: UITableViewController {
    let store = CNContactStore()
    
    var containerIdentifier: String = ""
    var groups = [CNGroup]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let predicate = CNGroup.predicateForGroupsInContainer(withIdentifier: self.containerIdentifier)
        do {
            let groups = try self.store.groups(matching: predicate)
            self.groups = groups
        } catch {
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func touchedUpInsideClose(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.groups.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "group_cell", for: indexPath)

        if self.groups.count > indexPath.row {
            let group = self.groups[indexPath.row]
            cell.textLabel?.text = group.name
        }
    
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
