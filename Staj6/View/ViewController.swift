//
//  ViewController.swift
//  Staj6
//
//  Created by Ali Ünal UZUNÇAYIR on 11.08.2025.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    
    @IBOutlet weak var table: UITableView!
    var crytoList = [Crypto]()
    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
       let  url = "https://raw.githubusercontent.com/atilsamancioglu/K21-JSONDataSet/master/crypto.json"
        let URL = URL(string: url)!
        
        WebServices.downloadCurrency(url:  URL) { (result) in
            switch result {
            case .success(let cryptos):print(cryptos)
                self.crytoList = cryptos
                DispatchQueue.main.async {
                    self.table.reloadData()
                }
            case .failure(let error): print(error)
            }
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return crytoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var content = cell.defaultContentConfiguration( )
        content.text = crytoList[indexPath.row].currency
        content.secondaryText = crytoList[indexPath.row].price
        cell.contentConfiguration = content
        return cell
    }

}

