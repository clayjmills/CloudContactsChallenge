//
//  ContactListTableViewController.swift
//  CloudContactsChallenge
//
//  Created by Clay Mills on 4/21/17.
//  Copyright © 2017 PineAPPle LLC. All rights reserved.
//

import UIKit

class ContactListTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
        title = "Contact List"
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(postsWereUpdated), name: Keys.DidRefreshNotification, object: nil)
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return ContactController.shared.contacts.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Keys.contactCellReuseIdentifier, for: indexPath)
        
        let contact = ContactController.shared.contacts[indexPath.row]
        cell.textLabel?.text = contact.name
        cell.detailTextLabel?.text = "Phone number: \(contact.phoneNumber) Email: \(contact.email)"
        
        return cell
    }
    
    func postsWereUpdated() {
        tableView.reloadData()
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == Keys.contactDetailSeque {
            guard let indexPath = tableView.indexPathForSelectedRow,
                let contactDetailViewController = segue.destination as? ContactDetailViewController else {
                    return }
            
            let contact = ContactController.shared.contacts[indexPath.row]
            contactDetailViewController.contact = contact
            
        }
    }
}
