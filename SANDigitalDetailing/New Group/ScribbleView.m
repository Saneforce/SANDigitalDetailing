//
//  ScribbleView.m
//  SANDigitalDetailing
//
//  Created by SANeForce.com on 09/09/18.
//  Copyright © 2018 SANeForce.com. All rights reserved.
//

#import "ScribbleView.h"

@implementation ScribbleView

@synthesize lastContactPoint1, lastContactPoint2, currentPoint;
@synthesize imageFrame;
@synthesize fingerMoved;

-(void)awakeFromNib{
    [super awakeFromNib];
    imageFrame = self.myScribbleImage.frame;
    self.myScribbleImage.backgroundColor = [UIColor clearColor];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    fingerMoved = NO;
    UITouch *touch = [touches anyObject];
    
    if ([touch tapCount] == 3) {
        self.myScribbleImage.image = nil;
        return;
    }
    currentPoint = [touch locationInView:self.myScribbleImage];
    lastContactPoint1 = [touch previousLocationInView:self.myScribbleImage];
    lastContactPoint2 = [touch previousLocationInView:self.myScribbleImage];
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    fingerMoved = YES;
    UITouch *touch = [touches anyObject];
    
    lastContactPoint2 = lastContactPoint1;
    lastContactPoint1 = [touch previousLocationInView:self.myScribbleImage];
    
    currentPoint = [touch locationInView:self.myScribbleImage];
    
    CGPoint midPoint1 = [self midPoint:lastContactPoint1 withPoint:lastContactPoint2];
    CGPoint midPoint2 = [self midPoint:currentPoint withPoint:lastContactPoint1];
    
    UIGraphicsBeginImageContext(imageFrame.size);
    
    [self.myScribbleImage.image drawInRect:CGRectMake(0, 0, imageFrame.size.width, imageFrame.size.height)];
    
    
    if (_scribbleColor==nil){
        UIColor *blackColor = [UIColor blackColor];
        [blackColor getRed: &_red
                   green: &_green
                    blue: &_blue
                   alpha: &_alpha];
    }
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    if([_wTool isEqualToString:@"E"]){
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 6.0f);
        CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeClear);
    }
    else{
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 3.0f);
    }
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(),  _red, _green, _blue, _alpha);
    CGContextBeginPath(UIGraphicsGetCurrentContext());
    
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), midPoint1.x, midPoint1.y);
    CGContextAddQuadCurveToPoint(UIGraphicsGetCurrentContext(),
                                 lastContactPoint1.x, lastContactPoint1.y, midPoint2.x, midPoint2.y);
    
    CGContextSetMiterLimit(UIGraphicsGetCurrentContext(), 2.0);
    
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    
    self.myScribbleImage.image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    if ([touch tapCount] == 3) {
        self.myScribbleImage.image = nil;
        return;
    }
    
    if(!fingerMoved) {
        UIGraphicsBeginImageContext(imageFrame.size);
        [self.myScribbleImage.image drawInRect:CGRectMake(0, 0, imageFrame.size.width, imageFrame.size.height)];
        
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 3.0f);
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 0.0, 0.0, 0.0, 1.0);
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
        CGContextStrokePath(UIGraphicsGetCurrentContext());
        CGContextFlush(UIGraphicsGetCurrentContext());
        
        self.myScribbleImage.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
}

- (CGPoint) midPoint:(CGPoint )p0 withPoint: (CGPoint) p1 {
    return (CGPoint) {
        (p0.x + p1.x) / 2.0,
        (p0.y + p1.y) / 2.0
    };
}

- (UIImage*)mergeImage:(UIImage*)first withImage:(UIImage*)second
{
    // get size of the first image
    CGImageRef firstImageRef = first.CGImage;
    CGFloat firstWidth = CGImageGetWidth(firstImageRef);
    CGFloat firstHeight = CGImageGetHeight(firstImageRef);
    
    // get size of the second image
    CGImageRef secondImageRef = second.CGImage;
    CGFloat secondWidth = CGImageGetWidth(secondImageRef);
    CGFloat secondHeight = CGImageGetHeight(secondImageRef);
    
    // build merged size
    CGSize mergedSize = CGSizeMake(MAX(firstWidth, secondWidth), MAX(firstHeight, secondHeight));
    
    // capture image context ref
    UIGraphicsBeginImageContext(mergedSize);
    
    //Draw images onto the context
    [first drawInRect:CGRectMake(0, 0, firstWidth, firstHeight)];
    [second drawInRect:CGRectMake(0, 0, secondWidth, secondHeight)];
    
    // assign context to new UIImage
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // end context
    UIGraphicsEndImageContext();
    
    return newImage;
}
- (void) saveScribbleImage:(NSString *)scribbleFileName {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"Scribbles"];
    
    NSError *error = nil;
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath])
        [[NSFileManager defaultManager] createDirectoryAtPath:filePath
                                  withIntermediateDirectories:NO
                                                   attributes:nil
                                                        error:&error];
    
    NSData *imageData = UIImageJPEGRepresentation([self mergeImage:self.ScribbleBgImage.image withImage:self.myScribbleImage.image],self.ScribbleBgImage.image.scale);
    NSString *fileName = [filePath stringByAppendingPathComponent:
                          [NSString stringWithFormat:@"%@.jpg", scribbleFileName]];
    
    [fileManager createFileAtPath:fileName contents:imageData attributes:nil];
    NSLog(@"image saved");
}
@end
