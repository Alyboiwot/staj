//
//  UploadVC.swift
//  staj1
//
//  Created by Ali Ünal UZUNÇAYIR on 4.08.2025.
//

import UIKit
import  FirebaseStorage
class UploadVC: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    var userPhotos : [URL] = []
    
    
    @IBOutlet weak var userimage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //imageview a gestureRecognizer ekledim
        userimage.image = UIImage(named: "select")
        userimage.isUserInteractionEnabled = true
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        userimage.addGestureRecognizer(gesture)

    }
    
    //firebase Storarage işleri yapılacak
    @IBAction func upladClicked(_ sender: Any) {
        guard let image = userimage.image,
              let imageData = image.jpegData(compressionQuality: 0.8) else {
            makeAlert(title: "Hata", message: "Resim bulunamadı veya dönüştürülemedi.")
            return
        }

        let storage = Storage.storage()
        let storageReference = storage.reference()
        let imageID = UUID().uuidString
        let imageReference = storageReference.child("images/\(imageID)")

        imageReference.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                self.makeAlert(title: "Hata", message: "Yükleme hatası: \(error.localizedDescription)")
                return
            }
// SDWeb image ile Libraryvc de alıcam ve sadece o kullanıcının verilerini göstericem
            imageReference.downloadURL { url, error in
                if let error = error {
                    self.makeAlert(title: "Hata", message: "URL alınamadı: \(error.localizedDescription)")
                } else if let url = url {
                    self.userPhotos.append(url)
                    self.makeAlert(title: "Başarılı", message: "Fotoğraf başarıyla yüklendi!")
                
                }
            }
        }
    }
    //kullanıcı galerisi açılıp fotoğraf seçicek
    @objc func imageTapped() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true)
    }
    
    // fotoğraf seçildi galeri kapatılıp imageview seçilen foto yapıldı
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as? UIImage
        userimage.image = image
        dismiss(animated: true)
    }
    
    //alert func 
    func makeAlert(title: String, message: String)  {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let button = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(button)
        present(alert, animated: true)
    }
//dizide sakladığım urlleri diğer ekranan verdim orada tableview da kullanılacak
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "libraryvc" {
            if let destinationVC = segue.destination as? LibraryVC {
                destinationVC.photos = userPhotos
            }
        }
    }
    
    
    
    @IBAction func showMyPhotos(_ sender: Any) {
        performSegue(withIdentifier: "libraryvc", sender: nil)
    }

    
}
//aly@swift.com
