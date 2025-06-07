//
//  RTKOTASDK.h
//  RTKOTASDK
//
//  Created by jerome_gu on 2019/1/28.
//  Copyright © 2022 Realtek. All rights reserved.
//

#import <TargetConditionals.h>
#if TARGET_OS_IOS
#import <UIKit/UIKit.h>

//! Project version number for RTKOTASDK.
FOUNDATION_EXPORT double RTKOTASDKVersionNumber;

//! Project version string for RTKOTASDK.
FOUNDATION_EXPORT const unsigned char RTKOTASDKVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <RTKOTASDK/PublicHeader.h>
#else
#endif

#import "RTKOTADeviceInfo.h"

// Binaries to be upgrade or installed in device
#import "RTKOTABin.h"
#import "RTKOTAInstalledBin.h"
#import "RTKOTAUpgradeBin.h"
#import "RTKOTAUpgradeBin+Available.h"

#import "RTKOTAError.h"

#import "RTKDFUUpgrade.h"
#import "RTKDFURoutine.h"
#import "RTKDFUConnectionUponGATT.h"
#import "RTKDFUConnectionUponiAP.h"
#import "RTKDFUManager.h"

// Legacy APIs for compability, not recommended to be use.
#import "RTKOTAProfile.h"
#import "RTKOTAPeripheral.h"
#import "RTKDFUPeripheral.h"
#import "RTKMultiDFUPeripheral.h"
