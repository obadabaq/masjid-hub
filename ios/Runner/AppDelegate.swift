import UIKit
import CoreBluetooth
import Flutter
import GoogleMaps
import flutter_downloader
import RTKOTASDK
import RTKLEFoundation

@main
@objc class AppDelegate: FlutterAppDelegate, CBCentralManagerDelegate, FlutterStreamHandler, RTKDFUUpgradeDelegate {

    var centralManager: CBCentralManager!
    var eventSink: FlutterEventSink?
    // Using one event sink for all events.
    var progressEventSink: FlutterEventSink?

    var discoveredPeripherals: [UUID: CBPeripheral] = [:]
    var activeUpgrade: RTKDFUUpgrade?
    var pendingBins: [RTKOTAUpgradeBin]? // Holds the extracted images until upgrade is ready

    private let EVENT_CHANNEL = "dfu_progress"
    private let METHOD_CHANNEL = "dfu_channel"

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // Confirm that AppDelegate is being loaded.
        print("AppDelegate didFinishLaunching called")

//        #if !DEBUG
        redirectLogsToDocuments()
//        #endif

        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let firmwarePath = (paths[0] as NSString).appendingPathComponent("firmwares")
        do {
            try FileManager.default.createDirectory(atPath: firmwarePath, withIntermediateDirectories: true, attributes: nil)
            print("Firmware directory created at \(firmwarePath)")
        } catch {
            print("Error creating firmware directory: \(error.localizedDescription)")
        }

        centralManager = CBCentralManager(delegate: self, queue: nil)
        centralManager.delegate = self

        GMSServices.provideAPIKey("AIzaSyC-Hyouv1ilFTHXb_08xW5bqmBMfS4GGwc")

        FlutterDownloaderPlugin.setPluginRegistrantCallback(registerPlugins)

        let controller = window?.rootViewController as! FlutterViewController

        // Set up the method channel.
        let rtkChannel = FlutterMethodChannel(
            name: METHOD_CHANNEL,
            binaryMessenger: controller.binaryMessenger
        )

        // Set up the event channel for DFU progress.
        let dfuProgressChannel = FlutterEventChannel(
            name: EVENT_CHANNEL,
            binaryMessenger: controller.binaryMessenger
        )
        dfuProgressChannel.setStreamHandler(self)

        // Optionally, if you use another event channel for state events.
        let rtkEventChannel = FlutterEventChannel(
            name: "dfu_event_channel",
            binaryMessenger: controller.binaryMessenger
        )
        rtkEventChannel.setStreamHandler(self)

        rtkChannel.setMethodCallHandler { [weak self] (call, result) in
            guard let self = self else { return }
            print("Method channel received call: \(call.method)")
            switch call.method {
            case "initialize":
                self.initializeDfu(call.arguments as? [String: Any], result: result)
            case "startDfu":
                let args = call.arguments as! [String: Any]
                let filePath = args["filePath"] as! String
                let deviceAddress = args["deviceAddress"] as! String
                print("startDfu called with filePath: \(filePath) and deviceAddress: \(deviceAddress)")

                guard let peripheral = self.getPeripheral(from: deviceAddress) else {
                    print("Peripheral not found for address: \(deviceAddress)")
                    result(FlutterError(code: "DEVICE_NOT_FOUND", message: "Device not found", details: nil))
                    return
                }
                do {
                    try self.startDFUProcess(peripheral: peripheral, filePath: filePath)
                    result(nil)
                } catch {
                    print("Error starting DFU process: \(error.localizedDescription)")
                    result(FlutterError(code: "DFU_ERROR", message: error.localizedDescription, details: nil))
                }
            default:
                result(FlutterMethodNotImplemented)
            }
        }

        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    // MARK: - DFU Process

    private func startDFUProcess(peripheral: CBPeripheral, filePath: String) throws {
        print("startDFUProcess invoked with file at \(filePath)")
        guard FileManager.default.fileExists(atPath: filePath) else {
            throw NSError(domain: "DFU_ERROR", code: 0, userInfo: [NSLocalizedDescriptionKey: "Firmware file not found"])
        }

        // Extract images from the firmware file.
        let bins = try RTKOTAUpgradeBin.imagesExtracted(fromMPPackFilePath: filePath)
        guard !bins.isEmpty else {
            throw NSError(domain: "DFU_ERROR", code: 1, userInfo: [NSLocalizedDescriptionKey: "No valid images in firmware file"])
        }
        print("Extracted \(bins.count) image(s) from firmware file")

        activeUpgrade = RTKDFUUpgrade(peripheral: peripheral)
        activeUpgrade?.delegate = self

        // Set configuration properties similar to your Android implementation.
        activeUpgrade?.olderImageAllowed = true
        activeUpgrade?.usingStrictImageCheckMechanism = false
        activeUpgrade?.checkFeatureInfo = false
//         activeUpgrade?.prefersUpgradeUsingOTAMode = true

        pendingBins = bins
        print("Calling prepareForUpgrade()")
        activeUpgrade?.prepareForUpgrade()
    }

