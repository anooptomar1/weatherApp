//
//  Weather.swift
//  weatherApp
//
//  Created by leo  luo on 2017-10-16.
//  Copyright © 2017 tk.onebite.firstClass. All rights reserved.
//

import Foundation
import MapKit

class Weather {
    
    var coordinate: CLLocationCoordinate2D
    var cityName: String?
    var condition: String?
    var temperature: Float?
    
    init(coordinate: CLLocationCoordinate2D, json: [String: Any]) {
        self.coordinate = coordinate
        self.cityName = json["name"] as? String ?? ""
        let weathers = json["weather"] as? [AnyObject] ?? [AnyObject]()
        self.condition = weathers.first?["main"] as? String ?? ""
        let main = json["main"] as? [String: Any]
        self.temperature = main?["temp"] as? Float
    }
    
}
