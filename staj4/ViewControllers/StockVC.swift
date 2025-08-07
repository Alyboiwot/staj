//
//  StockVC.swift
//  staj4
//
//  Created by Ali Ünal UZUNÇAYIR on 7.08.2025.
//

import UIKit

class StockVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    struct StockModel : Codable {
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
        

        fetchData()
    
          


            table.reloadData()
        
    }
    
    func fetchData() {
        let apiKey = "WQXJ0W69TIH22ZUX"
        let symbols = ["AAPL", "MSFT", "GOOGL", "AMZN", "META", "TSLA", "NVDA", "INTC", "IBM", "ORCL",
                       "ADBE", "NFLX", "PEP", "KO", "NKE", "CSCO", "QCOM", "AVGO", "TXN", "AMD",
                       "CRM", "BA", "GE", "T", "VZ", "WMT", "HD", "PG", "JNJ", "DIS"]

        var newStocks: [StockModel] = []

        func fetchSymbol(index: Int) {
            if index >= symbols.count {
                DispatchQueue.main.async {
                    self.stocks = newStocks
                    self.table.reloadData()
                }
                return
            }

            let symbol = symbols[index]
            let urlString = "https://www.alphavantage.co/query?function=OVERVIEW&symbol=\(symbol)&apikey=\(apiKey)"

            guard let url = URL(string: urlString) else {
                fetchSymbol(index: index + 1)
                return
            }

            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data,
                   let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let symbol = json["Symbol"] as? String {
                    
                   
                    
                    let dividendString = json["DividendPerShare"] as? String ?? "0"
                    let dividend = Double(dividendString) ?? 0
                    
                    let stock = StockModel(symbol: symbol, dividend: dividend, isFavorite: false)
                   
                    newStocks.append(stock)
                }

                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    fetchSymbol(index: index + 1)
                }

            }.resume()
        }

        fetchSymbol(index: 0)
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
