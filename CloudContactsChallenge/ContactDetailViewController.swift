//
//  ContactDetailViewController.swift
//  CloudContactsChallenge
//
//  Created by Clay Mills on 4/21/17.
//  Copyright © 2017 PineAPPle LLC. All rights reserved.
//

import UIKit
import CloudKit

class ContactDetailViewController: UIViewController {
    
    private let cloudKitManager = CloudKitManager()
    
    var contact: Contact? {
        didSet {
            if  isViewLoaded {
                loadViewIfNeeded()
                updateViews()
            }
        }
    }
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let contact = contact else {return }
        title = "\(contact.name)"
        
    }
    @IBAction func saveButtonTapped(_ sender: Any) {
        
        if let contact = self.contact {
            contact.cloudKitRecord.setValue(nameTextField.text, forKey: Keys.nameKey)
            contact.cloudKitRecord.setValue(phoneNumberTextField.text, forKey: Keys.phoneNumberKey)
            contact.cloudKitRecord.setValue(emailTextField.text, forKey: Keys.emailKey)
            
            let record = contact.cloudKitRecord
            
            cloudKitManager.save(record) { (error) in
                if let error = error {
                    NSLog(error.localizedDescription)
                    return
                }
            }
            dismiss(animated: true, completion: nil)
        } else {
            guard let name = nameTextField.text,
                let phoneNumber = phoneNumberTextField.text,
                let email = emailTextField.text else { return }
            let contact = Contact(name: name, phoneNumber: phoneNumber, email: email)
            ContactController.shared.create(contact: contact)
            let _ = navigationController?.popViewController(animated: true)
        }
    }
    func updateViews() {
        guard let contact = contact else {return }
        nameTextField.text = contact.name
        phoneNumberTextField.text = contact.phoneNumber
        emailTextField.text = contact.email
    }
}
