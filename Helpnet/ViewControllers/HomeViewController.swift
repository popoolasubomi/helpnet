//
//  HomeViewController.swift
//  Helpnet
//
//  Created by Subomi Popoola on 4/24/22.
//

import UIKit
import MapKit
import Parse

class HomeViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    
    @IBOutlet weak var currentLocationLbl: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var requestLabel: UILabel!
    @IBOutlet weak var mainLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    var mkCurrentLoc: MKMapItem!
    var selectedPin: MKPlacemark? = nil
    
    var lightPants: Bool!
    var lightShirts: Bool!
    var mediumShirts: Bool!
    var mediumPants: Bool!
    var thickPants: Bool!
    var thickShirts: Bool!
    var temp: Double!
    
    var weatherKey = "ad0dc5ae4cc447cb0cb8d0552db5a415"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getUserClothType()
        setMapView()
        getCurrentLocation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getUserClothType()
        setMapView()
        getCurrentLocation()
    }
    
    
    @IBAction func didTapSearch(_ sender: Any) {
        self.performSegue(withIdentifier: "searchsegue", sender: nil)
    }
    
    func getUserClothType() {
        let user = PFUser.current()
        user?.fetchInBackground(block: { object, error in
            if error == nil {
                self.lightPants = object?.object(forKey: "lightPants") as! Bool
                self.lightShirts = object?.object(forKey: "lightShirts") as! Bool
                self.mediumPants = object?.object(forKey: "mediumPants") as! Bool
                self.mediumShirts = object?.object(forKey: "mediumShirts") as! Bool
                self.thickPants = object?.object(forKey: "thickPants") as! Bool
                self.thickShirts = object?.object(forKey: "thickShirts") as! Bool
            }
        })
    }
    
    func getWeather(lat: String, long: String) {
        let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(long)&appid=\(weatherKey)")
        let request = URLRequest(url: url!)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: .main)
        let task = session.dataTask(with: request) { data, response, error in
            if error == nil {
                if let responseDictionary = try! JSONSerialization.jsonObject(
                    with: data!, options:[]) as? NSDictionary {
                    let weather = responseDictionary["weather"] as! [[String: Any]]
                    self.mainLbl.text = weather[0]["main"] as! String
                    self.descriptionLbl.text = weather[0]["description"] as! String
                    let main = responseDictionary["main"] as! [String: Any]
                    self.temp = main["temp"] as! Double
                    self.temp -= 273.15
                    self.temp /= 5
                    self.temp *= 9
                    self.temp += 32
                    self.temperatureLabel.text = String(format: "%.2f F", self.temp)
                    if self.temp < 45.0 {
                        self.requestLabel.text = "You will need thick Clothes"
                    } else if self.temp < 70 {
                        self.requestLabel.text = "You will need Medium Feel Clothes"
                    } else {
                        self.requestLabel.text = "You will need light Clothes"
                    }
                }
            }
        }
        task.resume()
    }
    
    func getCurrentLocation() {
       locationManager.delegate = self
       locationManager.desiredAccuracy = kCLLocationAccuracyBest
       locationManager.requestWhenInUseAuthorization()
       locationManager.requestLocation()
    }
    
    func setMapView() {
        mapView.showsUserLocation = true
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.delegate = self
        mapView.layer.cornerRadius = 10.0
    }

   // Adding Annotated Markers to MapView
   func addMarker(location: CLLocation) {
       let mkAnnotation: MKPointAnnotation = MKPointAnnotation()
       mkAnnotation.coordinate = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
       mapView.addAnnotation(mkAnnotation)
   }
       
   // Handle incoming location events.
   func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
       if let location = locations.first {
           let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
               let region = MKCoordinateRegion(center: location.coordinate, span: span)
               mapView.setRegion(region, animated: true)
           let lat = String(describing: location.coordinate.latitude)
           let long = String(describing: location.coordinate.longitude)
           self.getWeather(lat: lat, long: long)
               coordinatesToAddress(Latitude: location.coordinate.latitude,
                                    Longitude: location.coordinate.longitude)
       }
   }
   
   // Handle authorization for the location manager.
   private func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
       if status == .authorizedWhenInUse {
               locationManager.requestLocation()
       }
   }
   
   // Handle location manager errors.
   func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
     locationManager.stopUpdatingLocation()
     print("Error: \(error)")
   }
   
   // Converting User's Coordinates to Address
   func coordinatesToAddress(Latitude: Double, Longitude: Double) {
       let geoCoder: CLGeocoder = CLGeocoder()
       let loc: CLLocation = CLLocation(latitude: Latitude, longitude: Longitude)
       geoCoder.reverseGeocodeLocation(loc, completionHandler: {(placemarks, error) in
           if (error != nil) {
               print("reverse geodcode fail: \(error!.localizedDescription)")
           }
           let pm = placemarks! as [CLPlacemark]
           if pm.count > 0 {
               let pm = placemarks![0]
               var addressString : String = ""
               if pm.subLocality != nil {
                   addressString = addressString + pm.subLocality! + ", " }
               if pm.thoroughfare != nil {
                   addressString = addressString + pm.thoroughfare! + ", "
               }
               if pm.locality != nil {
                   addressString = addressString + pm.locality! + ", "
               }
               if pm.country != nil {
                   addressString = addressString + pm.country! + ", "
               }
               if pm.postalCode != nil {
                   addressString = addressString + pm.postalCode! + " "
               }
               self.currentLocationLbl.text = addressString
           }
       })
   }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let vc = segue.destination as! SearchViewController
        vc.temp = self.temp
    }
}
