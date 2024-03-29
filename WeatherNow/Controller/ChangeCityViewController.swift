//
//  ChangeCityViewController.swift
//  WeatherNow
//
//  Created by Khairul Bashar on 7/6/19.
//  Copyright © 2019 Khairul Bashar. All rights reserved.
//

import UIKit

class ChangeCityViewController: UIViewController {
    
    //Declare the delegate variable here:
    weak var delegate : ChangeCityDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //This is the pre-linked IBOutlets to the text field:
    @IBOutlet weak var changeCityTextField: UITextField!
    
    
    //This is the IBAction that gets called when the user taps on the "Get Weather" button:
    @IBAction func getWeatherPressed(_ sender: AnyObject) {
        
        
        
        //1 Get the city name the user entered in the text field
        let cityName = changeCityTextField.text!
        
        
        //2 If we have a delegate set, call the method userEnteredANewCityName
        delegate?.userDesiredCityName(cityName: cityName)
        
        
        //3 dismiss the Change City View Controller to go back to the WeatherViewController
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
        
    }
    
}
