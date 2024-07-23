//
//  ViewController.swift
//  Lab8
//
//  Created by user239680 on 7/21/24.
//
import QuartzCore
import UIKit
import CoreLocation
class ViewController: UIViewController ,CLLocationManagerDelegate{
    
    @IBOutlet weak var locationLabel: UILabel!
    
    
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    
    @IBOutlet weak var weatherUiimage: UIImageView!
    
    @IBOutlet weak var temperatureLabel: UILabel!
    
    
    @IBOutlet weak var humidityLabel: UILabel!
    
    @IBOutlet weak var windLabel: UILabel!
    let locationService = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationService.delegate = self
        locationService.requestWhenInUseAuthorization()
        locationService.startUpdatingLocation()
        addGradientBackground()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let currentLocation = locations.last {
            let latitude = currentLocation.coordinate.latitude
            let longitude = currentLocation.coordinate.longitude
            fetchWeatherData(lat: latitude, lon: longitude)
        }
    }
    
    func addGradientBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [
            UIColor.systemBlue.cgColor,
            UIColor.systemTeal.cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func fetchWeatherData(lat: Double, lon: Double) {
        let apiKey = "acecd438d5732207987ba8f1f7433abb"
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(apiKey)&units=metric"
        
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    print("Error fetching data: \(error.localizedDescription)")
                    return
                }
                if let safeData = data {
                    // Log the JSON response
                    if let json = try? JSONSerialization.jsonObject(with: safeData, options: []) as? [String: Any] {
                        print(json)
                    }
                    self.parseJSON(weatherData: safeData)
                }
            }
            task.resume()
        }
    }
    
    
    func parseJSON(weatherData: Data) {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let cityName = decodedData.name ?? ""
            let description = decodedData.weather?[0].description ?? ""
            let icon = decodedData.weather?[0].icon ?? ""
            let temp = decodedData.main?.temp ?? 0.00
            let humidity = decodedData.main?.humidity ?? 0
            let windSpeed = decodedData.wind?.speed ?? 0.00
            
            DispatchQueue.main.async {
                self.updateUI(city: cityName, description: description, icon: icon, temperature: temp, humidity: humidity, windSpeed: windSpeed)
            }
        } catch {
            print("Error parsing JSON: \(error.localizedDescription)")
        }
    }
    
    func updateUI(city: String, description: String, icon: String, temperature: Double, humidity: Int, windSpeed: Double) {
        locationLabel.text = city
        weatherDescriptionLabel.text = description
        temperatureLabel.text = String(format: "%.1f°C", temperature)
        humidityLabel.text = "\(humidity)%"
        windLabel.text = "\(windSpeed) m/s"
        
        let iconUrlString = "https://openweathermap.org/img/wn/\(icon)@2x.png"
        if let iconUrl = URL(string: iconUrlString) {
            let task = URLSession.shared.dataTask(with: iconUrl) { data, response, error in
                if let data = data, error == nil {
                    DispatchQueue.main.async {
                        self.weatherUiimage.image = UIImage(data: data)
                    }
                }
            }
            task.resume()
        }
    }
}


