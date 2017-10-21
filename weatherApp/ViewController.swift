//
//  ViewController.swift
//  weatherApp
//
//  Created by leo  luo on 2017-10-05.
//  Copyright © 2017 tk.onebite.firstClass. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var menuView: UIView!
    var menuShow: Bool = false
    var currentWeather: Weather?
    @IBOutlet weak var weatherCoditionImageView: UIImageView!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    var locationManager: CLLocationManager = CLLocationManager()
    let pin = MKPointAnnotation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestWhenInUseAuthorization()
        mapView.showsUserLocation = true
        locationManager.startUpdatingLocation()
        mapView.delegate = self
        menuView.layer.cornerRadius = 10
        menuViewHeightConstrant.constant = 0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
//        let pin = MKPointAnnotation()
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
    
    @IBOutlet weak var menuViewHeightConstrant: NSLayoutConstraint!
    // call when pin is selected to show the menu, this function is part of the delegate
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
    }
    
    func showMenu() {
        guard let weather = currentWeather else {
            return
        }
        if !self.menuShow {
            menuViewHeightConstrant.constant = 200
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

