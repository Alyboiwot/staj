//
//  CartView.swift
//  EticaretApp
//
//  Created by Ali Ünal UZUNÇAYIR on 19.08.2025.
//

import UIKit

class CartItemCell: UITableViewCell {
    static let identifier = "CartItemCell"
    
    let productImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 8
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.widthAnchor.constraint(equalToConstant: 80).isActive = true
        iv.heightAnchor.constraint(equalToConstant: 80).isActive = true
        return iv
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.numberOfLines = 1
        return label
    }()
    
    let brandLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        label.numberOfLines = 1
        return label
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .systemBlue
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var infoStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [nameLabel, brandLabel, priceLabel])
        sv.axis = .vertical
        sv.alignment = .leading
        sv.spacing = 4
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private lazy var containerStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [productImageView, infoStackView])
        sv.axis = .horizontal
        sv.alignment = .center
        sv.spacing = 12
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(containerStackView)
        
        NSLayoutConstraint.activate([
            containerStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            containerStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with product: Product) {
        nameLabel.text = product.name
        brandLabel.text = product.brand ?? ""
        priceLabel.text = String(format: "$%.1f", product.price)
        if let urlString = product.imageUrl as? String, let url = URL(string: urlString) {
            // SDWebImage ile uzaktan yükleme
            productImageView.sd_setImage(with: url, placeholderImage: UIImage(systemName: "photo"))
        } else {
            productImageView.image = UIImage(systemName: "photo")
        }
    }
}

class CartView: UIViewController, UITableViewDataSource, UITableViewDelegate {

    private let tableView = UITableView()
    private let buyButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CartItemCell.self, forCellReuseIdentifier: CartItemCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = 104
        tableView.separatorStyle = .singleLine
        view.addSubview(tableView)
        
        buyButton.setTitle("Buy", for: .normal)
        buyButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        buyButton.translatesAutoresizingMaskIntoConstraints = false
        buyButton.addTarget(self, action: #selector(buyButtonTapped), for: .touchUpInside)
        view.addSubview(buyButton)
        
        NSLayoutConstraint.activate([
            buyButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            buyButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            buyButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            buyButton.heightAnchor.constraint(equalToConstant: 50),
            
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: buyButton.topAnchor)
        ])
    }
    
    @objc private func buyButtonTapped() {
        let checkoutVC = CheckoutViewController(products: Cart.shared.products)
        checkoutVC.modalPresentationStyle = .pageSheet
        present(checkoutVC, animated: true, completion: nil)
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Cart.shared.products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let product = Cart.shared.products[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CartItemCell.identifier, for: indexPath) as? CartItemCell else {
            return UITableViewCell()
        }
        cell.configure(with: product)
        return cell
    }
    
}

// MARK: - CheckoutViewController
class CheckoutViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private let products: [Product]
    private let tableView = UITableView()
    private let totalLabel = UILabel()
    private let proceedButton = UIButton(type: .system)

    init(products: [Product]) {
        self.products = products
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Checkout"

        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CartItemCell.self, forCellReuseIdentifier: CartItemCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = 104
        view.addSubview(tableView)

        totalLabel.font = UIFont.boldSystemFont(ofSize: 22)
        totalLabel.textColor = .systemBlue
        totalLabel.textAlignment = .right
        totalLabel.translatesAutoresizingMaskIntoConstraints = false
        let total = products.reduce(0) { $0 + $1.price }
        totalLabel.text = String(format: "Total: $%.2f", total)
        view.addSubview(totalLabel)
        
        proceedButton.setTitle("Kart İşlemleri", for: .normal)
        proceedButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        proceedButton.translatesAutoresizingMaskIntoConstraints = false
        proceedButton.addTarget(self, action: #selector(proceedButtonTapped), for: .touchUpInside)
        view.addSubview(proceedButton)

        NSLayoutConstraint.activate([
            proceedButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            proceedButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            proceedButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            proceedButton.heightAnchor.constraint(equalToConstant: 50),

            totalLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            totalLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            totalLabel.bottomAnchor.constraint(equalTo: proceedButton.topAnchor, constant: -8),
            totalLabel.heightAnchor.constraint(equalToConstant: 32),

            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: totalLabel.topAnchor, constant: -8)
        ])
    }
    
    @objc private func proceedButtonTapped() {
        let cardPaymentVC = CardPaymentViewController()
        cardPaymentVC.modalPresentationStyle = .pageSheet
        present(cardPaymentVC, animated: true, completion: nil)
    }

    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let product = products[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CartItemCell.identifier, for: indexPath) as? CartItemCell else {
            return UITableViewCell()
        }
        cell.configure(with: product)
        return cell
    }
}

