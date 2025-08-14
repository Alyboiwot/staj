//
//  ViewController.swift
//  staj9-10
//
//  Created by Ali Ünal UZUNÇAYIR on 14.08.2025.
//

import UIKit
import RxSwift

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    
    var usersList = [User]()
    @IBOutlet weak var table: UITableView!
   let model = UserModel()
    let disposeBag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
        model.fetchUsers()
        model.users
            .observe(on: MainScheduler.instance) // <- burası eklenmeli
            .subscribe(onNext: { [weak self] fetchedUsers in
                self?.usersList = fetchedUsers
                self?.table.reloadData()
            }).disposed(by: disposeBag)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersList.count
    
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let user = usersList[indexPath.row]
        cell.textLabel?.text = user.username
            return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        _ = usersList[indexPath.row]
        performSegue(withIdentifier: "todetails", sender: nil)
    
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "todetails" {
            if let destination = segue.destination as? DetailsViewController,
               let indexPath = table.indexPathForSelectedRow {
                let userToPass = usersList[indexPath.row]
                destination.userfrromtable = userToPass
            }
        }
    }
    
    
    
    
    
}

