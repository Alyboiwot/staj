//
//  LogOutVC.swift
//  staj2
//
//  Created by Ali Ünal UZUNÇAYIR on 5.08.2025.
//

import UIKit
import FirebaseAuth
class LogOutVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    

    @IBAction func LogOutClicked(_ sender: Any) {
        
        do{
            try Auth.auth().signOut()
            self.performSegue(withIdentifier: "tolog", sender: self)
        }catch{
            print("Çıkış Yapılamadı")
        }
        
        
        
    }
    
}
