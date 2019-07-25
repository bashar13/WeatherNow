//
//  ChangeCityDelegate.swift
//  WeatherNow

//  A protocol to transfer data backward between view controllers

//  Created by Khairu Bashar on 8/6/19.
//  Copyright © 2019 Khairul Bashar. All rights reserved.
//

import UIKit

protocol ChangeCityDelegate: class {
    func userDesiredCityName(cityName: String)
}
