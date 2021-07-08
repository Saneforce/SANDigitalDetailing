//
//  ScribbleView.h
//  SANDigitalDetailing
//
//  Created by SANeForce.com on 09/09/18.
//  Copyright © 2018 SANeForce.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScribbleView : UIView
@property (nonatomic, strong) IBOutlet UIImageView *ScribbleBgImage;
@property (nonatomic, strong) IBOutlet UIImageView *myScribbleImage;
@property (nonatomic, assign) CGPoint lastContactPoint1, lastContactPoint2, currentPoint;
@property (nonatomic, assign) CGRect imageFrame;
@property (nonatomic, assign) BOOL fingerMoved;
@property (nonatomic, assign) UIColor* scribbleColor;


@property (nonatomic, assign) CGFloat red;
@property (nonatomic, assign) CGFloat green;
@property (nonatomic, assign) CGFloat blue;
@property (nonatomic, assign) CGFloat alpha;
@property (nonatomic, assign) NSString* wTool;

- (UIImage*) mergeImage:(UIImage*)first withImage:(UIImage*)second;
- (void) saveScribbleImage:(NSString *)scribbleFileName;
@end
