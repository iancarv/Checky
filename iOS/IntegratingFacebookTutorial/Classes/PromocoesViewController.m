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
#import "PromocoesViewController.h"
#import "OfferTableCell.h"


#import <Parse/Parse.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>

@implementation PromocoesViewController



#pragma mark -
#pragma mark Init

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

#pragma mark -
#pragma mark UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor colorWithWhite:250.0f/255.0f alpha:1.0f];
//    [self.tableView setBackgroundColor:[UIColor darkGrayColor]];
    // Load table header view from nib
//    [[NSBundle mainBundle] loadNibNamed:@"TableHeaderView" owner:self options:nil];

    // Add logout navigation bar button
    UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc] initWithTitle:@"Log Out"
                                                                     style:UIBarButtonItemStyleBordered
                                                                    target:self
                                                                    action:@selector(logoutButtonAction:)];
    [self.navigationController.navigationBar setTranslucent:YES];
    self.navigationItem.leftBarButtonItem = logoutButton;
    [self _loadData];
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return _offersArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"OfferTableCell";
    
    OfferTableCell *cell = (OfferTableCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"OfferTableCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell.descriptionView.text = _offersArray[indexPath.row][@"Desc"];
    [cell.descriptionView setTextColor:[UIColor whiteColor]];
    cell.titleLabel.text = _offersArray[indexPath.row][@"Titulo"];
    return cell;
}

#pragma mark -
#pragma mark Actions

- (void)logoutButtonAction:(id)sender {
    // Logout user, this automatically clears the cache
    [PFUser logOut];

    // Return to login view controller
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark Data

- (void)_loadData {
    PFQuery *query = [PFQuery queryWithClassName:@"Offer"];
    query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    if ([query hasCachedResult]) {
        [self.tableView reloadData];        
    }
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %d scores.", objects.count);
            _offersArray = objects;
            [self.tableView reloadData];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];

}

// Set received values if they are not nil and reload the table

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 201;
}

@end
