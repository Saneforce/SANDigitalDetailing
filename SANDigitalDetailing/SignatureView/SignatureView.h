//
//  SignatureView.h
//  SANDigitalDetailing
//
//  Created by SANeForce.com on 15/08/16.
//  Copyright © 2016 SANeForce.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kBeganSignature @"SignatureViewBeganSignature"

@interface SignatureView : UIView
@property (nonatomic, strong) IBOutlet UIImageView *mySignatureImage;
@property (nonatomic, strong) IBOutlet UITextField *signatureTextField;
@property (nonatomic, assign) CGPoint lastContactPoint1, lastContactPoint2, currentPoint;
@property (nonatomic, assign) CGRect imageFrame;
@property (nonatomic, assign) BOOL fingerMoved;
- (void) saveSignature:(NSString *)signFileName;
- (void) ClearSign;
@end
