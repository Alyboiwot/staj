//
//  Webservice.swift
//  staj9-10
//
//  Created by Ali Ünal UZUNÇAYIR on 14.08.2025.
//

import Foundation
import RxSwift
import RxCocoa
enum errors : Error {
    case networkError
    case decodingError
}


class Webservice{
    let url = URL(string: "https://jsonplaceholder.typicode.com/users")

    func fetchfromAPI() -> Observable<[User]> {
        return Observable<[User]>.create { observer in
            guard let url = self.url else {
                observer.onError(errors.networkError)
                return Disposables.create()
            }
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    observer.onError(error)
                    return
                }
                guard let data = data else {
                    observer.onError(errors.networkError)
                    return
                }
                do {
                    let users = try JSONDecoder().decode([User].self, from: data)
                    observer.onNext(users)
                    observer.onCompleted()
                } catch {
                    observer.onError(errors.decodingError)
                }
            }
            task.resume()
            return Disposables.create(){
                task.cancel()
            }
        }
    }
    
  
}
