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
        
        self.loadContact()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setToolbarHidden(false, animated: false)
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
        
        if !self.isEditing && self.contacts.count > indexPath.row {
            let contact = self.contacts[indexPath.row]
            let alert = UIAlertController(title: nil, message: "The contact \"\(contact.displayName)\" will be removed.\nContinue?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: {
                [weak self] action in
                
                self?.requestDeleteContact(contact)
            }))
            
            self.present(alert, animated: true, completion: nil)
        }
     
        tableView.deselectRow(at: indexPath, animated: true)
    }
   
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navigation = segue.destination as? UINavigationController,
              let vc = navigation.visibleViewController as? GroupsViewController else {
                return
        }
        
        vc.containerIdentifier = self.containerIdentifier
    }
    
    // MARK: - IBAction
    
    @IBAction func touchedUpInsideDeleteAll(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: "All the contacts in the container will be removed.\nContinue?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Delete All", style: .destructive, handler: {
            [weak self] action in
            
            self?.requestDeleteAllContact()
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Contact
    private func loadContact() {
        let predicate = CNContact.predicateForContactsInContainer(withIdentifier: self.containerIdentifier)
        do {
            let contacts = try self.store.unifiedContacts(matching: predicate,
                                                          keysToFetch: [CNContactIdentifierKey as CNKeyDescriptor,
                                                                        CNContactFormatter.descriptorForRequiredKeys(for: .fullName)])
            self.contacts = contacts
        } catch {
        }
    }
    
    private func requestDeleteContact(_ contact: CNContact) {
        self.requestDeleteContacts([contact])
    }
    
    private func requestDeleteAllContact() {
        self.requestDeleteContacts(self.contacts)
    }
    
    private func requestDeleteContacts(_ contacts: [CNContact]) {
        let request = CNSaveRequest()
        
        contacts.forEach { contact in
            guard let cn = contact.mutableCopy() as? CNMutableContact else {
                return
            }
            
            request.delete(cn)
        }
        
        do {
            try self.store.execute(request)
            print("Success, Contacts are deleted : \(contacts)")
            
            self.loadContact()
            self.tableView.reloadData()
        } catch let e {
            print("Failure, Contact delete error: \(e)")
        }
    }
}
