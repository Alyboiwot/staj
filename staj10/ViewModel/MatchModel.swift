//
//  MatchModel.swift
//  staj10
//
//  Created by Ali Ünal UZUNÇAYIR on 15.08.2025.
//

import Foundation
import RxSwift
import RxCocoa



class MatchModel{
    
    let matchforview = PublishSubject<[MatchResult]>()
    let webservice = WebService()
    let disposeBag = DisposeBag()

    func fetchforView(){
        webservice.fetchFromURL().subscribe(onNext: { matches in
            self.matchforview.onNext(matches)
            
        },onError: { error in
            print("Error: \(error.localizedDescription)")
        }
                            
        
        
        ).disposed(by: disposeBag)
    }
}
