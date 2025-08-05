//
//  TableVC.swift
//  staj2
//
//  Created by Ali Ünal UZUNÇAYIR on 5.08.2025.
//

import UIKit
import FirebaseFirestore
class TableVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
    //table da verileri gösterilecek bu yüzden her firestoredadn çektiğimde bir arraye atmalıyım
    
    @IBOutlet weak var table: UITableView!
    var latitudeArray: [Double] = []
    var longitudeArray: [Double] = []
    var commentArray: [String] = []
    var placeNameArray: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
       getInfo()// getınfo ekran her açıldığıdna geliyor ama yavaş!!
    }
    //
    func getInfo(){
        let db = Firestore.firestore()
        let usersRef = db.collection("users")
        self.latitudeArray.removeAll()
        self.longitudeArray.removeAll()
        self.commentArray.removeAll()
        self.placeNameArray.removeAll()
         
        usersRef.getDocuments() { (querySnapshot, err) in
            if err != nil {
                print("Error")
            } else {
            //döngüde mapvc den çektiğim verileri diziye atılacak ve table da gösterilercek
                for document in querySnapshot!.documents {
                    let data = document.data()
                    if let lati = data["latitude"] as? Double {
                        self.latitudeArray.append(lati)
                    }
                    if let longi = data["longitude"] as? Double {
                        self.longitudeArray.append(longi)
                    }
                    if let comment = data["comment"]as? String {
                        self.commentArray.append(comment)
                    }
                    if let placeName = data["placename"] as? String {
                        self.placeNameArray.append(placeName)
                    }
                }
                //veriler dizide table yenile
                DispatchQueue.main.async {
                    self.table.reloadData()
                }
            }
        }
    }
 
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.commentArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        cell.textLabel?.text = "Yer: \(placeNameArray[indexPath.row]))"
        return cell
        
    }
   

}
