//
//  BCConstants.h
//  BiCom
//
//  Created by Dualk MacMini on 08/05/15.
//  Copyright (c) 2015 Dualk MacMini. All rights reserved.
//

#ifndef BiCom_BCConstants_h
#define BiCom_BCConstants_h
@import CoreLocation;
static NSString* const kBeaconName = @"MiniBeacon_00799";
//D1C2ACCC-059E-9A43-D54B-9B4B452C340B
//E2C56DB5-DFFB-48D2-B060-D0F5A71096E0
static NSString* const kBeaconUUID = @"BEAC1356-1234-8654-9844-8DFDF9879879";
static CLBeaconMinorValue const kBeaconMinorValue = 0;
static CLBeaconMajorValue const kBeaconMajorValue = 11;

static NSString* const kDidRangeBeaconNotification = @"beaconranged";
static NSString* const kBeaconKey = @"baconKey";


#endif
