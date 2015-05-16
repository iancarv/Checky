//
//  BCBeacon.m
//  BiCom
//
//  Created by Dualk MacMini on 08/05/15.
//  Copyright (c) 2015 Dualk MacMini. All rights reserved.
//

#import "BCBeacon.h"

@implementation BCBeacon

- (instancetype)initWithName:(NSString *)name
                        uuid:(NSUUID *)uuid
                       major:(CLBeaconMajorValue)major
                       minor:(CLBeaconMinorValue)minor {
    if ( self = [super init] ) {
        _name = name;
        _uuid = uuid;
        _majorValue = major;
        _minorValue = minor;
        _lastProximity = CLProximityUnknown;
        return self;
    }
    return nil;
}

@end
