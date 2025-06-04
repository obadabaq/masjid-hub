//
//  SendCommandsViewController.swift
//  Runner
//
//  Created by Qasem Zreaq on 24/03/2024.
//

import UIKit
import CoreBluetooth
import CoreLocation
import Adhan
import MuslimData

class SendCommandsViewController: UIViewController, UITableViewDelegate,CLLocationManagerDelegate {
    
    var perph :CBPeripheral!
    var service1:CBService!
    var locationManager: CLLocationManager!
    var coordenate :Coordinates?
    @IBOutlet weak var commandsTable: UITableView!
    let data = ["update date & time",
                "prayer time notificaiton",
                "send missed call notification",
                "send new location",
                "Send & set new schedule",
                "Upate weather data",
                "Set new alarm",
                "open quran screen",
                "daily tasbeeh count",
                "update step count",
                "send measured data",
                "send incomming call",
                "update prayer times",
                ]
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        commandsTable.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            
            let currentDateTimeHex = getCurrentDateTimeHex()
            print(currentDateTimeHex)
            sendcommad(commind: currentDateTimeHex)
            
        }else if indexPath.row == 1 {
            
            sendcommad(commind: "1A01F21E")
            
        }else if indexPath.row == 2 {
            sendcommad(commind: "1A01F504598859880E0086012345678998765432100123")
            
            
        }else if indexPath.row == 3 {
            
            sendcommad(commind: "1A01B24C6F7320416E67656C6573")
            
        }else if indexPath.row == 4 {
            sendcommad(commind: "1A01F81E004D0065006500740069006E00670020007700690074006800208001677F1F0C170B000C00")
//            let cal = Calendar(identifier: Calendar.Identifier.islamic)
//            let date = cal.dateComponents([.year, .month, .day], from: Date())
//            var coordinates = self.coordenate!
//            var params = CalculationMethod.muslimWorldLeague.params
//            params.madhab = .shafi
//            if let prayers = PrayerTimes(coordinates: coordinates, date: date, calculationParameters: params) {
//                let formatter = DateFormatter()
//                formatter.timeStyle = .medium
//                formatter.timeZone = TimeZone(identifier: "America/New_York")!
//                print("fajr \(formatter.string(from: prayers.fajr))")
//                print("sunrise \(formatter.string(from: prayers.sunrise))")
//                print("dhuhr \(formatter.string(from: prayers.dhuhr))")
//                print("asr \(formatter.string(from: prayers.asr))")
//                print("maghrib \(formatter.string(from: prayers.maghrib))")
//                print("isha \(formatter.string(from: prayers.isha))")
//            }
//            sendcommad(commind: "1A01A302140C3210261235140A1D0118")
            
                    }
        else if indexPath.row == 5{
            
            
            sendcommad(commind:"1A01F103171E280248020518")
            sendcommad(commind:"1A01F103171E280248010618")
            sendcommad(commind:"1A01F103171E280248030618")
            sendcommad(commind:"1A01F103171E280248040618")
            sendcommad(commind:"1A01F103171E280248050618")

        }
        
        else if indexPath.row == 6 {
            
            sendcommad(commind: "1A01D711390170")
        }else if indexPath.row == 7 {
            
            sendcommad(commind: "1A01C10x001C")
        }else if indexPath.row == 8 {
            
            sendcommad(commind: "1A01F44D79204461640A706C732068656C70206D")
        }else if indexPath.row == 9 {
            
            sendcommad(commind: "1A01F44D79204461640A706C732068656C70206D")
        }else if indexPath.row == 10 {
            
            sendcommad(commind: "1A01F44D79204461640A706C732068656C70206D")
        }else if indexPath.row == 11 {
            
            sendcommad(commind: "1A01F44D79204461640A706C732068656C70206D")
        }else if indexPath.row == 12 {
            
            sendcommad(commind: "1A01A3061D0C3F1028124814011E0518")
            sendcommad(commind: "1A01A3061D0C3F1028124814011F0518")
            
                        let cal = Calendar(identifier: Calendar.Identifier.islamic)
                        let date = cal.dateComponents([.year, .month, .day], from: Date())
                        var coordinates = self.coordenate!
                        var params = CalculationMethod.muslimWorldLeague.params
                        params.madhab = .shafi
                        if let prayers = PrayerTimes(coordinates: coordinates, date: date, calculationParameters: params) {
                            let formatter = DateFormatter()
                            formatter.timeStyle = .medium
                            formatter.timeZone = TimeZone(identifier: "America/New_York")!
                            print("fajr \(formatter.string(from: prayers.fajr))")
                            print("sunrise \(formatter.string(from: prayers.sunrise))")
                            print("dhuhr \(formatter.string(from: prayers.dhuhr))")
                            print("asr \(formatter.string(from: prayers.asr))")
                            print("maghrib \(formatter.string(from: prayers.maghrib))")
                            print("isha \(formatter.string(from: prayers.isha))")
                        }


        }
        
    }
    
    override func viewDidLoad() {
        commandsTable.dataSource = self
        commandsTable.delegate = self
        DispatchQueue.main.async {
            if (CLLocationManager.locationServicesEnabled())
                    {
                self.locationManager = CLLocationManager()
                self.locationManager.delegate = self
                self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
                self.locationManager.requestAlwaysAuthorization()
                self.locationManager.startUpdatingLocation()
                    }
        }
        
        super.viewDidLoad()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
       {
       
           let location = locations.last! as CLLocation
           self.coordenate = Coordinates(latitude: location.coordinate.latitude, longitude: -location.coordinate.longitude)
           print(location.coordinate)
           
       }
    
}

