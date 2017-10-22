//
//  ViewController.swift
//  weatherApp
//
//  Created by leo  luo on 2017-10-05.
//  Copyright © 2017 tk.onebite.firstClass. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var weatherCoditionImageView: UIImageView!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var menuViewHeightConstrant: NSLayoutConstraint!
    
    var locationManager: CLLocationManager = CLLocationManager()
    let pin = MKPointAnnotation()
    var menuShow: Bool = false
    var currentWeather: Weather?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        mapView.showsUserLocation = true
        mapView.delegate = self
        menuView.layer.cornerRadius = 10
        menuViewHeightConstrant.constant = 0
        locationManager.requestLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let coordinate = locations.first?.coordinate else { return }
        APIService.parseLatAndLongToFetchWeather(lat: CGFloat(coordinate.latitude), long: CGFloat(coordinate.longitude)) { [weak self](weather) in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                strongSelf.currentWeather = weather
                strongSelf.showMenu()
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
    
    @IBAction func segmentControlTapped(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            mapView.mapType = .standard
        }else if sender.selectedSegmentIndex == 1 {
            mapView.mapType = .satellite
        }else if sender.selectedSegmentIndex == 2 {
            mapView.mapType = .hybrid
        }
    }
    
    @IBAction func mapViewTapped(_ sender: UITapGestureRecognizer) {
        hideMenu()
        // get touch point
        let touchPoint = sender.location(in: mapView)
        // convert touch point to coordinate
        let coordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        //create a pin
        //let pin = MKPointAnnotation()  //we don't want more than one pin on the map, so we set it as a global var instead of a local var
        //set where to display the pin
        pin.coordinate = coordinate
        //add the pin to the map
        mapView.addAnnotation(pin)
        //{(weather) in ...} means this function return a Weather obj and we name it weather
        APIService.parseLatAndLongToFetchWeather(lat: CGFloat(coordinate.latitude), long: CGFloat(coordinate.longitude)) { [weak self](weather) in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                strongSelf.currentWeather = weather
                strongSelf.showMenu()
            }
        }
    }
    

    // call when pin is selected to show the menu, this function is part of the delegate
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
    }
    
    func showMenu() {
        guard let weather = currentWeather else {
            return
        }
        if !self.menuShow {
            menuViewHeightConstrant.constant = 150
            UIView.animate(withDuration: 1) {
                self.menuView.alpha = 1
                self.view.layoutIfNeeded()
                self.menuShow = true
            }
        }
        weatherCoditionImageView.image = imageFor(condition: weather.condition ?? "")
        cityNameLabel.text = weather.cityName
        let newTemperature = (weather.temperature ?? 0) - 273.15
        temperatureLabel.text = "\(newTemperature) °C"
    }
    
    @IBAction func swipeDownMenu(_ sender: UISwipeGestureRecognizer) {
        hideMenu()
    }
    
    func hideMenu() {
        self.menuView.alpha = 0
        menuViewHeightConstrant.constant = 0
//        UIView.animate(withDuration: 1) {
//            //force the view to update its layout immediately
//            self.view.layoutIfNeeded()
//            
//        }
        self.menuShow = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let arViewController = segue.destination as! ARKitSceneKitViewController
        if let weather = currentWeather {
            arViewController.weather = weather
        }
    }
}

extension ViewController {
    
    func imageFor(condition: String) -> UIImage? {
        switch condition {
        case "Rain":
            return UIImage(named: "Rain")
        case "Clouds":
            return UIImage(named: "Cloud")
        case "Clear":
            return UIImage(named: "Sun")
        case "Snow":
            return UIImage(named: "Snow")
        case "Mist":
            return UIImage(named: "Fog")
        case "Thunderstorm":
            return UIImage(named: "Storm")
        default:
            return nil
        }
    }
    
}

