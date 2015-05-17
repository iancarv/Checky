//
//  OfferTableCell.m
//  IntegratingFacebookTutorial
//
//  Created by Ian Carvalho on 16/05/15.
//
//

#import "OfferTableCell.h"

@implementation OfferTableCell

- (void)awakeFromNib {
    // Initialization code
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    if (selected) {
        [UIView animateWithDuration:1
                              delay:0
                            options:UIViewAnimationCurveEaseInOut
                         animations:^ {
                             UIView *animateView = [self viewWithTag:1];
                             animateView.frame = CGRectMake(0, 0, animateView.frame.size.width, animateView.frame.size.height);
                         }completion:^(BOOL finished) {
                             
                         }];
    }
    else {
        [UIView animateWithDuration:1
                              delay:0
                            options:UIViewAnimationCurveEaseInOut
                         animations:^ {
                             UIView *animateView = [self viewWithTag:1];
                             animateView.frame = CGRectMake(0, 170, animateView.frame.size.width, animateView.frame.size.height);
                         }completion:^(BOOL finished) {
                             
                         }];
    }

    // Configure the view for the selected state
}

@end
