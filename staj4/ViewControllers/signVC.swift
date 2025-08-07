//
//  ViewController.swift
//  staj4
//
//  Created by Ali Ünal UZUNÇAYIR on 7.08.2025.
//  2FQYT58SWS37XF9X Borsa API

import UIKit
import FirebaseAuth
import LocalAuthentication
class signVC: UIViewController {
    @IBOutlet weak var mailbox: UITextField!
    @IBOutlet weak var passbox: UITextField!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showTouchID()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
      
    }
    @IBAction func signinclicked(_ sender: Any) {
       
        if mailbox.text != "" && passbox.text != "" {
          
            Auth.auth().signIn(withEmail: mailbox!.text!, password: passbox!.text!) { Result, error in
                if error != nil {
                    self.makeAlert(title: "eroor", message: error!.localizedDescription)
                }
                else {
                    self.performSegue(withIdentifier: "tabbar", sender: nil)
                }
            }
            
            
            
            
            
        }
       
        
        
    }
    
    @IBAction func signUpClicked(_ sender: Any) {
        if mailbox.text != "" && passbox.text != ""
        {
            Auth.auth().createUser(withEmail: mailbox!.text!, password: passbox!.text!) { Result, error in
                if error != nil   {
                    self.makeAlert(title: "ERROR", message: error!.localizedDescription)
                }else{
                    self.performSegue(withIdentifier: "tabbar", sender: self)
                }
            }
        }
        
        
    }
    func makeAlert(title:String, message : String)  {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let button = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        alert.addAction(button)
        present(alert, animated: true)
    }
    
    func showTouchID() {
        let alert = UIAlertController(title: "Giriş Seçenekleri", message: "Touch ID ile giriş yapmak ister misiniz?", preferredStyle: .alert)
        
     let touchyap = UIAlertAction(title: "Evet", style: .default) { (_) in
         self.touchID()
        }
        
        let firebase = UIAlertAction(title: "İptal", style: UIAlertAction.Style.default, handler: nil)
        
        alert.addAction(touchyap)
        alert.addAction(firebase)
        present(alert, animated: true)
    }
    
    
    
    
func touchID() {
    let context = LAContext()
    var error: NSError?

    if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
        if context.biometryType == .faceID {
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Use Face ID to log in") { success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        self.performSegue(withIdentifier: "tabbar", sender: self)
                    } else {
                        self.makeAlert(title: "Authentication Failed", message: authenticationError?.localizedDescription ?? "Please try again.")
                    }
                }//aly@swift.com
            }
        } else {
            self.makeAlert(title: "Face ID Not Available", message: "Face ID is not configured or not supported on this device.")
        }
    } else {
        makeAlert(title: "Biometric Authentication Not Available", message: error?.localizedDescription ?? "Authentication is not available.")
    }
}
    
    
    
}

