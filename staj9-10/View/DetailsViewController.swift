//
//  DetailsViewController.swift
//  staj9-10
//
//  Created by Ali Ünal UZUNÇAYIR on 14.08.2025.
//

import UIKit

class DetailsViewController: UIViewController {
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var street: UILabel!
    @IBOutlet weak var mail: UILabel!
    @IBOutlet weak var user: UILabel!
    
    @IBOutlet weak var username: UILabel!
    
    var userfrromtable : User?
    override func viewDidLoad() {
        super.viewDidLoad()
        username.text = userfrromtable?.username
        mail.text = userfrromtable?.email
        street.text = userfrromtable?.address.street
        city.text = userfrromtable?.address.city
    }
    

   

}