extension SendCommandsViewController:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    
    func showDialogButtonTapped() {
            // Create UIAlertController
            let alertController = UIAlertController(title: "Enter City Here", message: nil, preferredStyle: .alert)
            
            // Add a text field
            alertController.addTextField { textField in
                textField.placeholder = "Enter your City"
            }
            
            // Create Confirm action
            let confirmAction = UIAlertAction(title: "Confirm", style: .default) { _ in
                // Handle confirm button tap
                if let textField = alertController.textFields?.first, let text = textField.text {
                    print("Entered text: \(text)")
                    self.sendcommad(commind: stringToHex(text))
                    // Here you can perform actions with the entered text
                }
            }
            
            // Add Confirm action to the alert controller
            alertController.addAction(confirmAction)
            
            // Present the alert controller
            present(alertController, animated: true, completion: nil)
        }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = commandsTable.dequeueReusableCell(withIdentifier: "COMMANDCELL", for: indexPath)
        cell.textLabel?.text = data[indexPath.row]
        return cell

    }
    
    
    
    func sendcommad (commind:String){
       if let characteristics = service1.characteristics {
           print("Discovered characteristics for service \(service1.uuid.uuidString) of peripheral \(perph.name ?? "Unknown"):")
           
           // Iterate through discovered characteristics
           for characteristic in characteristics {
               print("qasem \(characteristic)")
               
               // Check if the characteristic UUID matches the one you're interested in (FF01)
               if characteristic.uuid == CBUUID(string: "FF01") {
                   print("found service...")
                   let hexString2 = commind
                   if let dataToWrite = dataFromHexString(hexString2) {
                       // Now you can use `dataToWrite` to write to the characteristic
                       perph.writeValue(dataToWrite, for: characteristic, type: .withResponse)
                       
                   }
               }
           }
       }
    }
    
    func dataFromHexString(_ hexString: String) -> Data? {
        var hexString = hexString
        // Pad the hex string with a leading zero if it has an odd length
        if hexString.count % 2 != 0 {
            hexString.insert("0", at: hexString.startIndex)
        }
        
        var data = Data(capacity: hexString.count / 2)
        var index = hexString.startIndex
        while index < hexString.endIndex {
            let byteString = String(hexString[index ..< hexString.index(index, offsetBy: 2)])
            if var byte = UInt8(byteString, radix: 16) {
                data.append(&byte, count: 1)
            } else {
                return nil
            }
            index = hexString.index(index, offsetBy: 2)
        }
        return data
    }
    
}


func getCurrentDateTimeHex() -> String {
    let currentDate = Date()
    let calendar = Calendar.current
    
    // Extracting date components
    let components = calendar.dateComponents([.year, .month, .day, .weekday, .hour, .minute], from: currentDate)
    
    // Converting date components to hexadecimal
    let yearHex = String(format: "%02X", components.year! % 100) // Only last two digits of year
    let monthHex = String(format: "%02X", components.month!)
    let dayHex = String(format: "%02X", components.day!)
    let weekdayHex = String(format: "%02X", (components.weekday! - 1) % 7) // Convert from 1-based to 0-based
    let hourHex = String(format: "%02X", components.hour!)
    let minuteHex = String(format: "%02X", components.minute!)
    
    // Constructing the final command string
    let command = "1A01A1\(hourHex)\(minuteHex)\(weekdayHex)\(dayHex)\(monthHex)\(yearHex)"
    return command
}

func stringToHex(_ string: String) -> String {
    let utf8Array = Array(string.utf8)
    return utf8Array.map { String(format: "%02X", $0) }.joined(separator: " ")
}

// Example usage
