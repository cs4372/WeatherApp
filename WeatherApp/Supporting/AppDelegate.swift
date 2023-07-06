//
//  AppDelegate.swift
//  WeatherApp
//
//  Created by Catherine Shing on 7/4/23.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        let weatherService = WeatherService()
        let weatherViewModel = WeatherViewModel(weatherService: weatherService)
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.backgroundColor = .white
        window?.rootViewController = WeatherViewController(weatherViewModel: weatherViewModel)
        
        return true
    }
}

