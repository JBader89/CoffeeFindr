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
    @IBOutlet weak var addressLabel: UITextView!
    @IBOutlet weak var phoneNumberLabel: UITextView!
    @IBOutlet weak var daysLabel: UILabel!
    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var addressView: UIView!
    @IBOutlet weak var phoneNumberView: UIView!
    @IBOutlet weak var hoursView: UIView!
    
    var coffeeShop: CoffeeShop?
    var locValue: CLLocationCoordinate2D?
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = coffeeShop?.name
        let backItem = UIBarButtonItem()
        backItem.title = ""
        self.navigationController!.navigationBar.topItem!.backBarButtonItem = backItem
        
        addressView.layer.addBorder(edge: UIRectEdge.top, color: UIColor.lightGray, thickness: 1.0)
        phoneNumberView.layer.addBorder(edge: UIRectEdge.top, color: UIColor.lightGray, thickness: 1.0)
        hoursView.layer.addBorder(edge: UIRectEdge.top, color: UIColor.lightGray, thickness: 1.0)
        hoursView.layer.addBorder(edge: UIRectEdge.bottom, color: UIColor.lightGray, thickness: 1.0)
        
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
                
                print(json)
                
                if let description = json["response"]["venue"]["description"].string
                {
                    self.descriptionTextView.text = description
                } else {
                    self.descriptionTextView.text = "No Description Available"
                }
                
                let addressLabel1 = json["response"]["venue"]["location"]["formattedAddress"][0].string!
                let addressLabel2 = json["response"]["venue"]["location"]["formattedAddress"][1].string!
                let addressLabel3 = json["response"]["venue"]["location"]["formattedAddress"][2].string!
                self.addressLabel.text = addressLabel1 + "\n" + addressLabel2 + "\n" + addressLabel3
                
                self.phoneNumberLabel.text = json["response"]["venue"]["contact"]["formattedPhone"].string!
                
                self.daysLabel.text = ""
                self.hoursLabel.text = ""
                for i in 0...json["response"]["venue"]["hours"]["timeframes"].array!.count - 1 {
                    self.daysLabel.text = self.daysLabel.text! + json["response"]["venue"]["hours"]["timeframes"][i]["days"].string! + "\n"
                    self.hoursLabel.text = self.hoursLabel.text! + json["response"]["venue"]["hours"]["timeframes"][i]["open"][0]["renderedTime"].string! + "\n"
                }
                
                self.updateCoffeeShopPhoto(json: json)
                
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

extension CALayer {
    
    func addBorder(edge: UIRectEdge, color: UIColor, thickness: CGFloat) {
        
        let border = CALayer();
        
        switch edge {
        case UIRectEdge.top:
            border.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: thickness)
            break
        case UIRectEdge.bottom:
            border.frame = CGRect(x:0, y:self.frame.height - thickness, width:self.frame.width, height:thickness)
            break
        case UIRectEdge.left:
            border.frame = CGRect(x:0, y:0, width: thickness, height: self.frame.height)
            break
        case UIRectEdge.right:
            border.frame = CGRect(x:self.frame.width - thickness, y: 0, width: thickness, height:self.frame.height)
            break
        default:
            break
        }
        
        border.backgroundColor = color.cgColor;
        
        self.addSublayer(border)
    }
    
}
