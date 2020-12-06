//
//  ViewController.swift
//  ElClima
//
//  Created by Francisco Hernandez on 4/18/20.
//  Copyright © 2020 Francisco Hernandez. All rights reserved.
//


import UIKit
import CoreLocation

class ViewController: UIViewController {
        
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var affirmationLabel: UILabel!
    @IBOutlet weak var englishLabelAffirmation: UILabel!
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()//gets the location of the current location
        
    var timer: Timer!
    
    //list of affirmations
    @objc let affirmations = [
        "Me entusiasma la vida todo en mi es energia y optimismo.",
        "Todo esta bien en mi vida.",
        "Cada celula de mi cuerpo esta llena de energia y salud.",
        "Yo soy perfecta exactamente como soy.",
        "Mi futuro es brilante y hermoso.",
        "Me meresco lo mejor y lo acepto ahora mismo.",
        "Por medio del amor me ago cargo de la reconstrucion de mi vida.",
        "Estoy en el lugar correcto, en el momento adeucado, aciendo lo correcto",
        "Mi bien me viene de todas partes, de todas las personas y de todas las cosas",
        "Me doy permiso de ser todo lo que puedo ser",
        "Fluyo suavemente con la vida y en cada experiencia",
        "Formo parte de la abundancia del universo."
    ]
    
    @objc let englishAffirmations = [
        "I am excited about life, everything in me is energy and optimism.",
        "Everything is fine in my life.",
        "Every cell in my body is full of energy and health.",
        "I am perfect exactly as I am.",
        "My future is bright and beautiful.",
        "I deserve the best and I accept it right now.",
        "Through love I take charge of the reconstruction of my life.",
        "I'm in the right place, at the right time, doing the right thing",
        "My good comes from everywhere, from all people and from all things",
        "I give myself permission to be all that I can be",
        "I flow smoothly with life and in every experience",
        "I am part of the abundance of the universe."
        ]
    
    //array of images
    
    var backgroundImages: [UIImage] = [
        UIImage(named: "bolt.png")!,
        UIImage(named: "cloud.png")!,
        UIImage(named: "drizzle.png")!,
        UIImage(named: "fog.png")!,
        UIImage(named: "snow.png")!,
        UIImage(named: "sun.png")!,
    ]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundImage.image = backgroundImages[.random(in: 0...8)]
        
        affirmationLabel.text = affirmations[.random(in: 0...1)]
        
        timer = Timer(timeInterval: 1.0, target: self, selector: #selector(getter: affirmations), userInfo: nil, repeats: true)
        
        englishLabelAffirmation.text = englishAffirmations[.random(in: 0...16)]
            
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        weatherManager.delegate = self
        
        // Do any additional setup after loading the view.
        //this code says that the textfield needs to report back to the viewcontroller
        searchTextField.delegate = self
        
        //image view section

    }
    
    @IBAction func locationPressed(_ sender: UIButton) {
           locationManager.requestLocation()
       }
}


//MARK: - UITextFielddelegate

extension ViewController: UITextFieldDelegate {
    
    @IBAction func searchPressed(_ sender: UIButton) {
        //this dismisses the keyboard
        searchTextField.endEditing(true)
        //this prints whatever you have in the placeholder
        print(searchTextField.text!)
    }
    
    //this func is to have the return button on the keyboard to be true
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
//        print(searchTextField.text!)
        return true
    }
    //if the user did not type something/ they need to type something
       func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
           if textField.text != "" {
               return true
           } else {
               textField.placeholder = "Type a city"
               return false
           }
       }
    
    //this resets the placeholder after the user hits return
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let city = searchTextField.text {
            weatherManager.fetchWeather(cityName: city)
        }
        searchTextField.text = ""
    }
    
}

//MARK: - WeatherManagerDelegate

extension ViewController: WeatherManagerDelegate {
    
        func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
            DispatchQueue.main.async {
                self.temperatureLabel.text = weather.temperatureString
                self.conditionImageView.image = UIImage(systemName: weather.conditionName)
                
                self.cityLabel.text = weather.cityName
            }
        }
        func didFailWithError(error: Error) {
            print(error)
        }
    }

//MARK: - CLlocationManagerDelegate

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(latitude: lat, longitute: lon)
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}


