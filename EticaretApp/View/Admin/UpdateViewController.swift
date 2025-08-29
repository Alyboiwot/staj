//
//  UpdateViewController.swift
//  EticaretApp
//
//  Created by Ali Ünal UZUNÇAYIR on 22.08.2025.
//

import UIKit
import RxSwift
import RxCocoa
import FirebaseFirestore

class UpdateViewController: UIViewController {
    @IBOutlet weak var updateimg: UIImageView!
    @IBOutlet weak var updatename: UITextField!
    @IBOutlet weak var updatedescripton: UITextView!
    @IBOutlet weak var updateprice: UITextField!
    @IBOutlet weak var updatecategory: UITextField!
    @IBOutlet weak var updatebrand: UITextField!
    let adminList = ProductViewModel()
    var productId: String?
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let productId = productId else { return }
        adminList.loadProductForUpdate(productId: productId)
        
        // Rx ile bind
        adminList.name.asObservable()
            .bind(to: updatename.rx.text)
            .disposed(by: disposeBag)
        
        adminList.description.asObservable()
            .map { $0 } // UITextView bind için
            .subscribe(onNext: { [weak self] text in
                self?.updatedescripton.text = text
            })
            .disposed(by: disposeBag)
        
        adminList.price.asObservable()
            .map { String($0) }
            .bind(to: updateprice.rx.text)
            .disposed(by: disposeBag)
        
        adminList.brand.asObservable()
            .bind(to: updatebrand.rx.text)
            .disposed(by: disposeBag)
        
        adminList.category.asObservable()
            .bind(to: updatecategory.rx.text)
            .disposed(by: disposeBag)
        
        adminList.imageURL.asObservable()
            .subscribe(onNext: { [weak self] url in
                if let url = url {
                    self?.updateimg.sd_setImage(with: url)
                }
            })
            .disposed(by: disposeBag)
    }
    

    @IBAction func updatebuttonClicked(_ sender: Any) {
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
