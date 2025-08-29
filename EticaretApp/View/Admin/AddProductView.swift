//
//  AddProductView.swift
//  EticaretApp
//
//  Created by Ali Ünal UZUNÇAYIR on 19.08.2025.
//

import UIKit
import RxSwift
import RxCocoa
import FirebaseStorage
import FirebaseFirestore

class AddProductView: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UITextViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerView.tag == 1 ? categories.count : brands.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerView.tag == 1 ? categories[row] : brands[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
            category.text = categories[row]
        } else {
            brand.text = brands[row]
        }
    }
    

    let viewModel = ProductViewModel()

    @IBOutlet weak var imgview: UIImageView!
    
    @IBOutlet weak var productname: UITextField!
    
    
    @IBOutlet weak var price: UITextField!
    
  
    @IBOutlet weak var descriptiontextview: UITextView!
    
    @IBOutlet weak var category: UITextField!
    
    @IBOutlet weak var brand: UITextField!
    
    @IBOutlet weak var addbutton: UIButton!
   
    let categories = ["Ayakkabı", "Tshirt","Pantolon"]
    let brands = ["Adidas", "Colins", "Nike", "Mavi"]
    
    let selectedImage = PublishRelay<UIImage>()
    let disposeBag = DisposeBag()
    
    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "Açıklama"
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let categoryPicker = UIPickerView()
            categoryPicker.tag = 1
            categoryPicker.delegate = self
            categoryPicker.dataSource = self
            category.inputView = categoryPicker
            
            let brandPicker = UIPickerView()
            brandPicker.tag = 2
            brandPicker.delegate = self
            brandPicker.dataSource = self
            brand.inputView = brandPicker
        
        descriptiontextview.delegate = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Storage", style: .plain, target: self, action: #selector(showStoorage))
        let tapGestureRec = UITapGestureRecognizer(target: self, action: #selector(selectImage))
        imgview.addGestureRecognizer(tapGestureRec)
        
       setupStyling()
       
       let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
       view.addGestureRecognizer(tapGesture)
    }
    
    @objc func showStoorage() {
     performSegue(withIdentifier: "toadminlist", sender: nil)
    }
    @objc func selectImage() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true)
  
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            imgview.image = image
            imgview.contentMode = .scaleAspectFill
            imgview.clipsToBounds = true
            selectedImage.accept(image)
        }
        dismiss(animated: true)
    }
    
    
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
    
    
    private func setupStyling() {
           // Genel Ekran Ayarları
           view.backgroundColor = .black

           // MARK: - UIImageView Şekillendirme
           imgview.backgroundColor = UIColor(white: 0.15, alpha: 1) // Koyu gri arka plan
           imgview.layer.cornerRadius = 10 // Köşeleri yuvarla
           imgview.clipsToBounds = true // Köşelerin taşmasını engelle
           
           // Şık bir "ekle" ikonu ekle
           let addIcon = UIImage(systemName: "plus.circle.fill")?
               .withConfiguration(UIImage.SymbolConfiguration(pointSize: 40, weight: .bold)) // İkonu büyüt ve kalınlaştır
               .withTintColor(.white, renderingMode: .alwaysOriginal)
           imgview.image = addIcon
           imgview.contentMode = .center // İkonu merkeze al
           imgview.isUserInteractionEnabled = true // Tıklanabilir yap

           // MARK: - UITextField'ları Şekillendirme
           styleTextField(productname, placeholder: "Ürün Adı")
           styleTextField(price, placeholder: "Fiyat")
           styleTextField(category, placeholder: "Kategori")
           styleTextField(brand, placeholder: "Marka")

           // MARK: - UITextView Şekillendirme
           descriptiontextview.backgroundColor = UIColor(white: 0.1, alpha: 1)
           descriptiontextview.layer.cornerRadius = 8
           descriptiontextview.textColor = .white
           descriptiontextview.font = UIFont.systemFont(ofSize: 16)
           
           // Placeholder metni için (TextView'in kendisinde yok, bu yüzden bir UILabel ekliyoruz)
           descriptiontextview.addSubview(placeholderLabel)
           
           // Placeholder'ı konumlama
           NSLayoutConstraint.activate([
               placeholderLabel.topAnchor.constraint(equalTo: descriptiontextview.topAnchor, constant: 8),
               placeholderLabel.leadingAnchor.constraint(equalTo: descriptiontextview.leadingAnchor, constant: 5)
           ])
           
           // MARK: - UIButton Şekillendirme
           addbutton.backgroundColor = .systemBlue // Vurgu rengi olarak mavi
           addbutton.setTitleColor(.white, for: .normal)
           addbutton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
           addbutton.layer.cornerRadius = 12
       }
       
       // Ortak UITextField stilini belirleyen yardımcı fonksiyon
       private func styleTextField(_ textField: UITextField, placeholder: String) {
           textField.backgroundColor = UIColor(white: 0.1, alpha: 1)
           textField.layer.cornerRadius = 8
           textField.borderStyle = .none
           textField.textColor = .white
           
           // Placeholder metnini özelleştirme
           textField.attributedPlaceholder = NSAttributedString(
               string: placeholder,
               attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
           )
           
           // Metnin kenarlardan boşluk bırakması için
           textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
           textField.leftViewMode = .always
       }
    

    @IBAction func addButtonClicked(_ sender: Any) {
        guard let name = productname.text, !name.isEmpty,
              let priceValue = Double(price.text ?? "0"),
              let desc = descriptiontextview.text,
              let image = imgview.image else {
                  print("Eksik bilgi var")
                  return
              }

        viewModel.addItem(
            name: name,
            price: priceValue,
            description: desc,
            category: category.text ?? "",
            brand: brand.text ?? "",
            inStock: true,
            image: image
        )
        .subscribe(onNext: {_ in 
            print("Ürün başarıyla eklendi")
            self.clearForm()
        }, onError: { error in
            print("Hata: \(error.localizedDescription)")
        })
        .disposed(by: disposeBag)
    }

    // Yardımcı fonksiyon: Formu sıfırlamak için
    private func clearForm() {
        productname.text = ""
        price.text = ""
        descriptiontextview.text = ""
        category.text = ""
        brand.text = ""
        imgview.image = UIImage(systemName: "plus.circle.fill")?
            .withConfiguration(UIImage.SymbolConfiguration(pointSize: 40, weight: .bold))
            .withTintColor(.white, renderingMode: .alwaysOriginal)
        imgview.contentMode = .center
        placeholderLabel.isHidden = false
    }

    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}
