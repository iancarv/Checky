//
//  LojasTableViewController.h
//  IntegratingFacebookTutorial
//
//  Created by Ian Carvalho on 16/05/15.
//
//

#import <UIKit/UIKit.h>
@import MapKit;
@interface LojasTableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate, MKMapViewDelegate>
@property (strong, nonatomic) MKMapView *mapView;
@property (strong, nonatomic) UITableView *tableView;
@end
