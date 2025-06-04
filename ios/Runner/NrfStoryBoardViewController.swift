import UIKit
import CoreBluetooth

var perph :CBPeripheral?
var service1:CBService?


func hexStringForCurrentDateTime() -> String {
    let now = Date()
    let calendar = Calendar.current
    let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second, .weekday], from: now)
    
    // Convert each component to its hexadecimal representation
    
    let year = String(format: "%02X", components.year! - 2000) // Subtract 2000 to get the last two digits of the year
    let month = String(format: "%02X", components.month!)
    let day = String(format: "%02X", components.day!)
    let hour = String(format: "%02X", components.hour!)
    let minute = String(format: "%02X", components.minute!)
    let second = String(format: "%02X", components.second!)
    let weekday = String(format: "%02X", components.weekday! - 1) // Subtract 1 to get the weekday starting from 0
    
    // Concatenate all components into a single hex string
    let hexString = "\(year)\(month)\(day)\(hour)\(minute)\(second)\(weekday)"
    
    return hexString
}


// Protocol for Bluetooth connection delegate
protocol BluetoothConnectionDelegate: AnyObject {
    func didConnectToDevice(name: String)
    func didDiscoverServices()
}

class BluetoothConnectionManager: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    
    static let shared = BluetoothConnectionManager()
    weak var delegate: BluetoothConnectionDelegate?
    var knownPeripherals: [CBPeripheral] = []
    var servicesDict: [CBPeripheral: [CBService]] = [:] // Dictionary to store discovered services for each peripheral
    var centralManager: CBCentralManager!
    var scanTimer: Timer?
    
    override private init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
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
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            startScan()
            print("Scanning for peripherals...")
        } else {
            print("Bluetooth is not powered on.")
        }
    }

    func startScan() {
        centralManager.scanForPeripherals(withServices: nil, options: nil)
        // Schedule the scan to repeat every 10 seconds (adjust interval as needed)
        scanTimer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { _ in
            self.centralManager.scanForPeripherals(withServices: nil, options: nil)
            print("Scanning for peripherals...")
        }
    }

    func stopScan() {
        centralManager.stopScan()
        scanTimer?.invalidate()
        scanTimer = nil
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        // Print the name of the discovered peripheral
        if let name = peripheral.name {
            print("Discovered peripheral: \(name)")
            if name == "W570" {
                // Check if we are not already connected to this peripheral
                if !knownPeripherals.contains(peripheral) {
                    peripheral.delegate = self
                    knownPeripherals.append(peripheral)
                    servicesDict[peripheral] = [] // Initialize an empty array for discovered services
                    // Connect to the peripheral
                    print("Connecting to peripheral: \(name)")
                    centralManager.connect(peripheral, options: nil)
                }
            }
        } else {
            print("Discovered peripheral with no name. \(peripheral.identifier)")
        }
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected to peripheral: \(peripheral.name ?? "Unknown")")
        delegate?.didConnectToDevice(name: "Connected Watch is: \(peripheral.name ?? "Unknown")")
        // Keep a reference to the connected peripheral
        knownPeripherals.append(peripheral)
        peripheral.discoverServices(nil) //
    }

    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("Disconnected from peripheral: \(peripheral.name ?? "Unknown")")
        if let index = knownPeripherals.firstIndex(of: peripheral) {
            knownPeripherals.remove(at: index)
        }
        // Try reconnecting
        centralManager.connect(peripheral, options: nil)
    }
             
    // MARK: - CBPeripheralDelegate
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard error == nil else {
            print("Error discovering services for peripheral \(peripheral.name ?? "Unknown"): \(error!)")
            return
        }
        
        if let services = peripheral.services {
            print("Discovered services for peripheral \(peripheral.name ?? "Unknown"):")
            servicesDict[peripheral] = services // Update the discovered services for the peripheral
            delegate?.didDiscoverServices()
            // Iterate through discovered services and discover characteristics for each service
            for service in services {
                print("- \(service)")
                peripheral.discoverCharacteristics(nil, for: service)
            }
        }
    }
    
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        
        guard error == nil else {
            print("Error discovering characteristics for service \(service.uuid.uuidString) of peripheral \(peripheral.name ?? "Unknown"): \(error!)")
            return
        }
        if let characteristics = service.characteristics {
            print("Discovered characteristics for service \(service.uuid.uuidString) of peripheral \(peripheral.name ?? "Unknown"):")
            // Iterate through discovered characteristics
            for characteristic in characteristics {
                print("qasem \(characteristic)")
                
                // Check if the characteristic UUID matches the one you're interested in (FF01)
                if characteristic.uuid == CBUUID(string: "FF01") {
                    print("%%%%%%%%%%%%%%")
                    print (peripheral)
                    print(service)
                    print("%%%%%%%%%%%%%%")
                    perph = peripheral
                    service1 = service
                    print("found service...")
                    
                }
            }
        }
    }

}

class NrfStoryBoardViewController: UIViewController, BluetoothConnectionDelegate, UITableViewDataSource {
    func didDiscoverServices() {
        self.servicesTable.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GOCOMMANDS"
        {
            print("")
            if let vc = segue.destination as? SendCommandsViewController {
                vc.perph = perph
                vc.service1 = service1
                
            }
        }

    }
    
    @IBOutlet weak var servicesTable: UITableView!
    @IBOutlet weak var deviceName: UILabel!
    var centralManager: CBCentralManager!

    override func viewDidLoad() {
        super.viewDidLoad()
        centralManager = CBCentralManager(delegate: BluetoothConnectionManager.shared, queue: nil)
        BluetoothConnectionManager.shared.delegate = self
        servicesTable.dataSource = self // Set table view data source
    }

    func didConnectToDevice(name: String) {
        deviceName.text = name
        servicesTable.reloadData() // Reload table view when device is connected
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Check if there's a connected peripheral and if its services are available
        guard let peripheral = BluetoothConnectionManager.shared.knownPeripherals.first,
              let services = BluetoothConnectionManager.shared.servicesDict[peripheral] else {
            return 0
        }
        
        return services.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ServiceCell", for: indexPath)
        let peripheral = BluetoothConnectionManager.shared.knownPeripherals.first
        let services = BluetoothConnectionManager.shared.servicesDict[peripheral!]
        let service = services?[indexPath.row]
        cell.textLabel?.text = service?.uuid.uuidString
        return cell
    }
}
