//
//  CoffeeViewController.swift
//  CoffeeFindr
//
//  Created by Jeremy Bader on 12/25/17.
//  Copyright © 2017 Jeremy Bader. All rights reserved.
//

import UIKit
import CoreLocation
import FoursquareAPIClient

class CoffeeViewController: UIViewController, CLLocationManagerDelegate {

    var locationManager: CLLocationManager!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            print("User allowed us to access their location when app is in use.")
        }
        else if status == .authorizedAlways {
            print("User allowed us to always access their location.")
        }
    }
    
    func getNearbyCoffeeShops(locValue:CLLocationCoordinate2D){
        let parameter: [String: String] = [
            "ll": "\(locValue.latitude), \(locValue.longitude)",
            "limit": "10",
            "categoryId": "4bf58dd8d48988d1e0931735"
            ];
        
        let client = FoursquareAPIClient(clientId: "GRIFNKPCDBBZDZGHGCUQV4QYPVVVWBVTOSWIHDWRACW4AHD1", clientSecret: "4CVVZTW55PDL5IUYO1W35OZ5KZA4O2Q01LZPDMGSIFTQU25Y")
        
        client.request(path: "venues/search", parameter: parameter) { result in
            switch result {
            case let .success(data):
                let json = try! JSONSerialization.jsonObject(with: data, options: [])
                print(json)
                
            case let .failure(error):
                switch error {
                case let .connectionError(connectionError):
                    print(connectionError)
                case let .apiError(apiError):
                    print(apiError.errorType)
                    print(apiError.errorDetail)
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        
        getNearbyCoffeeShops(locValue: locValue)
        
        locationManager.stopUpdatingLocation()
    }
    
}
