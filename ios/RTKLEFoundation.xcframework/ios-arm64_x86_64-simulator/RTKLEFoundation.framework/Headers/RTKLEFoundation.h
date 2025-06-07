//
//  RTKLEFoundation.h
//  RTKLEFoundation
//
//  Created by jerome_gu on 2019/1/7.
//  Copyright © 2022 Realtek. All rights reserved.
//
#import <Foundation/Foundation.h>

//! Project version number for RTKLEFoundation.
FOUNDATION_EXPORT double RTKLEFoundationVersionNumber;

//! Project version string for RTKLEFoundation.
FOUNDATION_EXPORT const unsigned char RTKLEFoundationVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <RTKLEFoundation/PublicHeader.h>

#import "RTKBTGeneralDefines.h"

#import "RTKProfileConnectionManager.h"
#import "RTKProfileConnection.h"
#import "RTKConnectionUponGATT.h"
#import "RTKConnectionUponiAP.h"
#import "RTKOperationWaitor.h"
#import "RTKCharacteristicOperate.h"
#import "RTKCharacteristicTRXTransport.h"

#import "RTKPacket.h"
#import "RTKPacketTransport.h"

#import "RTKActionAttempt.h"

#import "RTKPackageIDGenerator.h"
#import "RTKBTLogMacros.h"
#import "RTKError.h"

#import "RTKAccessorySessionTransport.h"

#import "RTKBatchDataSendReception.h"

/* UI */
//#import <RTKLEFoundation/RTKScanPeripheralViewController.h>

//#import <RTKLEFoundation/RTKFile.h>
//#import <RTKLEFoundation/RTKFileBrowseViewController.h>

/* Utilities */

#import "NSData+KKAES.h"
#import "NSData+CRC16.h"
#import "NSData+String.h"
#import "NSData+Generation.h"

#import "RTKProvisioningProfileExpirationCheck.h"

// Legacy APIs,
// deprecated, not recommended for new usage
#import "RTKLEPeripheral.h"
#import "RTKLEProfile.h"

#import "RTKPeripheralCharacteristicOperation.h"
#import "RTKLEPackage.h"
#import "RTKPackageCommunication.h"
#import "RTKCharacteristicReadWrite.h"
#import "RTKCommunicationDataReceiver.h"
#import "RTKCommunicationDataSender.h"

#import "RTKAttemptAction.h"

#import "RTKPackageIDGenerator.h"

#import "RTKAccessoryManager.h"
#import "RTKAccessory.h"
