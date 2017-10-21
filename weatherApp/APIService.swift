//
//  APIService.swift
//  weatherApp
//
//  Created by leo  luo on 2017-10-16.
//  Copyright © 2017 tk.onebite.firstClass. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class APIService {
    private struct Constants {
        static let weatherAPIKEY = "e6488d923e28644b5519332d6d19eb45"
    }
    
    static public func parseLatAndLongToFetchWeather(lat: CGFloat, long: CGFloat, completion: @escaping ((Weather) -> Void)) {
        let endpointStringURL = String(format: "https://api.openweathermap.org/data/2.5/weather?lat=%f&lon=%f&APPID=%@", lat, long, Constants.weatherAPIKEY)
        if let url = URL(string: endpointStringURL) {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard let data = data else { return }
                do {
                    guard let jsonData = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                        return
                    }
                    completion(Weather(coordinate: CLLocationCoordinate2D(latitude: CLLocationDegrees(lat), longitude: CLLocationDegrees(long)), json: jsonData))
                } catch {
                    print("error")
                }
            }
            task.resume()
        }
        
    }
}
