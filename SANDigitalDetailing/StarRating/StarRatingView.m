//
//  StarRatingView.m
//  StarRatingDemo
//
//  Created by SANeForce.com on 04/07/16.
//  Copyright © 2016 SANeForce.com. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "StarRatingView.h"
#define kLeftPadding 5.0f

@interface StarRatingView()
@property (nonatomic) int userRating;
@property (nonatomic) int maxrating;
@property (nonatomic) int rating;
@property (nonatomic) BOOL animated;
@property (nonatomic) float kLabelAllowance;
@property (nonatomic,strong) NSTimer* timer;
@property (nonatomic,strong) UILabel* label;
@property (nonatomic,strong) CALayer* tintLayer;

@property (nonatomic) BOOL callbk;

@end

@implementation StarRatingView
@synthesize timer;
@synthesize kLabelAllowance;
@synthesize tintLayer;
- (id)initWithFrame:(CGRect)frame //andRating:(int)rating withLabel:(BOOL)label animated:(BOOL)animated
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
-(void)awakeFromNib{
    [super awakeFromNib];
    int rating=0;self.Value=0;
    BOOL label=false;
    BOOL animated=true;
    if (self) {
        self.opaque = NO;
        
        _maxrating = rating;
        self.animated = animated;
        
        
        if (label) {
            self.kLabelAllowance = 50.0f;
            self.label = [[UILabel alloc]initWithFrame:CGRectMake(self.bounds.size.width-kLabelAllowance , 0,kLabelAllowance, self.frame.size.height)];
            
            self.label.font = [UIFont systemFontOfSize:18.0f];
            self.label.text = [NSString stringWithFormat:@"%d%%",rating];
            self.label.textAlignment = NSTextAlignmentRight;
            self.label.textColor = [UIColor blackColor];
            self.label.backgroundColor = [UIColor clearColor];
            [self addSubview:self.label];
        }else{
            self.kLabelAllowance = 10.0f;
        }
        self.callbk=true;
        
        CGRect newrect = CGRectMake(0, 1, self.bounds.size.width-kLabelAllowance, self.bounds.size.height-5);
        
        
        CALayer* starBackground = [CALayer layer];
        starBackground.contents = (__bridge id)([UIImage imageNamed:@"5starsgray"].CGImage);
        starBackground.frame = newrect;
        [self.layer addSublayer:starBackground];
        
        tintLayer = [CALayer layer];
        tintLayer.frame = CGRectMake(0, 1, 0, self.bounds.size.height-5);
        if (self.userRating >=20.0f) {
            [tintLayer setBackgroundColor:[UIColor colorWithRed:200/255.0f green:171/255.0f blue:0/255.0f alpha:1].CGColor];
        }else{
            [tintLayer setBackgroundColor:[UIColor yellowColor].CGColor];
        }
        
        [self.layer addSublayer:tintLayer];
        CALayer* starMask = [CALayer layer];
        starMask.contents = (__bridge id)([UIImage imageNamed:@"5starsgray"].CGImage);
        starMask.frame = newrect;
        [self.layer addSublayer:starMask];
        tintLayer.mask = starMask;
        
        
        if (self.animated) {
            _rating = 0;
            timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(increaseRating) userInfo:nil repeats:YES];
            [self performSelector:@selector(ratingDidChange:) withObject:nil afterDelay:0.1];
        }else{
            _rating = _maxrating;
            NSLog(@"setting rating");
        }
    }
}

-(void) setRatingValue:(int)value{
    self.userRating = value*20.0f;
    self.rating = self.userRating;
    _callbk=false;
    [self ratingDidChange:NO];
}

-(void)increaseRating
{
    
    if (_rating<_maxrating) {
        _rating = _rating + 1;
        if (self.label) {
            self.label.text = [NSString stringWithFormat:@"%d%%",self.rating];
        }
    }else{
        [timer invalidate];
    }
}


-(void)ratingDidChange:(BOOL)userEvent
{
    if (self.userRating < 20.0f) {
        [self.tintLayer setBackgroundColor:[UIColor yellowColor].CGColor];
        float barWitdhPercentage = (_maxrating/100.0f) *  (self.bounds.size.width-kLabelAllowance);
        self.tintLayer.frame = CGRectMake(0, 0, barWitdhPercentage, self.frame.size.height);
    }else{
        [self.tintLayer setBackgroundColor:[UIColor colorWithRed:200/255.0f green:171/255.0f blue:0/255.0f alpha:1].CGColor];
        //[self.tintLayer setBackgroundColor:[UIColor greenColor].CGColor];
        float barWitdhPercentage = (_rating/100.0f) *  (self.bounds.size.width-kLabelAllowance);
        self.tintLayer.frame = CGRectMake(0, 0, barWitdhPercentage, self.frame.size.height);
        
    }
    self.Value=self.userRating/20.f;
    if (self.callbk==true) {
        [self.delegate didSetRating:self  andUserEvent:userEvent];
    }
    self.callbk=true;
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{

    if (CGRectContainsPoint(self.bounds, [[[touches allObjects]lastObject] locationInView:self])) {
        
        float xpos = [[[touches allObjects]lastObject] locationInView:self].x - kLeftPadding;
        int star = MIN(4,xpos/((self.bounds.size.width-kLabelAllowance-kLeftPadding)/5.0f));
        if (xpos < kLeftPadding) {
            if (self.userRating == 20.0f) {
                self.userRating = 0.0f;
                if (self.animated) {
                    self.rating = 0;
                    timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(increaseRating) userInfo:nil repeats:YES];
                }else{
                    self.rating = self.maxrating;
                    if (self.label) {
                        self.label.text = [NSString stringWithFormat:@"%d%%",self.rating];
                    }
                }
            }
        }else{
            self.userRating = (star+1)*20.0f;
            self.rating = self.userRating;
            if (self.label) {
                self.label.text = [NSString stringWithFormat:@"%d%%",self.rating];
            }
        }
        [self ratingDidChange:YES];
        
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    if (CGRectContainsPoint(self.bounds, [[[touches allObjects]lastObject] locationInView:self])) {
        
        float xpos = [[[touches allObjects]lastObject] locationInView:self].x - kLeftPadding;
        int star = MIN(4,xpos/((self.bounds.size.width-kLabelAllowance-kLeftPadding)/5.0f));
        if (star == 0) {
            if (self.userRating == 20.0f) {
                self.userRating = 0.0f;
                self.rating = self.maxrating;
            }else{
                self.userRating = (star+1)*20.0f;
                self.rating = self.userRating;
            }
        }else{
            self.userRating = (star+1)*20.0f;
            self.rating = self.userRating;
        }
        [self ratingDidChange:YES];
        
        if (self.label) {
            self.label.text = [NSString stringWithFormat:@"%d%%",self.rating];
        }
        
    }
}


@end
