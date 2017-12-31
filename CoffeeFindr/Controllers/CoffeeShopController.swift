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
    @IBOutlet weak var coffeeShopImageView: UIImageView!
    
    var coffeeShop: CoffeeShop?
    var locValue: CLLocationCoordinate2D?
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = coffeeShop?.name
        let backItem = UIBarButtonItem()
        backItem.title = ""
        self.navigationController!.navigationBar.topItem!.backBarButtonItem = backItem
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
        let prefix = json["response"]["venue"]["bestPhoto"]["prefix"].string
        let suffix = json["response"]["venue"]["bestPhoto"]["suffix"].string
        var string = (prefix! + suffix!)
        string.insert("o", at: string.index(string.startIndex, offsetBy: 33))
        string.insert("r", at: string.index(string.startIndex, offsetBy: 34))
        string.insert("i", at: string.index(string.startIndex, offsetBy: 35))
        string.insert("g", at: string.index(string.startIndex, offsetBy: 36))
        string.insert("i", at: string.index(string.startIndex, offsetBy: 37))
        string.insert("n", at: string.index(string.startIndex, offsetBy: 38))
        string.insert("a", at: string.index(string.startIndex, offsetBy: 39))
        string.insert("l", at: string.index(string.startIndex, offsetBy: 40))

        let url = URL(string: string.replacingOccurrences(of: "\"", with: "", options: NSString.CompareOptions.literal, range:nil))
        let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
        coffeeShopImageView.image = UIImage(data: data!)
    }
}
