//
//  CoffeeViewController.swift
//  CoffeeFindr
//
//  Created by Jeremy Bader on 12/25/17.
//  Copyright © 2017 Jeremy Bader. All rights reserved.
//

import UIKit
import CoreLocation
import SwiftyJSON
import FoursquareAPIClient

class CoffeeViewController: UIViewController, CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var coffeeTableView: UITableView!
    
    var locationManager: CLLocationManager!
    let numberOfCoffeeShops: Int = 50
    var coffeeShops: [CoffeeShop]! = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        coffeeTableView.delegate = self
        coffeeTableView.dataSource = self
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfSectionsInTableView section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coffeeShops.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "CoffeeCell")!
        cell.textLabel?.text = coffeeShops[indexPath.row].name
        cell.detailTextLabel?.text = "\(coffeeShops[indexPath.row].distance ?? 0)" + " meters away"
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - CLLocationManagerDelegate
    
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
            "limit": "\(numberOfCoffeeShops)",
            "categoryId": "4bf58dd8d48988d1e0931735"
            ];
        
        let client = FoursquareAPIClient(clientId: "GRIFNKPCDBBZDZGHGCUQV4QYPVVVWBVTOSWIHDWRACW4AHD1", clientSecret: "4CVVZTW55PDL5IUYO1W35OZ5KZA4O2Q01LZPDMGSIFTQU25Y")
        
        client.request(path: "venues/search", parameter: parameter) { result in
            switch result {
            case let .success(data):
                let json = JSON(data: data)
                //print(json["response"]["venues"])
                for i in 0...self.numberOfCoffeeShops {
                    if let name = json["response"]["venues"][i]["name"].string, let distance = json["response"]["venues"][i]["location"]["distance"].int {
                        self.coffeeShops.append(CoffeeShop(name: name, distance: distance))
                    }
                }
                self.coffeeTableView.reloadData()
                
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
