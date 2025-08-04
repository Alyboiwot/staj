//
//  ViewController.swift
//  staj1
//
//  Created by Ali Ünal UZUNÇAYIR on 4.08.2025.
//

import UIKit
import FirebaseAuth
class LoginVC: UIViewController {

    @IBOutlet weak var mailbox: UITextField!
    @IBOutlet weak var passbox: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
    }
//mevcut kullanıcı auth
    @IBAction func signİnClicked(_ sender: Any) {
        
        if mailbox.text != "" && passbox.text != "" {
            Auth.auth().signIn(withEmail: mailbox.text!, password: passbox.text!) { (result, error) in
                if error != nil {
                    self.makeAlert(title: "error", message: error?.localizedDescription ?? "eror.localizedDescription çalışmadı")
                }else{
                    print("giriş başarılı")
                    self.performSegue(withIdentifier: "upload", sender: self)
                }
            }
        }
        
        
        
      //yeni kullanıcı auth
    }
    @IBAction func SignUpClicked(_ sender: Any) {
        if mailbox.text != "" && passbox.text != "" {
            Auth.auth().createUser(withEmail: mailbox.text!, password: passbox.text!) { (result, error) in
                if error != nil {
                    self.makeAlert(title: "error", message: error!.localizedDescription)
                }else{
                    self.performSegue(withIdentifier: "upload", sender: self)
                }
            }
        }
        
        
        
        
        
    }
    
    func makeAlert(title: String, message: String)  {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let button = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(button)
        present(alert, animated: true)
    }
    
}

