//
//  ProductListView.swift
//  EticaretApp
//
//  Created by Ali Ünal UZUNÇAYIR on 19.08.2025.
//

import UIKit
import RxSwift
import RxCocoa
import FirebaseFirestore
import SDWebImage

class Cart {
    static let shared = Cart()
    private init() {}

    private(set) var products: [Product] = []

    func addProduct(_ product: Product) {
        products.append(product)
    }
}

class ProductListView: UIViewController, UICollectionViewDelegateFlowLayout {
   
    @IBOutlet weak var collection: UICollectionView!
    
    let viewModel = ProductViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collection.delegate = self
        collection.isUserInteractionEnabled = true
        
        if let layout = collection.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
            layout.minimumInteritemSpacing = 8
            layout.minimumLineSpacing = 8
        }
        
        // Admin'in eklediği ürünleri çek
        viewModel.fetchProduct()
        
        // Ürünleri CollectionView'a bağla
        viewModel.product
            .asObservable()
            .observe(on: MainScheduler.instance)
            .bind(to: collection.rx.items(cellIdentifier: "coolcell", cellType: CollectionViewCell.self)) { (row, product, cell) in
                cell.nameLabel.text = product.name
                cell.pricelabel.text = String(format: "%.1f $", product.price)
                cell.imgview.sd_setImage(with: URL(string: product.imageUrl))
            }
            .disposed(by: disposeBag)
        
        // Hücre seçimi için Rx kullan
        collection.rx.modelSelected(Product.self)
            .subscribe(onNext: { [weak self] selectedProduct in
                let detailVC = ProductDetailViewController()
                detailVC.product = selectedProduct
                self?.navigationController?.pushViewController(detailVC, animated: true)
            })
            .disposed(by: disposeBag)
        
        // Sepet butonunu sağ üst navigasyona ekle
        let cartButton = UIBarButtonItem(title: "Sepet", style: .plain, target: self, action: #selector(cartButtonTapped))
        navigationItem.rightBarButtonItem = cartButton
        
        // Filter butonunu sağ üst navigasyona ekle (Sepet butonunun soluna)
        let filterButton = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(filterButtonTapped))
        navigationItem.rightBarButtonItems = [cartButton, filterButton]
    }
    
    @objc private func cartButtonTapped() {
        let cartVC = CartView()
        navigationController?.pushViewController(cartVC, animated: true)
    }
    
    @objc private func filterButtonTapped() {
        let alert = UIAlertController(title: "Filtrele", message: "Lütfen filtre kriterlerini giriniz", preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "Min Fiyat"
            textField.keyboardType = .decimalPad
        }
        
        alert.addTextField { textField in
            textField.placeholder = "Max Fiyat"
            textField.keyboardType = .decimalPad
        }
        
        alert.addTextField { textField in
            textField.placeholder = "Marka"
            textField.autocapitalizationType = .words
        }
        
        alert.addAction(UIAlertAction(title: "İptal", style: .cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Uygula", style: .default, handler: { [weak self] _ in
            guard let self = self else { return }
            let minPriceText = alert.textFields?[0].text ?? ""
            let maxPriceText = alert.textFields?[1].text ?? ""
            let brandText = alert.textFields?[2].text ?? ""
            
            let minPrice = Double(minPriceText)
            let maxPrice = Double(maxPriceText)
            let brand = brandText.trimmingCharacters(in: .whitespacesAndNewlines)
            
            self.viewModel.applyFilter(minPrice: minPrice, maxPrice: maxPrice, brand: brand.isEmpty ? nil : brand)
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    // CollectionView hücre boyutu
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width / 2) - 16
        return CGSize(width: width, height: 200)
    }
}

class ProductDetailViewController: UIViewController {
    var product: Product?

    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.alwaysBounceVertical = true
        return sv
    }()

    private let contentStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        stack.alignment = .fill
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 16
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textAlignment = .center
        label.numberOfLines = 2
        label.setContentHuggingPriority(.required, for: .vertical)
        return label
    }()

    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.italicSystemFont(ofSize: 15)
        label.textColor = .systemBlue
        label.textAlignment = .center
        label.numberOfLines = 1
        label.setContentHuggingPriority(.required, for: .vertical)
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .darkGray
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .systemGray
        label.textAlignment = .center
        label.setContentHuggingPriority(.required, for: .vertical)
        return label
    }()

    private let addToCartButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sepete Ekle", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.backgroundColor = UIColor.systemGreen
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemGroupedBackground

        view.addSubview(scrollView)
        scrollView.addSubview(contentStackView)

        contentStackView.addArrangedSubview(imageView)
        contentStackView.setCustomSpacing(24, after: imageView)
        contentStackView.addArrangedSubview(nameLabel)
        contentStackView.addArrangedSubview(categoryLabel)
        contentStackView.addArrangedSubview(descriptionLabel)
        contentStackView.addArrangedSubview(priceLabel)
        contentStackView.addArrangedSubview(addToCartButton)

        setupConstraints()
        configureView()

        addToCartButton.addTarget(self, action: #selector(addToCartButtonTapped), for: .touchUpInside)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentStackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 24),
            contentStackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 24),
            contentStackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -24),
            contentStackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -24),

            contentStackView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -48),

            imageView.heightAnchor.constraint(equalToConstant: 220),

            addToCartButton.heightAnchor.constraint(equalToConstant: 52),
        ])
    }

    private func configureView() {
        guard let product = product else { return }
        nameLabel.text = product.name
        priceLabel.text = String(format: "%.1f $", product.price)
        imageView.sd_setImage(with: URL(string: product.imageUrl))
        descriptionLabel.text = product.description
        categoryLabel.text = product.category != nil ? "Kategori: \(product.category)" : ""
    }
    
    @objc private func addToCartButtonTapped() {
        guard let product = product else { return }
        Cart.shared.addProduct(product)
        
        let alert = UIAlertController(title: "Başarılı", message: "Ürün sepete eklendi.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
