import Foundation
import CoreBluetooth
import RTKOTASDK
import Flutter

public class RTKOTASDKHandler: NSObject, RTKDFUUpgradeDelegate {
    private var upgrade: RTKDFUUpgrade?
    private var channel: FlutterMethodChannel?
    private var eventSink: FlutterEventSink?

    init(channel: FlutterMethodChannel, eventSink: FlutterEventSink?) {
        self.channel = channel
        self.eventSink = eventSink
    }

    func startUpgrade(peripheral: CBPeripheral, filePath: String) {
        upgrade = RTKDFUUpgrade(peripheral: peripheral)
        upgrade?.delegate = self

        do {
            let bins = try RTKOTAUpgradeBin.imagesExtracted(fromMPPackFilePath: filePath)
            upgrade?.upgrade(withImages: bins)
        } catch {
            sendEvent(["error": "Failed to extract images: \(error.localizedDescription)"])
        }
    }

    // Delegate Methods
    public func dfuUpgrade(_ upgrade: RTKDFUUpgrade, didUpdateProgress progress: Int) {
        sendEvent(["progress": progress])
    }

//     public func dfuUpgrade(_ upgrade: RTKDFUUpgrade, didChange state: RTKDFUState) {
//         sendEvent(["state": state.rawValue])
//     }

    public func dfuUpgrade(_ upgrade: RTKDFUUpgrade, didFinishUpgradeWithError error: Error?) {
        if let error = error {
            sendEvent(["error": error.localizedDescription])
        } else {
            sendEvent(["completed": true])
        }
    }

    private func sendEvent(_ data: [String: Any]) {
        DispatchQueue.main.async {
            self.eventSink?(data)
        }
    }
}