//
//  AdminProductViewModel.swift
//  EticaretApp
//
//  Created by Ali Ünal UZUNÇAYIR on 19.08.2025.
//

import Foundation
import RxSwift
import RxCocoa
import FirebaseStorage
import FirebaseFirestore
import UIKit

class ProductViewModel {
    let product = BehaviorRelay<[Product]>(value: [])
    private var allProducts: [Product] = []

    let name : BehaviorRelay<String> = BehaviorRelay(value: "")
    let price : BehaviorRelay<Double> = BehaviorRelay(value: 0)
    let description : BehaviorRelay<String> = BehaviorRelay(value: "")
    let imageURL : BehaviorRelay<URL?> = BehaviorRelay(value: nil)
    let category : BehaviorRelay<String> = BehaviorRelay(value: "")
    let inStock : BehaviorRelay<Bool> = BehaviorRelay(value: false)
    let brand : BehaviorRelay<String> = BehaviorRelay(value: "")
    
    func addItem(name: String,
                 price: Double,
                 description: String,
                 category: String,
                 brand: String,
                 inStock: Bool,
                 image: UIImage) -> Observable<Bool> {
        
        return Observable.create { observer in
            guard !name.isEmpty,
                  price > 0,
                  !description.isEmpty,
                  !category.isEmpty else {
                observer.onNext(false)
                observer.onCompleted()
                return Disposables.create()
            }
            
            // Upload image to Firebase Storage
            let storageRef = Storage.storage().reference().child("product_images/\(UUID().uuidString).jpg")
            if let imageData = image.jpegData(compressionQuality: 0.8) {
                storageRef.putData(imageData, metadata: nil) { _, error in
                    if let e = error {
                        print("Resim yüklenemedi: \(e.localizedDescription)")
                        observer.onNext(false)
                        observer.onCompleted()
                        return
                    }
                    
                    storageRef.downloadURL { url, error in
                        guard let downloadURL = url, error == nil else {
                            observer.onNext(false)
                            observer.onCompleted()
                            return
                        }
                        
                        let productData: [String: Any] = [
                            "name": name,
                            "price": price,
                            "description": description,
                            "imageUrl": downloadURL.absoluteString,
                            "category": category,
                            "inStock": inStock,
                            "brand": brand
                        ]
                        
                        Firestore.firestore().collection("products").addDocument(data: productData) { error in
                            if let e = error {
                                print("ürün eklenemedi \(e.localizedDescription)")
                                observer.onNext(false)
                            } else {
                                print("ürün başarıyla eklendi")
                                observer.onNext(true)
                            }
                            observer.onCompleted()
                        }
                    }
                }
            } else {
                observer.onNext(false)
                observer.onCompleted()
            }
            
            return Disposables.create()
        }
    }
    
    func deleteProduct(_ product: Product) -> Observable<Bool> {
        return Observable.create { observer in
            Firestore.firestore().collection("products").document(product.id).delete { err in
                if let error = err {
                    print("silinemedi: \(error.localizedDescription)")
                    observer.onNext(false)
                } else {
                    print("başarıyla silindi")
                    self.fetchProduct()
                    observer.onNext(true)
                }
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
    
    func UpdateProduct(_ product: Product) -> Observable<Bool> {
        return Observable.create { observer in
            // Güvenli unwrap ve veri kontrolü
            guard !product.name.isEmpty,
                  product.price > 0,
                  !product.description.isEmpty,
                  !product.category.isEmpty,
                  let brand = product.brand else {
                observer.onNext(false)
                observer.onCompleted()
                return Disposables.create()
            }
            let updateData: [String: Any] = [
                "name": product.name,
                "price": product.price,
                "description": product.description,
                "brand": brand,
                "imageUrl": product.imageUrl,
                "category": product.category
            ]
            Firestore.firestore().collection("products").document(product.id).updateData(updateData) { err in
                if let error = err {
                    print("Güncellenemedi: \(error.localizedDescription)")
                    observer.onNext(false)
                } else {
                    print("Ürün başarıyla güncellendi")
                    observer.onNext(true)
                }
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
    
    
    
    
    
    func loadProductForUpdate(productId: String) {
        let docRef = Firestore.firestore().collection("products").document(productId)
        
        docRef.getDocument { snapshot, error in
            guard let data = snapshot?.data(), error == nil else {
                print("Ürün alınamadı: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            // Firestore'dan gelen verileri BehaviorRelay’lere aktar
            self.name.accept(data["name"] as? String ?? "")
            self.price.accept(data["price"] as? Double ?? 0)
            self.description.accept(data["description"] as? String ?? "")
            self.brand.accept(data["brand"] as? String ?? "")
            self.category.accept(data["category"] as? String ?? "")
            self.inStock.accept(data["inStock"] as? Bool ?? false)
            
            // imageURL için String -> URL dönüşümü
            if let urlString = data["imageUrl"] as? String, let url = URL(string: urlString) {
                self.imageURL.accept(url)
            } else {
                self.imageURL.accept(nil)
            }
        }
    }
    
    func fetchProduct() {
        Firestore.firestore().collection("products").getDocuments { snapshot, error in
            
            // Eğer snapshot alınamazsa veya bir hata varsa işlemden çık.
            guard let documents = snapshot?.documents, error == nil else {
                print("Error fetching documents: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            // `compactMap` ile her bir dökümanı işleyip `Product` nesnesine dönüştür.
            // Eğer `Product`'ın failable initializer'ı (init?) başarısız olursa, `compactMap`
            // o dökümanı otomatik olarak atar (nil'leri filtreler).
            let fetchedProducts = documents.compactMap { document in
                return Product(id: document.documentID, data: document.data())
            }
            
            // Elde edilen ürün listesini BehaviorRelay'e aktar.
            self.allProducts = fetchedProducts
            self.product.accept(fetchedProducts)
        }
    }
    
    func applyFilter(minPrice: Double?, maxPrice: Double?, brand: String?) {
        var filteredProducts = allProducts
        
        if let min = minPrice {
            filteredProducts = filteredProducts.filter { $0.price >= min }
        }
        
        if let max = maxPrice {
            filteredProducts = filteredProducts.filter { $0.price <= max }
        }
        
        if let brandFilter = brand, !brandFilter.isEmpty {
            filteredProducts = filteredProducts.filter { $0.brand?.localizedCaseInsensitiveContains(brandFilter) ?? false }
        }
        
        self.product.accept(filteredProducts)
    }
    
    func addToCart(product: Product) {
        // Sepete ekleme işlemi için gerekli kod buraya eklenebilir.
        // Örneğin, Firestore'da "cart" koleksiyonuna ekleme yapılabilir.
        // Bu fonksiyon boş olarak bırakılmıştır veya uygulama ihtiyaçlarına göre doldurulabilir.
    }
}
