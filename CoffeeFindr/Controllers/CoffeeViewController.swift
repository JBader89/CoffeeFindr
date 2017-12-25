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
            print("User allowed us to access location")
            //do whatever init activities here.
        }
        else if status == .authorizedAlways {
            print("User allowed us to always access location")
            //do whatever init activities here.
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        
        let parameter: [String: String] = [
            "ll": "\(locValue.latitude), \(locValue.longitude)",
            "limit": "10",
            ];
        
        let client = FoursquareAPIClient(clientId: "GRIFNKPCDBBZDZGHGCUQV4QYPVVVWBVTOSWIHDWRACW4AHD1", clientSecret: "4CVVZTW55PDL5IUYO1W35OZ5KZA4O2Q01LZPDMGSIFTQU25Y")
        
        client.request(path: "venues/search", parameter: parameter) { result in
            switch result {
            case let .success(data):
                // parse the JSON data with NSJSONSerialization or Lib like SwiftyJson
                // e.g. {"meta":{"code":200},"notifications":[{"...
                let json = try! JSONSerialization.jsonObject(with: data, options: [])
                print(json)
                
            case let .failure(error):
                // Error handling
                switch error {
                case let .connectionError(connectionError):
                    print(connectionError)
                case let .apiError(apiError):
                    print(apiError.errorType)   // e.g. endpoint_error
                    print(apiError.errorDetail) // e.g. The requested path does not exist.
                }
            }
        }
        locationManager.stopUpdatingLocation()
    }
    
}
