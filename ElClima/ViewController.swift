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
    
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
   
    @IBOutlet weak var searchTextField: UITextField!
    
    @IBOutlet weak var affirmationLabel: UILabel!
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()//gets the location of the current location
    
    let localizedTitle = NSLocalizedString("Welcome", comment: "")
    
    //var timer: Timer!
    //var affirmationsNumber = 0
    
    
    //list of affirmations
    let affirmations = [
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
        "Formo parte de la abundancia del universo.",
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        
        weatherManager.delegate = self
        
        // Do any additional setup after loading the view.
        //this code says that the textfield needs to report back to the viewcontroller
        searchTextField.delegate = self
    }
    @IBAction func locationPressed(_ sender: UIButton) {
           locationManager.requestLocation()
       }
}
    
   // @IBAction func locationPressed(_ sender: UIButton) {
     //   locationManager.requestLocation()
    //}
    

    
   // func addBannerViewToView(_ bannerView: GADBannerView) {
     // bannerView.translatesAutoresizingMaskIntoConstraints = false
      //view.addSubview(bannerView)
      //view.addConstraints(
       // [NSLayoutConstraint(item: bannerView,
       //                     attribute: .bottom,
        //                    relatedBy: .equal,
         //                   toItem: bottomLayoutGuide,
          //                  attribute: .top,
           //                 multiplier: 1,
            //                constant: 0),
         //NSLayoutConstraint(item: bannerView,
           //                 attribute: .centerX,
             //               relatedBy: .equal,
               //             toItem: view,
                 //           attribute: .centerX,
                   //         multiplier: 1,
                     //       constant: 0)
        //])
     //}
//}



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

