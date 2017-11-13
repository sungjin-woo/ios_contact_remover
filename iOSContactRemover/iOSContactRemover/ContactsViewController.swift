//
//  ContactsViewController.swift
//  iOSContactRemover
//
//  Created by enishi01 on 2017. 11. 13..
//

import UIKit
import Contacts

extension CNContact {
    var displayName: String {
        
        
        let formatter = CNContactFormatter()
        formatter.style = .fullName
        
        guard let name = formatter.string(from: self) else {
            return "No name"
        }
        
        return name
    }
}

class ContactsViewController: UITableViewController {
    
    let store = CNContactStore()
    
    var containerIdentifier: String = ""
    var contacts = [CNContact]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let predicate = CNContact.predicateForContactsInContainer(withIdentifier: self.containerIdentifier)
        do {
            let contacts = try self.store.unifiedContacts(matching: predicate,
                                                          keysToFetch: [CNContactIdentifierKey as CNKeyDescriptor,
                                                                        CNContactFormatter.descriptorForRequiredKeys(for: .fullName)])
            self.contacts = contacts
        } catch {
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.contacts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contact_cell", for: indexPath)
        
        if self.contacts.count > indexPath.row {
            let contact = self.contacts[indexPath.row]
            cell.textLabel?.text = contact.displayName
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
        tableView.deselectRow(at: indexPath, animated: true)
    }
   
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
