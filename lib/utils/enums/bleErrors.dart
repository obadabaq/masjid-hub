enum BleError { service, unknown, sendingCommand, response }

const Map<BleError, String> errorMessage = {
  BleError.service: "Error getting ble service. Tap here to go back",
  BleError.unknown: "Unknown Ble error occured. Tap here to go back",
  BleError.sendingCommand: "Error sending ble command. Tap here to go back",
  BleError.response: "Device responded with error. Tap here to go back",
};

const BleError defaultError = BleError.unknown;

extension BleErrorMessage on BleError {
  String get errMsg => errorMessage[this] ?? defaultError.errMsg;
}
