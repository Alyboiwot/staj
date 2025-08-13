//
//  APIService.swift
//  Staj7-8
//
//  Created by Ali Ünal UZUNÇAYIR on 13.08.2025.
//

import Foundation
import RxSwift

enum PostEroor : Error {
    case parseError
    case networkEroor
}

class WebService {
   static func dowladPosts() -> Observable<[Post]> {
        let url = URL(string: "https://jsonplaceholder.typicode.com/posts")!
       return Observable.create { observer in
           URLSession.shared.dataTask(with: url) { data, URLResponse, error in
               if let error = error {
                   observer.onError(error)
                   return
               }
               guard let data = data else {
                   observer.onError(PostEroor.parseError)
                   return
               }
               do {
                   let postList = try JSONDecoder().decode([Post].self, from: data)
                  // data → API’den veri geldiyse JSONDecoder ile [Post] array’e çevriliyor.
                   observer.onNext(postList)
                   observer.onCompleted()
               }catch
               {
                   observer.onError(PostEroor.parseError)
               }
           }.resume()
           return Disposables.create()    }
    }
}
    

