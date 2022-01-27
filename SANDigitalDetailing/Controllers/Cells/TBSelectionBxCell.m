//
//  TBSelectionBxCell.m
//  SANAPP
//
//  Created by SANeForce.com on 17/06/16.
//  Copyright © 2016 SANeForce.com. All rights reserved.
//

#import "TBSelectionBxCell.h"
@implementation TBSelectionBxCell
//int prvIndex=-1;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
-(void)awakeFromNib{
    
    
    self.starRating.delegate = self;
       //UITapGestureRecognizer* gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setAlphaCell:)];
    //[self.lOptImg setUserInteractionEnabled:YES];
    //[self.lOptImg addGestureRecognizer:gesture];
    //self.lOptText.textColor = [UIColor blueColor];
    //self.lOptText.font = [UIFont fontWithName:@"Avenir-Black" size:20.0f];
}
-(void)didSetRating:(StarRatingView *)starRating andUserEvent:(BOOL)userEvent{
    UITableView *tbView=(UITableView *)self.superview;
    if(![tbView isKindOfClass: [UITableView class]]) tbView=(UITableView *)self.superview.superview;
    if(![tbView isKindOfClass: [UITableView class]]) tbView=(UITableView *)self.superview.superview.superview;
    NSIndexPath *indexPath = [(UITableView *)tbView indexPathForCell: self];
    [self.delegate didSetRating:starRating andIndexPath:indexPath andUserEvent:userEvent];
}
-(void) setRatingValue:(int)value{
    [self.starRating setRatingValue:value];
}



//-(void) setAlphaCell:(UIGestureRecognizer *)sender{
//    NSLog(@"tapped,..");
//    
//    NSIndexPath *indexPath = [(UITableView *)self.superview.superview indexPathForCell: self];
//    if (prvIndex==indexPath.row && self.Checked==true){
//        [self.lOptImg setAlpha:0.2f];
//        self.Checked=false;
//    }
//    else if(prvIndex!=indexPath.row && self.Checked==true){
//        prvIndex=indexPath.row;
//        self.Checked=true;
//        [self performSelector:@selector(ResetIndex) withObject:nil afterDelay:0.5];
//    }
//    else{
//        [self.lOptImg setAlpha:1.0f];self.Checked=true;
//    }
//        [self.delegate didChecked:self andIndexPath:indexPath];
//    
//}
//-(void)ResetIndex{
//prvIndex=-1;
//}

@end
