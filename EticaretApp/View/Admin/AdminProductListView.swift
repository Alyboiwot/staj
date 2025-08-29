//
//  AdminProductListView.swift
//  EticaretApp
//
//  Created by Ali Ünal UZUNÇAYIR on 19.08.2025.
//

import UIKit
import RxSwift
import RxCocoa
import FirebaseFirestore
import SDWebImage
class AdminProductListView: UIViewController {

    
   
    @IBOutlet weak var table: UITableView!
    let adminList =  ProductViewModel()
    let disposeBag = DisposeBag()
    var selectedProductId: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        adminList.fetchProduct()

        adminList.product
            .asObservable()
            .bind(to: table.rx.items(cellIdentifier: "cell", cellType: updatecell.self)) { [weak self] row, product, cell in
                // Set product label
                cell.productlabel.text = product.name
                // Set price label with 2 decimal places
                cell.pricelabel.text = String(format: "%.2f ₺", product.price)
                // Set product image
                cell.productview.sd_setImage(with: URL(string: product.imageUrl))
                // Set product property if exists
                cell.product = product
                // Set onDelete closure
                cell.onDelete = { [weak self] product in
                    self?.adminList.deleteProduct(product)
                        .subscribe(onNext: { success in
                            print(success ? "Silindi" : "Silinemedi")
                        })
                        .disposed(by: self?.disposeBag ?? DisposeBag())
                }
                // Set onUpdate closure (optional, example)
                cell.onUpdate = { [weak self] product in
                    self?.selectedProductId = product.id
                    self?.performSegue(withIdentifier: "updateProduct", sender: nil)
                
                    print("Update tapped for \(product.name)")
                }
            }
            .disposed(by: disposeBag)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "updateProduct" {
            if let destinationVC = segue.destination as? UpdateViewController {
                destinationVC.productId = selectedProductId
            }
        }
    }
    
}
