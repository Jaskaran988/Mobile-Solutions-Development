//
//  ViewController.swift
//  Lab7(GPS)
//
//  Created by user239680 on 7/11/24.
//
import QuartzCore
import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate{

    // Outlets to UI elements
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var currentSpeed: UILabel!
    @IBOutlet weak var maxSpeed: UILabel!
    @IBOutlet weak var averageSpeed: UILabel!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var maxAcceleration: UILabel!
    @IBOutlet weak var speedIndicatorView: UIView!
    @IBOutlet weak var tripIndicatorView: UIView!
    @IBOutlet weak var distanceBeforeExceeding: UILabel!

    // Setup when the view loads
     override func viewDidLoad() {
         super.viewDidLoad()
         locationService.delegate = self
         locationService.desiredAccuracy = kCLLocationAccuracyBest
         mapView.showsUserLocation = true
         addGradientBackground()
     }
    // to add gradient color to the background
    func addGradientBackground() {
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = view.bounds
        gradientLayer.colors = [
            UIColor(red: 0.98, green: 0.92, blue: 0.77, alpha: 1.00).cgColor, // Light Yellow
            UIColor(red: 0.87, green: 0.98, blue: 0.77, alpha: 1.00).cgColor, // Light Green
            UIColor(red: 0.77, green: 0.98, blue: 0.97, alpha: 1.00).cgColor, // Light Cyan
            UIColor(red: 0.87, green: 0.77, blue: 0.98, alpha: 1.00).cgColor, // Light Purple
            UIColor(red: 0.98, green: 0.77, blue: 0.87, alpha: 1.00).cgColor  // Light Pink
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
            view.layer.insertSublayer(gradientLayer, at: 0)
      

        }
    // Location manager to handle GPS updates
      let locationService = CLLocationManager()
      // Variables to track trip data
      var initialLocation: CLLocation?
      var previousLocation: CLLocation?
      var totalDistance: Double = 0.0
      var recordedSpeeds: [Double] = []
      var highestSpeed: Double = 0.0
      var highestAcceleration: Double = 0.0
      var speedThreshold: Double = 115.0 // km/h
      var distanceBeforeSpeedLimitExceeded: Double = 0.0
      // Actions for start and stop trip buttons
    
    @IBAction func startTripUiButton(_ sender: Any) {
        initiateTrip()
    }
    
    
    @IBAction func stopTripUiButton(_ sender: Any) {
        terminateTrip()
    }
   
     
     // Function to start a trip
     func initiateTrip() {
         locationService.requestWhenInUseAuthorization()
         locationService.startUpdatingLocation()
         tripIndicatorView.backgroundColor = .green
         clearTripData()
     }
     
     // Function to stop a trip
     func terminateTrip() {
         locationService.stopUpdatingLocation()
         tripIndicatorView.backgroundColor = .gray
     }
     
     // Function to reset all trip data
     func clearTripData() {
         initialLocation = nil
         previousLocation = nil
         totalDistance = 0.0
         recordedSpeeds = []
         highestSpeed = 0.0
         highestAcceleration = 0.0
         currentSpeed.text = "0 km/h"
         maxSpeed.text = "0 km/h"
         averageSpeed.text = "0 km/h"
         distance.text = "0 km"
         maxAcceleration.text = "0 m/s²"
         distanceBeforeExceeding.text = "0 km"
     }
     
    // CLLocationManagerDelegate method to handle location updates
     func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
         guard let latestLocation = locations.last else { return }
         
         // Setting the initial location on the first update
         if initialLocation == nil {
             initialLocation = latestLocation
         }
         
         if let prevLocation = previousLocation {
             // Calculate distance traveled
             let distanceCovered = latestLocation.distance(from: prevLocation)
             totalDistance += distanceCovered / 1000 // Convert to kilometers
             distance.text = String(format: "%.2f km", totalDistance)
             
             // Calculate speed and acceleration
             let timeInterval = latestLocation.timestamp.timeIntervalSince(prevLocation.timestamp)
             let currentSpeedValue = latestLocation.speed * 3.6 // Convert to km/h
             let currentAcceleration = abs(latestLocation.speed - prevLocation.speed) / timeInterval
             
             // Update maximum speed if necessary
             if currentSpeedValue > highestSpeed {
                 highestSpeed = currentSpeedValue
                 maxSpeed.text = String(format: "%.2f km/h", highestSpeed)
             }
             
             // Update maximum acceleration if necessary
             if currentAcceleration > highestAcceleration {
                 highestAcceleration = currentAcceleration
                 maxAcceleration.text = String(format: "%.2f m/s²", highestAcceleration)
             }
             
             // Add the current speed to the recorded speeds and calculate average speed
             recordedSpeeds.append(currentSpeedValue)
             let avgSpeed = recordedSpeeds.reduce(0, +) / Double(recordedSpeeds.count)
             averageSpeed.text = String(format: "%.2f km/h", avgSpeed)
             
             // Display the current speed
             currentSpeed.text = String(format: "%.2f km/h", currentSpeedValue)
             
             // Calculate distance before exceeding speed limit
             if distanceBeforeSpeedLimitExceeded == 0.0 && currentSpeedValue > speedThreshold {
                 distanceBeforeSpeedLimitExceeded = totalDistance
                 distanceBeforeExceeding.text = String(format: "%.2f km", distanceBeforeSpeedLimitExceeded)
             }
             
             // Change the indicator color if speed exceeds the limit
             if currentSpeedValue > speedThreshold {
                 speedIndicatorView.backgroundColor = .red
             } else {
                 speedIndicatorView.backgroundColor = .cyan
             }
         }
         
         // Update the previous location to the latest location
         previousLocation = latestLocation
         
         // Center the map on the user's current location
         mapView.setCenter(latestLocation.coordinate, animated: true)
         let region = MKCoordinateRegion(center: latestLocation.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
         mapView.setRegion(region, animated: true)
     }
}

