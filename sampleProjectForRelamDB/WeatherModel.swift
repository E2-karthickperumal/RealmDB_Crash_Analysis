//
//  
//
//

import Foundation
import RealmSwift

class WeatherModel : NSObject{
    
    var mainViewdelegate : MainScreenDelegate?

    var weatherData = "{\"data\":{\"url\":\"/ImageGrabberServlet?imageName=partly-cloudy-night.png&imageDir=/home/APPNAME_DATA/data/APPNAME/WeatherApplication/WeatherIconsAPPNAME/\",\"temperature\":\"74degreeF\",\"temperatureText\":\"Partly Cloudy\",\"date\":\"Last Updated on August 29, 4:47 AM\",\"responseMessage\":\"\",\"city\":\"Columbus, OH.\",\"webSource\":\"Powered By : darksky.net\",\"weatherDetailBean\":{\"feelsLike\":\"75degreeF\",\"pressure\":\"29.99 in\",\"humidity\":\"90%\",\"wind\":\"3.18 mph\",\"visiblity\":\"10 mi\",\"sunRise\":\"6:59 am\",\"sunSet\":\"8:10 pm\",\"currentDayHigh\":\"83degreeF\",\"currentDayLow\":\"70degreeF\"},\"foreCastBeans\":[{\"day\":\"Tue\",\"high\":\"82degreeF\",\"low\":\"59degreeF\",\"summary\":\"rain\",\"url\":\"/ImageGrabberServlet?imageName=rain.png&imageDir=/home/APPNAME_DATA/data/APPNAME/WeatherApplication/WeatherIconsAPPNAME/\"},{\"day\":\"Wed\",\"high\":\"80degreeF\",\"low\":\"57degreeF\",\"summary\":null,\"url\":\"/ImageGrabberServlet?imageName=clear-day.png&imageDir=/home/APPNAME_DATA/data/APPNAME/WeatherApplication/WeatherIconsAPPNAME/\"},{\"day\":\"Thu\",\"high\":\"78degreeF\",\"low\":\"57degreeF\",\"summary\":null,\"url\":\"/ImageGrabberServlet?imageName=clear-day.png&imageDir=/home/APPNAME_DATA/data/APPNAME/WeatherApplication/WeatherIconsAPPNAME/\"},{\"day\":\"Fri\",\"high\":\"81degreeF\",\"low\":\"61degreeF\",\"summary\":null,\"url\":\"/ImageGrabberServlet?imageName=partly-cloudy-day.png&imageDir=/home/APPNAME_DATA/data/APPNAME/WeatherApplication/WeatherIconsAPPNAME/\"}],\"hourlyWeather\":null},\"status\":\"success\"}".data(using: .utf8)!
    