    // Called when the DFU upgrade is ready.
    func dfuUpgradeDidReady(for upgrade: RTKDFUUpgrade) {
        print("dfuUpgradeDidReady called")
        eventSink?(["state": "STATE_PREPARED"])

        if let bins = pendingBins {
            print("Starting upgrade with \(bins.count) image(s)")
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                upgrade.upgrade(withImages: bins)
            }
            pendingBins = nil
        }
    }

    func dfuUpgrade(_ upgrade: RTKDFUUpgrade, couldNotUpgradeWithError error: Error) {
        print("dfuUpgrade couldNotUpgradeWithError: \(error.localizedDescription)")
        eventSink?(["state": "DFU_FAILED", "error": error.localizedDescription])
        activeUpgrade = nil
    }

    func dfuUpgrade(_ upgrade: RTKDFUUpgrade, didFinishUpgradeWithError error: Error?) {
        if let error = error {
            print("dfuUpgrade finished with error: \(error.localizedDescription)")
            eventSink?(["state": "DFU_FAILED", "error": error.localizedDescription])
        } else {
            print("dfuUpgrade completed successfully")
            eventSink?(["state": "DFU_COMPLETED"])
        }
        activeUpgrade = nil
    }

    func dfuUpgrade(_ upgrade: RTKDFUUpgrade, withDevice connection: RTKProfileConnection, didSendBytesCount length: UInt, ofImage image: RTKOTAUpgradeBin) {
        let totalBytes = image.data.count
        let progress = totalBytes > 0 ? Double(length) / Double(totalBytes) * 100.0 : 0.0
        print("dfuUpgrade progress: \(length) bytes sent out of \(totalBytes) (\(progress)% complete)")
        if let sink = progressEventSink {
                sink(["progress": progress])
            } else {
                print("progressEventSink is nil!")
            }
    }

    func dfuUpgrade(_ upgrade: RTKDFUUpgrade,
                    isAboutToSendImageBytesTo connection: RTKProfileConnection,
                    withContinuationHandler continuationHandler: @escaping () -> Void) {
        if let gattConnection = connection as? RTKDFUConnectionUponGATT {
            print("Updating connection parameters for GATT connection")
            gattConnection.updateConnectionParameter(
                withMinInterval: 6,
                maxInterval: 17,
                latency: 0,
                supervisionTimeout: 500
            ) { success, error in
                if let error = error {
                    print("Connection parameter update error: \(error.localizedDescription)")
                } else {
                    print("Connection parameters updated successfully")
                }
                continuationHandler()
            }
        } else {
            continuationHandler()
        }
    }

    // MARK: - CBCentralManagerDelegate

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print("Central Manager state updated: \(central.state.rawValue)")
        if central.state == .poweredOn {
            let connectedDevices = central.retrieveConnectedPeripherals(withServices: [CBUUID(string: "ff01")])
            for device in connectedDevices {
                central.cancelPeripheralConnection(device)
                print("Disconnected device: \(device.name ?? "Unknown Device")")
            }
        }
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber) {
        discoveredPeripherals[peripheral.identifier] = peripheral
        print("Discovered peripheral: \(peripheral.name ?? "Unknown") - \(peripheral.identifier.uuidString)")
        eventSink?([
            "status": "device_found",
            "deviceName": peripheral.name ?? "Unknown",
            "address": peripheral.identifier.uuidString
        ])
    }

    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("Peripheral disconnected: \(peripheral.name ?? "Unknown")")
        eventSink?(["state": "STATE_DISCONNECTED"])
    }

    private func getPeripheral(from deviceAddress: String) -> CBPeripheral? {
        guard let uuid = UUID(uuidString: deviceAddress) else {
            print("Invalid UUID string: \(deviceAddress)")
            return nil
        }
        return discoveredPeripherals[uuid] ?? centralManager.retrievePeripherals(withIdentifiers: [uuid]).first
    }

    // MARK: - Flutter Stream Handler

    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        print("onListen called with arguments: \(String(describing: arguments))")
        self.eventSink = events
        self.progressEventSink = events
        return nil
    }

    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        print("onCancel called with arguments: \(String(describing: arguments))")
        self.eventSink = nil
        self.progressEventSink = nil
        return nil
    }

    private func initializeDfu(_ arguments: [String: Any]?, result: FlutterResult) {
        print("initializeDfu called with arguments: \(String(describing: arguments))")
        result(nil)
    }

    override func applicationWillTerminate(_ application: UIApplication) {
        print("applicationWillTerminate called")
        activeUpgrade = nil
        eventSink?(nil)
        progressEventSink?(nil)
    }
}

private func registerPlugins(registry: FlutterPluginRegistry) {
    if !registry.hasPlugin("FlutterDownloaderPlugin") {
        FlutterDownloaderPlugin.register(with: registry.registrar(forPlugin: "FlutterDownloaderPlugin")!)
    }
}

func redirectLogsToDocuments() {
    let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
    let documentsDirectory = paths[0]
    let calendar = Calendar.current
    let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Date())
    guard let name = Bundle.main.infoDictionary?["CFBundleName"] as? String else { return }
    let fileName = String(format: "%@_%04d.%02d.%02d.log", name, components.year!, components.month!, components.day!)
    let logFilePath = (documentsDirectory as NSString).appendingPathComponent(fileName)
    freopen(logFilePath.cString(using: .ascii), "a+", stdout)
    freopen(logFilePath.cString(using: .ascii), "a+", stderr)
}
