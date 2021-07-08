//
//  SignatureView.m
//  SANDigitalDetailing
//
//  Created by SANeForce.com on 15/08/16.
//  Copyright © 2016 SANeForce.com. All rights reserved.
//

#import "SignatureView.h"

@implementation SignatureView
@synthesize lastContactPoint1, lastContactPoint2, currentPoint;
@synthesize imageFrame;
@synthesize fingerMoved;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
-(void)awakeFromNib{
    [super awakeFromNib];
    imageFrame = self.mySignatureImage.frame;
    self.mySignatureImage.backgroundColor = [UIColor clearColor];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    fingerMoved = NO;
    UITouch *touch = [touches anyObject];
    
    if ([touch tapCount] == 3) {
        self.mySignatureImage.image = nil;
        return;
    }
    
    [UIView animateWithDuration:0.6 animations:^
     {
         [self.signatureTextField setAlpha:0.1];
     }];
 
    currentPoint = [touch locationInView:self.mySignatureImage];
    lastContactPoint1 = [touch previousLocationInView:self.mySignatureImage];
    lastContactPoint2 = [touch previousLocationInView:self.mySignatureImage];
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    fingerMoved = YES;
    UITouch *touch = [touches anyObject];
    
    lastContactPoint2 = lastContactPoint1;
    lastContactPoint1 = [touch previousLocationInView:self.mySignatureImage];

    currentPoint = [touch locationInView:self.mySignatureImage];
    
    CGPoint midPoint1 = [self midPoint:lastContactPoint1 withPoint:lastContactPoint2];
    CGPoint midPoint2 = [self midPoint:currentPoint withPoint:lastContactPoint1];
    
    UIGraphicsBeginImageContext(imageFrame.size);
    
    [self.mySignatureImage.image drawInRect:CGRectMake(0, 0, imageFrame.size.width, imageFrame.size.height)];
    
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 3.0f);
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 0.0, 0.0, 0.0, 1.0);
    CGContextBeginPath(UIGraphicsGetCurrentContext());
    
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), midPoint1.x, midPoint1.y);
    CGContextAddQuadCurveToPoint(UIGraphicsGetCurrentContext(),
                                 lastContactPoint1.x, lastContactPoint1.y, midPoint2.x, midPoint2.y);
    
    CGContextSetMiterLimit(UIGraphicsGetCurrentContext(), 2.0);
    
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    
    self.mySignatureImage.image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    if ([touch tapCount] == 3) {
        self.mySignatureImage.image = nil;
        [UIView animateWithDuration:0.6 animations:^
         {
             [self.signatureTextField setAlpha:1.0];
         }];
        return;
    }
    
    if(!fingerMoved) {
        UIGraphicsBeginImageContext(imageFrame.size);
        [self.mySignatureImage.image drawInRect:CGRectMake(0, 0, imageFrame.size.width, imageFrame.size.height)];
        
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 3.0f);
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 0.0, 0.0, 0.0, 1.0);
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
        CGContextStrokePath(UIGraphicsGetCurrentContext());
        CGContextFlush(UIGraphicsGetCurrentContext());
        
        self.mySignatureImage.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
}

- (CGPoint) midPoint:(CGPoint )p0 withPoint: (CGPoint) p1 {
    return (CGPoint) {
        (p0.x + p1.x) / 2.0,
        (p0.y + p1.y) / 2.0
    };
}
- (void)beganSignature
{
        [UIView animateWithDuration:0.6 animations:^
         {
             [_signatureTextField setAlpha:0.2];
         }];
}

- (void) saveSignature:(NSString *)signFileName {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"Signatures"];
    
    NSError *error = nil;
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath])
        [[NSFileManager defaultManager] createDirectoryAtPath:filePath
                                  withIntermediateDirectories:NO
                                                   attributes:nil
                                                        error:&error];
    
    NSData *imageData = UIImagePNGRepresentation(self.mySignatureImage.image);
    NSString *fileName = [filePath stringByAppendingPathComponent:
                          [NSString stringWithFormat:@"%@.png", signFileName]];
    
    [fileManager createFileAtPath:fileName contents:imageData attributes:nil];
    NSLog(@"image saved");
}
- (void) ClearSign{
    self.mySignatureImage.image = nil;
    [UIView animateWithDuration:0.6 animations:^
     {
         [self.signatureTextField setAlpha:1.0];
     }];
    return;
}
@end

