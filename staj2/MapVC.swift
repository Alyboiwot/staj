//
//  MapVC.swift
//  staj2
//
//  Created by Ali Ünal UZUNÇAYIR on 5.08.2025.
//
import FirebaseAuth
import MapKit
import UIKit
import FirebaseFirestore
class MapVC: UIViewController,MKMapViewDelegate  {
    
    
    @IBOutlet weak var mapview: MKMapView!
    @IBOutlet weak var commentbox: UITextField!
    @IBOutlet weak var placenamebox: UITextField!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapview.delegate = self
   
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(chooseLocation(gestureRecognizer:)))
        gestureRecognizer.minimumPressDuration = 1.0 // 1 saniye basınca pin koy
        mapview.addGestureRecognizer(gestureRecognizer)
        
    }
    
    @IBAction func UploadButtonClicked(_ sender: Any) {
        
        if commentbox.text != "" && placenamebox.text != "" {
            let annotations = mapview.annotations
            if let annotation = annotations.first as? MKPointAnnotation {
                let latitude = annotation.coordinate.latitude
                let longitude = annotation.coordinate.longitude
                
                let db = Firestore.firestore()
                let userİD = Auth.auth().currentUser?.uid
                if let userid = userİD {
                    let userData : [String: Any] = ["comment" :self.commentbox.text! , "placename" : self.placenamebox.text!,"latitude": latitude,
                                                    "longitude": longitude]
                    db.collection("users").document(userid).setData(userData)
                    
                }
                //aly@swift.com
            }
          
        }
        
        
        
        
    }
   func makeAlert(title: String, message: String) {
       let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
       let button = UIAlertAction(title: "OK", style: UIAlertAction.Style.default
       )
       alert.addAction(button)
       present(alert, animated: true)
    }
    @objc func chooseLocation(gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .began {
            let touchedPoint = gestureRecognizer.location(in: mapview)
            let touchedCoordinates = mapview.convert(touchedPoint, toCoordinateFrom: mapview)
            
            // Haritadaki eski pinleri kaldırmak istersen:
            mapview.removeAnnotations(mapview.annotations)
            
            // Yeni pin (annotation) oluştur
            let annotation = MKPointAnnotation()
            annotation.coordinate = touchedCoordinates
            annotation.title = placenamebox.text ?? "Yer"
            annotation.subtitle = commentbox.text ?? ""
            mapview.addAnnotation(annotation)
        }
    }

}
