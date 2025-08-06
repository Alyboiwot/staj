//
//  ViewController.swift
//  staj3
//
//  Created by Ali Ünal UZUNÇAYIR on 6.08.2025.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
   
    var users: [User] = []
    
    @IBOutlet weak var table: UITableView!
    //Codable ekledik çünkü encodeer ve decoder kullanıcaz yani jsondan hem veri çekicez hem işlicez
    struct User : Codable {
        let id : Int
        let name : String
        let username : String
        let email : String
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
        
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
         fetchusers()
    }
    //API den veri çekme
func fetchusers()  {
        let urlString = "https://jsonplaceholder.typicode.com/users"
    guard let url = URL(string: urlString) else { return }
    
    URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
            print("Error: \(error)")
            return
        }
        
        guard let data = data else {
            print("No data")
            return
        }
        do {
            let users = try JSONDecoder().decode([User].self, from: data)
            DispatchQueue.main.async {
                self.users = users // users structuna çektiklerimi ekle
                self.table.reloadData() // her çektiğimde table relad
            }
        }catch {
            print("hata")
        }
    }.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    // table de  nasıl göstericelcek
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let user = users[indexPath.row]
        cell.textLabel?.text = user.name
        return cell
    }
    
    
    

}

