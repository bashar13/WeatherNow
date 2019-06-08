//
//  ViewController.swift
//  WeatherNow
//
//  Created by Khairul Bashar on 7/6/19.
//  Copyright © 2019 Khairul Bashar. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, CLLocationManagerDelegate {

    //Constants
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "a14f88165af7c44667ab7a724551c4a1"
    /***Get your own App ID at https://openweathermap.org/appid ****/
    
    //initialize a location manager object
    let locationManager = CLLocationManager()
    let weatherDataModel = WeatherDataModel()
    
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var tempImage: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //Set up location manager
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization() //request for user permission to use gps
        locationManager.startUpdatingLocation() //start getting location
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "City", style: .plain, target: self, action: #selector(navigationBarRightButtonTapped))
        
        
    }
    
    @objc func navigationBarRightButtonTapped () {
        performSegue(withIdentifier: "changeCity", sender: nil)
    }
    
    // MARK: Location Manager delegate methods
    
    //callback method for the startUpdatingLocation() with success
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location  = locations[locations.count - 1]
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            print(location.coordinate.longitude)
            print(location.coordinate.latitude)
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            
            //initialize the parameters for the open weather app API
            let params: [String : String] = ["lat" : String(lat), "lon" : String(lon), "appid" : APP_ID]
            
            getWeatherData(url: WEATHER_URL, parameters: params)
        }
    }
    
    
    
    //callback method for the startUpdatingLocation() with fail
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        cityLabel.text = "Location Unavailable"
    }
    
    // MARK: Networking methods (request weather data)
    
    func getWeatherData(url: String, parameters: [String: String]) {
        Alamofire.request(url, method : .get, parameters: parameters).responseJSON {
            response in
            if response.result.isSuccess {
                print("Success")
                let weatherJSON: JSON = JSON(response.result.value!)
                self.updateWeatherData(json: weatherJSON)
                
            } else {
                print("Error \(response.result.error)")
                self.cityLabel.text = "Connection issues"
            }
        }
    }
    
    // MARK: JSON Parsing
    
    func updateWeatherData(json: JSON) {
        if let tempResult = json["main"]["temp"].double {
            weatherDataModel.temperature = Int(tempResult - 273.15)
            weatherDataModel.city = json["name"].stringValue
            weatherDataModel.condition = json["weather"][0]["id"].intValue
            weatherDataModel.weatherIconName = weatherDataModel.updateWeatherIcon(condition: weatherDataModel.condition)
            
            updateUIwithWeatherData()
        }
        else {
            cityLabel.text = "Weather Unavailable"
        }
    }
    
    // MARK: UI Update methods
    
    func updateUIwithWeatherData() {
        cityLabel.text = weatherDataModel.city
        tempLabel.text = "\(weatherDataModel.temperature)°"
        tempImage.image = UIImage(named:weatherDataModel.weatherIconName)
    }
}

