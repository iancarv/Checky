/**
 * Copyright (c) 2014, Parse, LLC. All rights reserved.
 *
 * You are hereby granted a non-exclusive, worldwide, royalty-free license to use,
 * copy, modify, and distribute this software in source code or binary form for use
 * in connection with the web services and APIs provided by Parse.

 * As with any software that integrates with the Parse platform, your use of
 * this software is subject to the Parse Terms of Service
 * [https://www.parse.com/about/terms]. This copyright notice shall be
 * included in all copies or substantial portions of the software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
 * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
 * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
 * IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 *
 */

#import "AppDelegate.h"

#import <Parse/Parse.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>

#import "LoginViewController.h"

#import "BCBeacon.h"
#import "BCConstants.h"

@import CoreLocation;

@implementation AppDelegate

#pragma mark -
#pragma mark UIApplicationDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _found = false;
    // ****************************************************************************
    // Fill in with your Parse credentials:
    // ****************************************************************************
     [Parse setApplicationId:@"bbvNJHfvOXZ33SwTCYAq08pqe8MkmgALRI9NZC5f" clientKey:@"4oc2kven0e6miA7k6eYeeHNjicFsyhqOZYkeTXc7"];

    // ****************************************************************************
    // Your Facebook application id is configured in Info.plist.
    // ****************************************************************************
    [PFFacebookUtils initializeFacebookWithApplicationLaunchOptions:launchOptions];

    // Override point for customization after application launch.
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[LoginViewController alloc] init]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]){
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
    }
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:kBeaconUUID];
    BCBeacon *_item = [[BCBeacon alloc] initWithName:kBeaconName uuid:uuid major:kBeaconMajorValue minor:kBeaconMinorValue];
    NSLog(@"%@", _item.uuid);
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    if([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [self.locationManager requestAlwaysAuthorization];
    }
    if([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self startMonitoringItem:_item];
    [self.locationManager startUpdatingLocation];
    return YES;
}

// ****************************************************************************
// App switching methods to support Facebook Single Sign-On.
// ****************************************************************************
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [FBSDKAppEvents activateApp];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}


- (CLBeaconRegion *)beaconRegionWithItem:(BCBeacon *)item {
    CLBeaconRegion *beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:item.uuid
                                                                           major:item.majorValue
                                                                           minor:item.minorValue
                                                                      identifier:item.name];
    //    CLBeaconRegion *beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:item.uuid
    //                                                                      identifier:item.name];
    return beaconRegion;
}

- (void)startMonitoringItem:(BCBeacon *)item {
    CLBeaconRegion *beaconRegion = [self beaconRegionWithItem:item];
    [self.locationManager startMonitoringForRegion:beaconRegion];
    [self.locationManager startRangingBeaconsInRegion:beaconRegion];
}

-(void)sendLocalNotificationWithMessage:(NSString*)message {
    if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive) {
        UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:@"Offer Warning"
                                                           message:message
                                                          delegate:nil
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil];
        [theAlert show];
    }
    else {
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        notification.alertBody = message;
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
}
#pragma mark CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error {
    NSLog(@"Failed monitoring region: %@", error);
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"Location manager failed: %@", error);
}
//[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(postWasCreated:) name:CCBCacambaCreatedNotification object:nil];

-(void)locationManager:(CLLocationManager *)manager didRangeBeacons:
(NSArray *)beacons inRegion:(CLBeaconRegion *)region {
    NSString *message = @"We have a HUGE offer waiting for you";
    if(beacons.count > 0) {
        CLBeacon *nearestBeacon = beacons.firstObject;
        if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive)
                [[NSNotificationCenter defaultCenter] postNotificationName:kDidRangeBeaconNotification
                                                                    object:nil
                                                                  userInfo:@{ kBeaconKey : nearestBeacon } ];
        else {
            switch(nearestBeacon.proximity) {
                case CLProximityUnknown:
                    _found = NO;
                    return;
                case CLProximityFar:
                    _found = NO;
                    return;
                default:
                    if (!_found) {
                        _found = YES;
                        [self sendLocalNotificationWithMessage:message];
                    }
                    break;
            }
        }
    }
}

@end
