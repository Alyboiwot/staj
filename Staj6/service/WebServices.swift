//
//  WebServices.swift
//  Staj6
//
//  Created by Ali Ünal UZUNÇAYIR on 11.08.2025.
//

import Foundation
enum CryptoError: Error {
case parseerror
    case networkerror
}


class WebServices {
static func downloadCurrency(url: URL , completion: @escaping (Result<[Crypto], CryptoError>) -> Void)
    {
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(.networkerror))
            }else if let data = data  {
                let cryptoList = try! JSONDecoder().decode([Crypto].self, from: data)
                completion(.success(cryptoList))
            }else {
                completion(.failure(.parseerror))
            }
        }.resume()
        
    }
}
