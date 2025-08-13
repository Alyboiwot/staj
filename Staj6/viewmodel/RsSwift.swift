//
//  RsSwift.swift
//  Staj6
//
//  Created by Ali Ünal UZUNÇAYIR on 12.08.2025.
//

import Foundation
import RxSwift
import RxCocoa
class CryptoModel {
    let cryptoList : PublishSubject<[Crypto]> = PublishSubject()
    let erorr : PublishSubject<String> = PublishSubject()
    let loading : PublishSubject<Bool> = PublishSubject()
    
    func fetchData(){
        self.loading.onNext(true)
        
        let  url = "https://raw.githubusercontent.com/atilsamancioglu/K21-JSONDataSet/master/crypto.json"
         let URL = URL(string: url)!
         
         WebServices.downloadCurrency(url:  URL) { (result) in
             switch result {
             case .success(let cryptos):
                 self.cryptoList.onNext(cryptos)
                 print(cryptos)
             case .failure(let error):
                 switch error {
                 case .networkerror:
                     print("NetworkErorr")
                 case .parseerror:
                     print("Parsse erorr")
               
                 }
             }
         }

    }

    
    
}

