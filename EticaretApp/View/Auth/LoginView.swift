//
//  ViewController.swift
//  EticaretApp
//
//  Created by Ali Ünal UZUNÇAYIR on 19.08.2025.
//

import UIKit
import FirebaseAuth


class LoginView: UIViewController {

    @IBOutlet weak var mailbox: UITextField!
    
    @IBOutlet weak var passbox: UITextField!
     
    let loginmodel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mailbox.rx.text.orEmpty.bind(to: loginmodel.email).disposed(by: loginmodel.disposeBag)
        
        
        passbox.rx.text.orEmpty.bind(to: loginmodel.password).disposed(by: loginmodel.disposeBag)
        
        loginmodel.loginResult.subscribe(onNext: { result in
            switch result {
            case .success(let user):
                if user.role == "admin" {
                    // admin ana ekranına yönlendir
                    self.performSegue(withIdentifier: "toadmin", sender: nil)
                    
                } else {
                    // normal kullanıcı ekranına yönlendir
                    self.performSegue(withIdentifier: "tohall", sender: nil)
                }
            case .failure(let error):
                // hata mesajını göster
                let alert = UIAlertController(title: "Hata", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Tamam", style: .default))
                self.present(alert, animated: true)
            }
        }).disposed(by: loginmodel.disposeBag)
       
    }

    @IBAction func SignİnClicked(_ sender: Any) {
        loginmodel.login()
        
    }
    @IBAction func SignUpClicked(_ sender: Any) {
        loginmodel.signUp()
    }
    
}

