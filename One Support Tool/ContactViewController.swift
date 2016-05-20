//
//  ContactViewController.swift
//  One Support Tool
//
//  Created by Admin on 2016-02-09.
//  Copyright © 2016 EVRY. All rights reserved.
//

import Foundation
import UIKit

class ContactViewController: UIViewController {
    
    /////////////////////////
    // CONTACT INFORMATION //
    /////////////////////////
    let contactEmail = "servicedesk@evry.com"
    let contactPhone = "0738-010444"
    
    @IBOutlet weak var contactText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        contactText.text = "ServiceDesk \n\n" + contactEmail + "\n\n Self Service Portal \n\n Phone \n\n" + contactPhone
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
