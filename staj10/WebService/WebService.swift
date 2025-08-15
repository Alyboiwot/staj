//
//  WebService.swift
//  staj10
//
//  Created by Ali Ünal UZUNÇAYIR on 15.08.2025.
//

import Foundation
import RxSwift

enum WebServiceError: Error {
    case urlError
    case networkError
    case decodingError
}

class WebService {
    
    let urlString = "https://api.jsonbin.io/v3/b/689f2e3743b1c97be91ef6c4"
    
    func fetchFromURL() -> Observable<[MatchResult]> {
        return Observable<[MatchResult]>.create { observer in
            
            guard let url = URL(string: self.urlString) else {
                observer.onError(WebServiceError.urlError)
                return Disposables.create()
            }
            
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    observer.onError(error)
                    return
                }
                
                guard let data = data else {
                    print("Fetching from URL: \(url)")
                    observer.onError(WebServiceError.networkError)
                    return
                }
                
                do {
                    let matches = try JSONDecoder().decode([MatchResult].self, from: data)
                    observer.onNext(matches)
                    observer.onCompleted()
                } catch {
                    observer.onError(WebServiceError.decodingError)
                }
            }
            
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
}
