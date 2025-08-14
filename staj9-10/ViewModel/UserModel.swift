//
//  UserModel.swift
//  staj9-10
//
//  Created by Ali Ünal UZUNÇAYIR on 14.08.2025.
//

import Foundation
import RxSwift
class UserModel{
    
    let users = PublishSubject<[User]>()
    private let webService = Webservice()
    private let disposeBag = DisposeBag()

    func fetchUsers() {
        webService.fetchfromAPI().subscribe(
            onNext: { [weak self] fetchedUsers in
                self?.users.onNext(fetchedUsers)
            },
            onError: { error in
                print("Error: \(error)")
            }
        ).disposed(by: disposeBag)
    }
    
}
