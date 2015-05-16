//
//  BCBeacon.h
//  BiCom
//
//  Created by Dualk MacMini on 08/05/15.
//  Copyright (c) 2015 Dualk MacMini. All rights reserved.
//

#import <Foundation/Foundation.h>

@import CoreLocation;

@interface BCBeacon : NSObject

@property (strong, nonatomic, readonly) NSString *name;
@property (strong, nonatomic, readonly) NSUUID *uuid;
@property (assign, nonatomic, readonly) CLBeaconMajorValue majorValue;
@property (assign, nonatomic, readonly) CLBeaconMinorValue minorValue;
@property (assign, nonatomic) CLProximity lastProximity;

- (instancetype)initWithName:(NSString *)name
                        uuid:(NSUUID *)uuid
                       major:(CLBeaconMajorValue)major
                       minor:(CLBeaconMinorValue)minor;
@end
