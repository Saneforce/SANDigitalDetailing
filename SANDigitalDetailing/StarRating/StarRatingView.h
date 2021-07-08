//
//  StarRatingView.h
//  StarRatingDemo
//
//  Created by SANeForce.com on 04/07/16.
//  Copyright © 2016 SANeForce.com. All rights reserved.
//


#import <UIKit/UIKit.h>
@class StarRatingView;

@protocol StarRatingViewDelegate
-(void)didSetRating: (StarRatingView *) starRating andUserEvent:(BOOL)userEvent;

@end
@interface StarRatingView : UIView
@property (nonatomic,assign) int Value;
@property (nonatomic, weak) id<StarRatingViewDelegate> delegate;
-(void) setRatingValue:(int)value;
//- (id)initWithFrame:(CGRect)frame andRating:(int)rating withLabel:(BOOL)label animated:(BOOL)animated;
@end
