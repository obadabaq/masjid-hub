import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:nordic_dfu/nordic_dfu.dart';
import 'dart:io';

class FirmwareUpdateService {
  // Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Check for the latest firmware update
  Future<void> checkAndUpdateFirmware(String deviceId) async {
    try {
      // Fetch the latest firmware info from Firestore
      DocumentSnapshot<Map<String, dynamic>> doc = await _firestore
          .collection('updates')
          .doc('recent_version')
          .get();

      // Check if the 'version_path' field exists and is not empty
      String? versionPath = doc.data()?['version_path'];
      if (versionPath == null || versionPath.isEmpty) {
        print("No firmware update available.");
        return; // No update available
      }

      // Download the firmware file from Firebase Storage
      String firmwareFilePath = await downloadFirmwareFile(versionPath);

      // If the file is downloaded, start the DFU process
      if (firmwareFilePath.isNotEmpty) {
        await startFirmwareUpdate(deviceId, firmwareFilePath);
      } else {
        print("Failed to download firmware.");
      }
    } catch (e) {
      print("Error checking for firmware update: $e");
    }
  }

  // Download the firmware file from Firebase Storage
  Future<String> downloadFirmwareFile(String versionPath) async {
    try {
      // Firebase Storage reference to the firmware file
      final storageRef = FirebaseStorage.instance.ref().child(versionPath);

      // Get the local directory to save the file
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/firmware.zip'; // Assuming the firmware is a zip file

      // Download the file
      final File localFile = File(filePath);
      await storageRef.writeToFile(localFile);

      print('Firmware downloaded to $filePath');
      return filePath; // Return the local file path
    } catch (e) {
      print('Error downloading firmware: $e');
      return '';
    }
  }

  // Start the firmware update process using Nordic DFU
  Future<void> startFirmwareUpdate(String deviceId, String firmwareFilePath) async {
    try {
      // Start the DFU process with the correct method signature
      await NordicDfu().startDfu(
        deviceId,                // The ID (address) of the connected watch
        firmwareFilePath,         // Path to the downloaded firmware file
        fileInAsset: false,       // Specify that the file is not in assets

        // DFU Progress callback
        onProgressChanged: (deviceAddress, percent, speed, avgSpeed, currentPart, partsTotal) {
          print("DFU Progress: $percent%");
          // You can also update a progress bar in the UI here
        },

        // DFU Completed callback
        onDfuCompleted: (deviceAddress) {
          print("DFU Completed Successfully for device: $deviceAddress");
          // Handle completion (e.g., notify the user)
        },

        // DFU Error callback
        onError: (deviceAddress, error, errorType, errorCode) {
          print("DFU Error: $error on device: $deviceAddress");
          // Handle errors here
        },
      );
    } catch (e) {
      print("DFU Failed: $e");
    }
  }
}