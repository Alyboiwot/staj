//
//  LibraryVC.swift
//  staj1
//
//  Created by Ali Ünal UZUNÇAYIR on 4.08.2025.
//

import UIKit
import FirebaseStorage
import SDWebImage
class LibraryVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
   
    
    
    var photos : [URL] = []
    
    
    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.dataSource = self
        table.delegate = self
    getPhotos()
        
    }
    


    func getPhotos() {
        let storageRef = Storage.storage().reference().child("images")

        storageRef.listAll { result, error in
            if let error = error {
                print("Fotoğraflar listelenemedi: \(error.localizedDescription)")
                return
            }

            for item in result!.items {
                item.downloadURL { url, error in
                    if let url = url {
                        self.photos.append(url)
                        DispatchQueue.main.async {
                            self.table.reloadData()
                        }
                    }
                }
            }
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! Cellvc
        let url = photos[indexPath.row]
        cell.usercell.sd_setImage(with: url)
        return cell
    }
  
}

//aly@swift.com
