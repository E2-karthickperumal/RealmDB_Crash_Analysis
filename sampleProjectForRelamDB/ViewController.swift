//
//  ViewController.swift
//  sampleProjectForRelamDB
//
// 
// The App crash happening in Realm write section and Realm Data retrivel section

import UIKit
import RealmSwift

class ViewController: UIViewController,MainScreenDelegate {
    
    
    
    
    @IBOutlet weak var weatherTable: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        getWeather()
    }

    
    
    
    func getWeather() {
        weatherConnection.getWeatherData()
        weatherSuccessResponse()
    }
    
    func weatherSuccessResponse() {
        do{
            
            let weatherData = try Realm().objects(WeatherRelam.self)
            // Crash occurs randomly while accessing the retrived data from Realm DB
            weatherTable.text = "City - \(weatherData[0].city)" + "\r" + "Temp - \(weatherData[0].temperature)" + "\r" + "Date - \(weatherData[0].date)" 
            weatherTable.adjustsFontSizeToFitWidth = true
        }catch{
            print("error occured in Realm Data retrivel - \(error)")
        }
    }
    
}

