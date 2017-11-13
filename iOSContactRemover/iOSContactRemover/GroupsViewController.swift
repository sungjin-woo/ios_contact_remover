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
        
        self.loadGroups()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - IBAction
    
    @IBAction func touchedUpInsideClose(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func touchedUpInsideDeelteAll(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: "All the groups in the container will be removed.\nContinue?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Delete All", style: .destructive, handler: {
            [weak self] action in
            
            self?.requestDeleteAllGroups()
        }))
        
        self.present(alert, animated: true, completion: nil)
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
        if !self.isEditing && self.groups.count > indexPath.row {
            let group = self.groups[indexPath.row]
            let alert = UIAlertController(title: nil, message: "The group \"\(group.name)\" will be removed.\nContinue?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: {
                [weak self] action in
                
                self?.requestDeleteGroups([group])
            }))
            
            self.present(alert, animated: true, completion: nil)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Group
    
    private func loadGroups() {
        let predicate = CNGroup.predicateForGroupsInContainer(withIdentifier: self.containerIdentifier)
        do {
            let groups = try self.store.groups(matching: predicate)
            self.groups = groups
        } catch {
        }
    }
    
    private func requestDeleteAllGroups() {
        self.requestDeleteGroups(self.groups)
    }
    
    private func requestDeleteGroups(_ groups: [CNGroup]) {
        let request = CNSaveRequest()
        
        groups.forEach { group in
            guard let grp = group.mutableCopy() as? CNMutableGroup else {
                return
            }
            
            request.delete(grp)
        }
        
        do {
            try self.store.execute(request)
            print("Success, Groups are deleted : \(groups)")
            
            self.loadGroups()
            self.tableView.reloadData()
        } catch let e {
            print("Failure, Groups delete error: \(e)")
        }
    }
}
