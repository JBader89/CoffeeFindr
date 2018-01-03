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
import SDWebImage
import FoursquareAPIClient

class CoffeeShopController: UIViewController {
    @IBOutlet weak var coffeeShopImageView: UIImageView!
    
    var coffeeShop: CoffeeShop?
    var locValue: CLLocationCoordinate2D?
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = coffeeShop?.name
        let backItem = UIBarButtonItem()
        backItem.title = ""
        self.navigationController!.navigationBar.topItem!.backBarButtonItem = backItem
        getCoffeeShopDetails()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getCoffeeShopDetails(){
        let parameter: [String: String] = [
            "VENUE_ID": (coffeeShop?.id)!
        ];
        
        let client = FoursquareAPIClient(clientId: "GRIFNKPCDBBZDZGHGCUQV4QYPVVVWBVTOSWIHDWRACW4AHD1", clientSecret: "4CVVZTW55PDL5IUYO1W35OZ5KZA4O2Q01LZPDMGSIFTQU25Y")
        
        let path = "venues/" + (coffeeShop?.id)!
        client.request(path: path, parameter: parameter) { result in
            switch result {
            case let .success(data):
                let json = JSON(data: data)
                self.updateCoffeeShopPhoto(json: json)
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
    
    func updateCoffeeShopPhoto(json: JSON){
        if let prefix = json["response"]["venue"]["bestPhoto"]["prefix"].string, let suffix = json["response"]["venue"]["bestPhoto"]["suffix"].string {
            var string = (prefix + suffix)
            string.insert("5", at: string.index(string.startIndex, offsetBy: 33))
            string.insert("0", at: string.index(string.startIndex, offsetBy: 34))
            string.insert("0", at: string.index(string.startIndex, offsetBy: 35))
            string.insert("x", at: string.index(string.startIndex, offsetBy: 36))
            string.insert("5", at: string.index(string.startIndex, offsetBy: 37))
            string.insert("0", at: string.index(string.startIndex, offsetBy: 38))
            string.insert("0", at: string.index(string.startIndex, offsetBy: 39))

            coffeeShopImageView.sd_setImage(with: URL(string: string.replacingOccurrences(of: "\"", with: "", options: NSString.CompareOptions.literal, range:nil)), placeholderImage: UIImage(named: ""))
        }
    }
}