    func getWeatherData()
        {
            let decoder = JSONDecoder()
            do{
                
                let weatherResponse = try decoder.decode(WeatherResponseModel.self, from: weatherData)
                if(weatherResponse.status == "success"){
                    
                    let realm = try Realm()
                    
                    // reaml.write triggers the App crash
                    try realm.write {
                        
                        let items = WeatherRelam()
                        items.temperature = weatherResponse.data.temperature ?? ""
                        items.city = weatherResponse.data.city ?? ""
                        
            
                        items.temperatureText = weatherResponse.data.temperatureText ?? ""
                        items.date = weatherResponse.data.date ?? ""
                        items.webSource = weatherResponse.data.webSource ?? ""
                        items.status = weatherResponse.status
                        
                        let detailedWeather = DetailedWeatherRealm()
                        
                        detailedWeather.feelsLike = weatherResponse.data.weatherDetailBean.feelsLike ?? ""
                        detailedWeather.pressure = weatherResponse.data.weatherDetailBean.pressure ?? ""
                        detailedWeather.humidity = weatherResponse.data.weatherDetailBean.humidity ?? ""
                        detailedWeather.wind = weatherResponse.data.weatherDetailBean.wind ?? ""
                        detailedWeather.visiblity = weatherResponse.data.weatherDetailBean.visiblity ?? ""
                        detailedWeather.sunRise = weatherResponse.data.weatherDetailBean.sunRise ?? ""
                        detailedWeather.sunSet = weatherResponse.data.weatherDetailBean.sunSet ?? ""
                        detailedWeather.currentDayHigh = weatherResponse.data.weatherDetailBean.currentDayHigh ?? ""
                        detailedWeather.currentDayLow = weatherResponse.data.weatherDetailBean.currentDayLow ?? ""
                        
                        items.detailedWeather.append(detailedWeather)
                        
                        
                        let forecastWeather = ForeCastWeatherRealm()
                        
                        for i in (0..<weatherResponse.data.foreCastBeans.count){
                            let dayWeather = ForeCastDataRealm()
                            dayWeather.day = weatherResponse.data.foreCastBeans[i].day ?? ""
                            dayWeather.high = weatherResponse.data.foreCastBeans[i].high ?? ""
                            dayWeather.low = weatherResponse.data.foreCastBeans[i].low ?? ""
                            dayWeather.des = weatherResponse.data.foreCastBeans[i].summary ?? ""
                            forecastWeather.foreCastData.append(dayWeather)
                        }
                        
                        items.foreCastWeather.append(forecastWeather)
                        
                        let weatherData = realm.objects(WeatherRelam.self)
                        
                        if(weatherData.count > 0){
                            realm.delete(weatherData)
                            realm.delete(realm.objects(DetailedWeatherRealm.self))
                            realm.delete(realm.objects(ForeCastWeatherRealm.self))
                            realm.delete(realm.objects(ForeCastDataRealm.self))
                            
                        }
                        
                        realm.add(items)
                        print("Weather : Weather data - \(items)")
                        
                        
                        
                    }
                    
                }
                
            } catch{
                print("Weather : error occured in realm - \(error)")
            }
            
        
    }
    
}


//MARK:- Codable Protocol
struct WeatherResponseModel :Codable{
    
    var data:WeatherData
    var status:String
}

struct WeatherData :Codable {
    var url:String?
    var temperature:String?
    var temperatureText:String?
    var date:String?
    var city:String?
    var webSource:String?
    var weatherDetailBean: DetailedData
    var foreCastBeans: [ForeCastData]
}

struct DetailedData : Codable{
    var feelsLike:String?
    var pressure:String?
    var humidity:String?
    var wind:String?
    var visiblity:String?
    var sunRise:String?
    var sunSet:String?
    var currentDayHigh:String?
    var currentDayLow:String?
    
}

struct ForeCastData :Codable{
    
    var day:String?
    var high:String?
    var low:String?
    var url:String?
    var summary:String?
}



//MARK:- Realm Objects
class WeatherRelam:Object{
    
    @objc dynamic var temperature = ""
    @objc dynamic var temperatureText = ""
    @objc dynamic var date = ""
    @objc dynamic var webSource = ""
    @objc dynamic var status = ""
    @objc dynamic var city = ""
    var detailedWeather = List<DetailedWeatherRealm>()
    var foreCastWeather = List<ForeCastWeatherRealm>()
    
}

class DetailedWeatherRealm: Object {
    
    @objc dynamic var feelsLike = ""
    @objc dynamic var pressure = ""
    @objc dynamic var humidity = ""
    @objc dynamic var wind = ""
    @objc dynamic var visiblity = ""
    @objc dynamic var sunRise = ""
    @objc dynamic var sunSet = ""
    @objc dynamic var currentDayHigh = ""
    @objc dynamic var currentDayLow = ""
}

class ForeCastWeatherRealm: Object {
    
    let foreCastData = List<ForeCastDataRealm>()
}

class ForeCastDataRealm:Object{
    
    @objc dynamic var day = ""
    @objc dynamic var high = ""
    @objc dynamic var low = ""
    @objc dynamic var des = ""
}



