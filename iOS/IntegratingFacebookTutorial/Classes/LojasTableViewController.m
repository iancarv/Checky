//
//  LojasTableViewController.m
//  IntegratingFacebookTutorial
//
//  Created by Ian Carvalho on 16/05/15.
//
//

#import "LojasTableViewController.h"
#import "PromocoesViewController.h"
#import "TopAnnotationView.h"
@interface LojasTableViewController ()
@property (strong, nonatomic) NSArray *storeArray;
@property (assign) NSInteger addingPosition;
@end

@implementation LojasTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Checky";
    _storeArray = @[
                            @{@"Nome": @"Bea-Cafe",
                              @"Imagem": @"houses_0000_forrst.png",
                              @"Endereco": @"Rua Leopoldo Couto Magalhães Júnior 700",
                              @"lat": @-23.5877211,
                              @"lon": @-46.6793484},
                            @{@"Nome": @"Chinatown",
                              @"Imagem": @"houses_0001_rss",
                              @"Endereco": @"Rua Leopoldo Couto Magalhães Júnior 1000",
                              @"lat": @-23.5806211,
                              @"lon": @-46.6781484},
                            @{@"Nome": @"Costco",
                              @"Imagem": @"houses_0002_dribbble",
                              @"Endereco": @"Rua Leopoldo Couto Magalhães Júnior 600",
                              @"lat": @-23.5907211,
                              @"lon": @-46.6783484},
                            @{@"Nome": @"Best Of Buy",
                              @"Imagem": @"houses_0003_lastfm",
                              @"Endereco": @"Rua Leopoldo Couto Magalhães Júnior 500",
                              @"lat": @-23.5887211,
                              @"lon": @-46.6824484},
                            @{@"Nome": @"TopCo",
                              @"Imagem": @"houses_0004_Twitter",
                              @"Endereco": @"Rua Leopoldo Couto Magalhães Júnior 400",
                              @"lat": @-23.5878211,
                              @"lon": @-46.6801484},
                            @{@"Nome": @"Compra Tudo",
                              @"Imagem": @"houses_0005_Facebook",
                              @"Endereco": @"Rua Leopoldo Couto Magalhães Júnior 300",
                              @"lat": @-23.58768211,
                              @"lon": @-46.6814284}
                            ];
    

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height/2) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height/2, self.view.frame.size.width, self.view.frame.size.height/2)];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(-23.5877211, -46.6793484), 1000, 1000);
    
    // set the region like normal
    [_mapView setRegion:region animated:YES];
    _mapView.delegate = self;
    [self.view addSubview:_mapView];
    for (NSDictionary *dict in _storeArray) {
        NSLog(@"DOUBLE %f", [dict[@"lat"] floatValue]);
        TopAnnotationView *point = [[TopAnnotationView alloc] init];
        
        CLLocation *location = [[CLLocation alloc] initWithLatitude:[dict[@"lat"] floatValue] longitude:[dict[@"lon"] floatValue]];
        NSLog(@"DOUBLE %@", location);
        point.coordinate = location.coordinate;
        point.title = dict[@"Nome"];
        point.image = [UIImage imageNamed:dict[@"Imagem"]];
        [self.mapView addAnnotation:point];
        _addingPosition++;
    }
        _mapView.showsUserLocation = YES;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return _storeArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"reuseIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    cell.textLabel.text = _storeArray[indexPath.row][@"Nome"];
    cell.detailTextLabel.text = _storeArray[indexPath.row][@"Nome"];
    cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
    cell.imageView.image = [UIImage imageNamed:_storeArray[indexPath.row][@"Imagem"]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    PromocoesViewController *nextVC = [[PromocoesViewController alloc] initWithStyle:UITableViewStylePlain];
    [self.navigationController pushViewController:nextVC animated:YES];
    nextVC.title = _storeArray[indexPath.row][@"Nome"];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapview viewForAnnotation:(id <MKAnnotation>)annotation
{
    
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    NSLog(@"View for");
    static NSString* AnnotationIdentifier = @"AnnotationIdentifier";
    MKAnnotationView *annotationView = [mapview dequeueReusableAnnotationViewWithIdentifier:AnnotationIdentifier];
    if(annotationView) {
        return annotationView;
    }
    else
    {
        TopAnnotationView *topAnnotation = (TopAnnotationView *)annotation;
        MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:topAnnotation
                                                                         reuseIdentifier:AnnotationIdentifier];
        annotationView.canShowCallout = YES;
        annotationView.image = topAnnotation.image;
        UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
//        [rightButton addTarget:self action:@selector(writeSomething:) forControlEvents:UIControlEventTouchUpInside];
        [rightButton setTitle:topAnnotation.title forState:UIControlStateNormal];
        annotationView.rightCalloutAccessoryView = rightButton;
        annotationView.canShowCallout = YES;
//        annotationView.draggable = YES;
        return annotationView;
    }
    return nil;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
