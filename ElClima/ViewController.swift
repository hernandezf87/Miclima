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
    
    var backgroundImages: [UIImage] = [
        UIImage(named: "bolt.png")!,
        UIImage(named: "cloud.png")!,
        UIImage(named: "snow.png")!,
        UIImage(named: "drizzle.png")!,
        UIImage(named: "rain.png")!,
        UIImage(named: "sun.png")!,
        UIImage(named: "fog.png")!,
       
        
    ]
            
    //list of affirmations
    @objc var affirmations: [ String] =
       ["ME ENTUSIASMA LA VIDA, TODO EN MI ES ENERGIA Y OPTIMISMO.",
        "TODO ESTA BIEN EN MI VIDA.",
        "CADA CELULA DE MI CUERPO ESTA LLENA DE ENERGIA Y SALUD.",
        "YO SOY PERFECTA EXACTAMENTE COMO SOY.",
        "MI FUTURO ES BRILLANTE Y HERMOSO.",
        "ME MERESCO LO MEJOR Y LO ACEPTO AHORA MISMO.",
        "POR MEDIO DEL AMOR ME AGO CARGO DE LA RECONSTRUCION DE MI VIDA.",
        "ESTOY EN EL LUGAR CORRECTO, EN EL MOMENTO ADEUCADO, ACIENDO LO CORRECTO",
        "MI BIEN ME VIENE DE TODAS PARTES, DE TODAS LAS PERSONAS Y DE TODAS LAS COSAS",
        "ME DOY PERMISO DE SER TODO LO QUE PUEDO SER",
        "FLUYO SUAVEMENTE CON LA VIDA Y EN CADA EXPERIENCIA",
        "FORMO PARTE DE LA ABUNDANCIA DEL UNIVERSO."
    ]
    
    @objc var englishAffirmations = [
        "I AM EXICTED ABOUT LIFE, EVERYTHING IN ME IS ENERGY AND OPTIMISM.",
        "EVERYTHING IS FINE IN MY LIFE.",
        "EVERY CELL IN MY BODY IS FULL OF ENERGY AND HEALTH.",
        "I AM PERFECT EXACTLY AS I AM.",
        "MY FUTURE IS BRIGHT AND BEAUTIFUL.",
        "I DESERVE THE BEST AND I ACCEPT IT RIGHT NOW.",
        "THROUGH LOVE I TAKE CHARGE OF THE RECONSTRUCTION OF MY LIFE.",
        "I'M IN THE RIGHT PLACE, AT THE RIGHT TIME, DOING THE RIGHT THING",
        "MY GOOD COMES FROM EVERYWHERE, FROM ALL THE PEOPLE AND FROM ALL THINGS",
        "I GIVE MYSELF PERMISSION TO BE ALL THAT I CAN BE",
        "I FLOW SMOOTHLY WITH LIFE AND IN EVERY EXPERIENCE",
        "I AM PART OF THE ABUNDANCE OF THE UNIVERSE."
        ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupToHideKeyboardOnTapOnView()
        changeAffirmationsLabel()
        changeEnglishLabel()
        
        timer = Timer.scheduledTimer(timeInterval: 12.5, target: self, selector: #selector(changeEnglishLabel), userInfo: nil, repeats: true)
        
        timer = Timer.scheduledTimer(timeInterval: 10.5, target: self, selector: #selector(changeAffirmationsLabel), userInfo: nil, repeats: true)
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        weatherManager.delegate = self
        
        // Do any additional setup after loading the view.
        //this code says that the textfield needs to report back to the viewcontroller
        searchTextField.delegate = self
    }
    
    @objc func changeAffirmationsLabel() {
        affirmationLabel.text = affirmations[.random(in: 0...11)]
    }
    
    @objc func changeEnglishLabel() {
        englishLabelAffirmation.text = englishAffirmations[.random(in: 0...11)]
    }
    
    @IBAction func locationPressed(_ sender: UIButton) {
           locationManager.requestLocation()
       }
}

extension UIViewController {
    
    func setupToHideKeyboardOnTapOnView() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
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
//       func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
//           if textField.text != "" {
//               return true
//           } else {
//               textField.placeholder = "Type a city"
//               return false
//           }
//       }
    
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
                self.backgroundImage.image = UIImage(systemName: weather.conditionName)
                self.cityLabel.text = weather.cityName
               
                switch weather.conditionName {
                case "cloud.bolt":
                    self.backgroundImage.image = UIImage(named: "bolt.png");
                case "cloud.drizzle":
                    self.backgroundImage.image = UIImage(named: "drizzle.png");
                case "cloud.rain":
                    self.backgroundImage.image = UIImage(named: "rain.png");
                case "cloud.snow":
                    self.backgroundImage.image = UIImage(named: "snow.png");
                case "cloud.fog":
                    self.backgroundImage.image = UIImage(named: "fog.png");
                case "sun.max":
                    self.backgroundImage.image = UIImage(named: "sun.png");
                default:
                    print("error")
                }
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


