//
//  CoffeeShop.swift
//  CoffeeFindr
//
//  Created by Jeremy Bader on 12/25/17.
//  Copyright © 2017 Jeremy Bader. All rights reserved.
//

import UIKit
import SwiftyJSON

class CoffeeShop: NSObject {
    
    // MARK: - Class Enums
    enum Keys: String {
        case id = "id"
        case name = "name"
        case formattedPhone = "formattedPhone"
        case formattedAddress = "formattedAddress"
        case distance = "distance"
        case latitude = "latitude"
        case longitude = "longitude"
        
    }
    
    // MARK: - Properties
    var id: String? = ""
    var name: String? = ""
    var formattedPhone: String? = ""
    var formattedAddress: String? = ""
    var distance: Int?
    var latitude: Double?
    var longitude: Double?
    
    // MARK: - Initialization
    override init() {
        super.init()
    }
    init(id: String, name: String, distance: Int) {
        super.init()
        self.id = id
        self.name = name
        self.distance = distance
    }
    init(json: JSON) {
        super.init()
        self.initWith(json)
    }
    func initWith(_ json: JSON) {
        id = json[Keys.id.rawValue].string ?? ""
        name = json[Keys.name.rawValue].string ?? ""
        formattedAddress = json[Keys.formattedAddress.rawValue].string ?? ""
        formattedPhone = json[Keys.formattedPhone.rawValue].string ?? ""
        latitude = json[Keys.latitude.rawValue].double
        longitude = json[Keys.longitude.rawValue].double
    }
}
