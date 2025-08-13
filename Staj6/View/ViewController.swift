//
//  ViewController.swift
//  Staj6
//
//  Created by Ali Ünal UZUNÇAYIR on 11.08.2025.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    
    @IBOutlet weak var table: UITableView!
    var crytoList = [Crypto]()
    let disposeBag = DisposeBag()
   let cryptoModel = CryptoModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
        
        setupBinding()
        cryptoModel.fetchData()
    }
    
    
    func setupBinding(){
        cryptoModel.erorr.observe(on:MainScheduler.asyncInstance).subscribe{
            errorString in
            print(errorString)
        }.disposed(by:disposeBag)
        cryptoModel.cryptoList.observe(on:MainScheduler.asyncInstance).subscribe{
            crypto in
            self.crytoList = crypto
            self.table.reloadData()
        }.disposed(by: disposeBag)
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

