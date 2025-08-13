//
//  ViewController.swift
//  Staj7-8
//
//  Created by Ali Ünal UZUNÇAYIR on 13.08.2025.
//

import UIKit
import RxSwift

class ViewController: UIViewController {
    @IBOutlet weak var table: UITableView!
    let viewmodel = Postviewmodel()
    let diposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewmodel.fetcData()
     
        viewmodel.posts
            .bind(to: table.rx.items(cellIdentifier: "cell", cellType: UITableViewCell.self)) { row, post, cell in
                cell.textLabel?.text = post.title
                cell.detailTextLabel?.text = post.body
            }
            .disposed(by: diposeBag)
        
        viewmodel.error
            .subscribe(onNext: { error in
                print("Hata: \(error)")
            })
            .disposed(by: diposeBag)

        viewmodel.loading
            .subscribe(onNext: { isLoading in
                if isLoading {
                    // Spinner göster
                } else {
                    // Spinner gizle
                }
            })
            .disposed(by: diposeBag)
        
    }


}