// MARK: - CardPaymentViewController
class CardPaymentViewController: UIViewController {
    
    private let cartImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "cart.fill"))
        iv.tintColor = .systemBlue
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let nameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Ad"
        tf.borderStyle = .roundedRect
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private let cardNumberTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Kart Numarası"
        tf.borderStyle = .roundedRect
        tf.keyboardType = .numberPad
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private let expiryDateTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Son Kullanma Tarihi (AA/YY)"
        tf.borderStyle = .roundedRect
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private let cvvTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "CVV"
        tf.borderStyle = .roundedRect
        tf.keyboardType = .numberPad
        tf.isSecureTextEntry = true
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private let payButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Pay", for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = .systemBlue
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = 10
        btn.clipsToBounds = true
        return btn
    }()
    
    private let expiryDatePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.locale = Locale(identifier: "en_US_POSIX")
        picker.calendar = Calendar(identifier: .gregorian)
        picker.minimumDate = Date()
        return picker
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Kart İşlemleri"
        
        view.addSubview(cartImageView)
        view.addSubview(nameTextField)
        view.addSubview(cardNumberTextField)
        view.addSubview(expiryDateTextField)
        view.addSubview(cvvTextField)
        view.addSubview(payButton)
        
        expiryDateTextField.inputView = expiryDatePicker
        expiryDatePicker.addTarget(self, action: #selector(expiryDateChanged), for: .valueChanged)
        payButton.addTarget(self, action: #selector(payButtonTapped), for: .touchUpInside)
        // Set expiryDateTextField's text to initial picker value
        updateExpiryDateTextField()
        
        // Add a toolbar with Done button for the date picker
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePickingDate))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([flexSpace, doneButton], animated: false)
        expiryDateTextField.inputAccessoryView = toolbar
        
        NSLayoutConstraint.activate([
            cartImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            cartImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cartImageView.widthAnchor.constraint(equalToConstant: 80),
            cartImageView.heightAnchor.constraint(equalToConstant: 80),
            
            nameTextField.topAnchor.constraint(equalTo: cartImageView.bottomAnchor, constant: 20),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nameTextField.heightAnchor.constraint(equalToConstant: 44),
            
            cardNumberTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 12),
            cardNumberTextField.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            cardNumberTextField.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
            cardNumberTextField.heightAnchor.constraint(equalToConstant: 44),
            
            expiryDateTextField.topAnchor.constraint(equalTo: cardNumberTextField.bottomAnchor, constant: 12),
            expiryDateTextField.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            expiryDateTextField.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
            expiryDateTextField.heightAnchor.constraint(equalToConstant: 44),
            
            cvvTextField.topAnchor.constraint(equalTo: expiryDateTextField.bottomAnchor, constant: 12),
            cvvTextField.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            cvvTextField.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
            cvvTextField.heightAnchor.constraint(equalToConstant: 44),
            
            payButton.topAnchor.constraint(equalTo: cvvTextField.bottomAnchor, constant: 24),
            payButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            payButton.heightAnchor.constraint(equalToConstant: 50),
            payButton.widthAnchor.constraint(equalToConstant: 120)
        ])
    }
    
    private func updateExpiryDateTextField() {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/yy"
        expiryDateTextField.text = formatter.string(from: expiryDatePicker.date)
    }
    
    @objc private func expiryDateChanged() {
        updateExpiryDateTextField()
    }
    
    @objc private func donePickingDate() {
        updateExpiryDateTextField()
        expiryDateTextField.resignFirstResponder()
    }
    
    @objc private func payButtonTapped() {
        let alert = UIAlertController(title: "Ödeme Başarılı", message: "Kart işleminiz başarıyla tamamlandı.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: { _ in
            self.dismiss(animated: true, completion: nil)
        }))
        present(alert, animated: true, completion: nil)
    }
}
