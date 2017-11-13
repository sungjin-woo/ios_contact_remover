//
//  ContainerViewController.swift
//  iOSContactRemover
//
//  Created by enishi01 on 2017. 11. 13..
//

import UIKit
import Contacts

extension CNContainer {
    var displayName: String {
        guard !self.name.isEmpty else {
            return "NO NAMED"
        }
        
        return name
    }
    
    var typeName: String {
        switch self.type {
        case .local:
            return "local"
        case .exchange:
            return "exchange"
        case .cardDAV:
            return "cardDAV"
        case .unassigned:
            return "unassigned"
        }
    }
}

class ContainerViewController: UITableViewController {
    
    let store = CNContactStore()
    
    var containers = [CNContainer]()
    
    var selectedIdentifier: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        do {
            let containers = try self.store.containers(matching: nil)
            self.containers = containers
        } catch {
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.containers.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "container_cell", for: indexPath)

        if self.containers.count > indexPath.row {
            let container = self.containers[indexPath.row]
            cell.textLabel?.text = container.displayName
            cell.detailTextLabel?.text = container.typeName
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if self.containers.count > indexPath.row {
            let container = self.containers[indexPath.row]
            
            self.selectedIdentifier = container.identifier
            
            self.performSegue(withIdentifier: "show_contacts", sender: nil)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let vc = segue.destination as? ContactsViewController else {
            return
        }
        
        vc.containerIdentifier = self.selectedIdentifier
        self.selectedIdentifier = ""
    }
}
