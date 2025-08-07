//
//  StockVC.swift
//  staj4
//
//  Created by Ali Ünal UZUNÇAYIR on 7.08.2025.
//

import UIKit

class StockVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    struct StockModel {
        let symbol: String
        let dividend: Double
        var isFavorite: Bool
    }
    var stocks: [StockModel] = []
    
  
    

    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        table.delegate = self
        table.dataSource = self
        
   
            stocks = [
                StockModel(symbol: "AAPL", dividend: 3.5, isFavorite: true),
                StockModel(symbol: "GOOGL", dividend: 2.1, isFavorite: false),
                StockModel(symbol: "TSLA", dividend: 0.0, isFavorite: true)
            ]

            table.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stocks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! StockCell
        let stock = stocks[indexPath.row]
        
        cell.stocknamebox.text = stock.symbol
        cell.dividendbox.text = "%\(stock.dividend)"
        cell.configure(isFavorite: stock.isFavorite)
        
        return cell
    }

}
//aly@swift.com
