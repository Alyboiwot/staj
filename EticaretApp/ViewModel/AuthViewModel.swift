//
//  AuthViewModel.swift
//  EticaretApp
//
//  Created by Ali Ünal UZUNÇAYIR on 19.08.2025.
//

import Foundation
import RxSwift
import RxCocoa
import FirebaseAuth
import FirebaseFirestore

class LoginViewModel {
    //yayınlanacak veriler
    let email = BehaviorRelay<String>(value: "")
    let password = BehaviorRelay<String>(value: "")
    let loginResult = PublishRelay<Result<User, Error>>() 
    let disposeBag = DisposeBag()
    
    //giriş fonksiyonu
    func login () {
        Auth.auth().signIn(withEmail: email.value, password: password.value) { result, error in
            if let error = error {
                self.loginResult.accept(.failure(error))
                return
            }
            
            guard let uid = result?.user.uid else {
                let customerror = NSError(domain: "", code: 0, userInfo:[NSLocalizedDescriptionKey: "Kullanıc id bulunamadı"])
                self.loginResult.accept(.failure(customerror))
                return
            }
            Firestore.firestore().collection("user").document(uid).getDocument { document, error in
                if let error = error {
                    self.loginResult.accept(.failure(error))
                    return
                }
                if let document = document, document.exists, let data = document.data() {
                    let user = User(id: uid, data: data)
                    self.loginResult.accept(.success(user))
                } else {
                    let customerror = NSError(domain: "", code: 0, userInfo:[NSLocalizedDescriptionKey: "Kullanıcı rolü bulunamadı"])
                    self.loginResult.accept(.failure(customerror))
                }
            }
        }
    }

    // Kayıt olma fonksiyonu
    func signUp() {
        Auth.auth().createUser(withEmail: email.value, password: password.value) { result, error in
            if let error = error {
                self.loginResult.accept(.failure(error))
                return
            }
            guard let uid = result?.user.uid else {
                let customerror = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey:"kullanıcı id oluşturulamadı"])
                self.loginResult.accept(.failure(customerror))
                return
            }
            let userData: [String: Any] = ["email": self.email.value, "role": "user"]
            Firestore.firestore().collection("user").document(uid).setData(userData) { error in
                if let error = error {
                    self.loginResult.accept(.failure(error))
                    return
                }
                // başarılı olduğunda User objesi ile result dön
                let user = User(id: uid, data: userData)
                self.loginResult.accept(.success(user))
            }
        }
    }
}
