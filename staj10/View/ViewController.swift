//
//  ViewController.swift
//  staj10
//
//  Created by Ali Ünal UZUNÇAYIR on 15.08.2025.
//

import UIKit
import RxSwift
import RxCocoa


class ViewController: UIViewController {
 
    let matchfrommodel = [MatchResult].self
    let model = MatchModel()
       let disposeBag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        model.fetchforView()
    }


}

