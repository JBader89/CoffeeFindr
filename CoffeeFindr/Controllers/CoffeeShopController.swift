//
//  CoffeeShopController.swift
//  CoffeeFindr
//
//  Created by Jeremy Bader on 12/26/17.
//  Copyright © 2017 Jeremy Bader. All rights reserved.
//

import UIKit
import CoreLocation
import SwiftyJSON
import FoursquareAPIClient

class CoffeeShopController: UIViewController {
    var coffeeShop: CoffeeShop?
    var locValue: CLLocationCoordinate2D?
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = coffeeShop?.name
        navigationItem.backBarButtonItem?.title = "Back"
        getNearbyCoffeeShops()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getNearbyCoffeeShops(){
        let parameter: [String: String] = [
            "VENUE_ID": (coffeeShop?.id)!
        ];
        
        let client = FoursquareAPIClient(clientId: "GRIFNKPCDBBZDZGHGCUQV4QYPVVVWBVTOSWIHDWRACW4AHD1", clientSecret: "4CVVZTW55PDL5IUYO1W35OZ5KZA4O2Q01LZPDMGSIFTQU25Y")
        
        let path = "venues/" + (coffeeShop?.id)!
        client.request(path: path, parameter: parameter) { result in
            switch result {
            case let .success(data):
                let json = JSON(data: data)
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
}
