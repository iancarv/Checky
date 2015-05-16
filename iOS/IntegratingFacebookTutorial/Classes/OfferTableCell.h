//
//  OfferTableCell.h
//  IntegratingFacebookTutorial
//
//  Created by Ian Carvalho on 16/05/15.
//
//

#import <UIKit/UIKit.h>



@interface OfferTableCell : UITableViewCell

@property (assign) BOOL isOpen;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextView *descriptionView;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@end
