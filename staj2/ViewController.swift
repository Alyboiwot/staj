//
//  ViewController.swift
//  staj2
//
//  Created by Ali Ünal UZUNÇAYIR on 5.08.2025.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ViewController: UIViewController {
    
    
    @IBOutlet weak var mailbox: UITextField!
    
    @IBOutlet weak var passbox: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    @IBAction func SignİnClicked(_ sender: Any) {
        if mailbox.text != "" && passbox.text != ""{
            
            Auth.auth().signIn(withEmail: mailbox.text!, password: passbox.text!) { (result, error) in
                if error != nil{
                    self.makeAlert(title: "erorr", message: error?.localizedDescription ?? "eroro gelmedi")
                }else {
                    self.performSegue(withIdentifier: "tomappage", sender: self)
                }
            }
            
            
            
        }
        
        
    }
    
   
    
    func makeAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
  
    
    @IBAction func UpClicked(_ sender: Any) {  if mailbox.text != "" && passbox.text != ""
        {//aly@swift.com
            Auth.auth().createUser(withEmail: mailbox!.text!, password: passbox!.text!) { result, eroror in
                if eroror != nil {
                    self.makeAlert(title: "eroror", message: eroror!.localizedDescription)
                }else {
                    let db = Firestore.firestore()
                    let userid = Auth.auth().currentUser?.uid
                    
                    if let userActivityId = userid{
                        print(userActivityId)
                        let userData : [String: Any] = ["mail":self.mailbox.text!]
                        db.collection( "users" ).document( userActivityId ).setData( userData )
                        self.performSegue(withIdentifier: "tomappage", sender: self)
                    }
                }
            }
    }
    }
    
}
