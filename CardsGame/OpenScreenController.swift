//
//  OpenScreenController.swift
//  CardsGame
//
//  Created by Student28 on 12/07/2024.
//


import UIKit
import CoreLocation

class OpenScreenController: UIViewController, CLLocationManagerDelegate {
    var nameOfPlayer: String?
    var playerSide: String?
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var westImage: UIImageView!
    @IBOutlet weak var eastImage: UIImageView!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var playerNameLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()

        DispatchQueue.global().async {
            self.checkLocationAuthorization()
        }
        
        
        
        
        if let savedName = UserDefaults.standard.string(forKey: "playerName"){
            nameOfPlayer = savedName
            playerNameLabel.text = "Hello \(savedName)"
            playerNameLabel.isHidden = false
            nameTextField.isHidden = true
            startButton.isEnabled = true
        }else{
            playerNameLabel.isHidden = true
            nameTextField.isHidden = false
            startButton.isEnabled = false
        }
        
        nameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField){
        startButton.isEnabled = !(textField.text?.isEmpty ?? true)
    }
    
    
    @IBAction func startGameTapped(_ sender: UIButton){
        let storyboard = UIStoryboard(name:  "Main", bundle: nil)
        if let gameVC = storyboard.instantiateViewController(withIdentifier: "ViewController") as? ViewController{
            if let name = nameTextField.text, !name.isEmpty{
                gameVC.playerName = name
                UserDefaults.standard.set(name, forKey: "playerName")
            }else if let savedName = playerNameLabel.text{
                gameVC.playerName = nameOfPlayer
            }
            gameVC.playerSide = playerSide
            
            
            self.present(gameVC, animated: true, completion: nil)
            
        }
    }
    
    func checkLocationAuthorization() {
            if #available(iOS 14.0, *) {
                let status = self.locationManager.authorizationStatus
                DispatchQueue.main.async {
                    self.handleLocationAuthorizationStatus(status)
                }
                
            } else {
                let status = CLLocationManager.authorizationStatus()
                DispatchQueue.main.async {
                    self.handleLocationAuthorizationStatus(status) } } }
    
    func handleLocationAuthorizationStatus(_ status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            if CLLocationManager.locationServicesEnabled() {
                DispatchQueue.global().async {
                    self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                    self.locationManager.startUpdatingLocation()                 }
                }
        case .notDetermined:
            DispatchQueue.global().async {
                self.locationManager.requestWhenInUseAuthorization()}
        case .restricted, .denied:
            // Handle denied authorization
            print("Location services are not authorized.")
            @unknown default:
            break } }


    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        DispatchQueue.global().async {
            self.checkLocationAuthorization()
        }
        }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        if let location = locations.last {
            let userLongitude = location.coordinate.longitude
            let referenceLongitude = 34.81754916
            
            if userLongitude > referenceLongitude{
                playerSide = "east"
                westImage.isHidden = true
            
            }else{
                playerSide = "west"
                eastImage.isHidden = true
            }
            
            locationManager.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error){
        print("error: \(error.localizedDescription)")
    }
}
