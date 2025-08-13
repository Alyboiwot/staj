//
//  Postviewmodel.swift
//  Staj7-8
//
//  Created by Ali Ünal UZUNÇAYIR on 13.08.2025.
//


 //
import Foundation
import RxSwift
import RxCocoa

class Postviewmodel {
    private let disposeBag = DisposeBag()
    let posts : PublishSubject<[Post]> = PublishSubject()
    let error : PublishSubject<Error> = PublishSubject()
    let loading : PublishSubject<Bool> = PublishSubject()
    
    func fetcData(){
        WebService.dowladPosts().subscribe(onNext: {
            (post) in
            self.posts.onNext(post)
            self.loading.onNext(false)
        },
                                           onError: {
            (error) in
            self.error.onNext(error)
            self.loading.onNext(false)
        }).disposed(by: disposeBag)
    }
}
