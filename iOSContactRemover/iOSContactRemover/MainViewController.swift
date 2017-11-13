//
//  MainViewController.swift
//  iOSContactRemover
//
//  Created by enishi01 on 2017. 11. 13..
//

import UIKit
import Contacts

class MainViewController: UITableViewController {
    
    let store = CNContactStore()

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.requestAuthorization { [weak self] authorized in
            guard authorized else {
                let alert = UIAlertController(title: nil, message: "Can not access contact frameworks", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: nil))
                self?.present(alert, animated: true, completion: nil)
                return
            }
            
            self?.showSourceListViewController()
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    private func showSourceListViewController() {
        self.performSegue(withIdentifier: "show_containers", sender: nil)
    }
    
    private func requestAuthorization(completion: @escaping ((Bool) -> Void)) {
        DispatchQueue.global(qos: .default).async { [weak self] in
            let status = CNContactStore.authorizationStatus(for: .contacts)
            switch status {
                case .notDetermined:
                    
                    self?.store.requestAccess(for: .contacts, completionHandler: { value, error in
                        DispatchQueue.main.async {
                            completion(value)
                        }
                    })
                case .authorized:
                    DispatchQueue.main.async {
                        completion(true)
                    }
                default:
                    DispatchQueue.main.async {
                        completion(false)
                    }
            }
        }
    }
}

