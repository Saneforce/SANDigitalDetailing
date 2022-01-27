//
//  BaseViewController.m
//  DigtalDetail
//
//  Created by SANeForce.com on 30/06/16.
//  Copyright © 2016 SANeForce.com. All rights reserved.
//
#import "AppDelegate.h"
#import "BaseViewController.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation NSData (AES256)

- (NSData *)AES256EncryptWithKey:(NSString *)key {
    // 'key' should be 32 bytes for AES256, will be null-padded otherwise
    char keyPtr[kCCKeySizeAES256+1]; // room for terminator (unused)
    bzero(keyPtr, sizeof(keyPtr)); // fill with zeroes (for padding)
    
    // fetch key data
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [self length];
    
    //See the doc: For block ciphers, the output size will always be less than or
    //equal to the input size plus the size of one block.
    //That's why we need to add the size of one block here
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    int *buffer = malloc(bufferSize);
    
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding,
                                          keyPtr, kCCKeySizeAES256,
                                          NULL /* initialization vector (optional) */,
                                          [self bytes], dataLength, /* input */
                                          buffer, bufferSize, /* output */
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        //the returned NSData takes ownership of the buffer and will free it on deallocation
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    
    free(buffer); //free the buffer;
    return nil;
}

- (NSData *)AES256DecryptWithKey:(NSString *)key {
    // 'key' should be 32 bytes for AES256, will be null-padded otherwise
    char keyPtr[kCCKeySizeAES256+1]; // room for terminator (unused)
    bzero(keyPtr, sizeof(keyPtr)); // fill with zeroes (for padding)
    
    // fetch key data
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [self length];
    
    //See the doc: For block ciphers, the output size will always be less than or
    //equal to the input size plus the size of one block.
    //That's why we need to add the size of one block here
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    int *buffer = malloc(bufferSize);
    
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding,
                                          keyPtr, kCCKeySizeAES256,
                                          NULL /* initialization vector (optional) */,
                                          [self bytes], dataLength, /* input */
                                          buffer, bufferSize, /* output */
                                          &numBytesDecrypted);
    
    if (cryptStatus == kCCSuccess) {
        //the returned NSData takes ownership of the buffer and will free it on deallocation
        return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
    }
    
    free(buffer); //free the buffer;
    return nil;
}

@end

static __weak id currentFirstResponder;
@implementation UIResponder (FirstResponder)
    +(id)currentFirstResponder {
         currentFirstResponder = nil;
         [[UIApplication sharedApplication] sendAction:@selector(findFirstResponder:) to:nil from:nil forEvent:nil];
         return currentFirstResponder;
    }
    -(void)findFirstResponder:(id)sender {
        currentFirstResponder = self;
    }
@end
/*
@implementation NSDate (Serialization)

static NSString *dateFormatWithMillis = @"yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ";
static NSString *dateFormatWithoutMillis = @"yyyy-MM-dd'T'HH:mm:ssZZZZZ";

- (NSString *)ms_toString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:dateFormatWithMillis];
    NSLocale *posix = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    [dateFormatter setLocale:posix];
    return [dateFormatter stringFromDate:self];
}

+ (instancetype)ms_dateFromString:(NSString *)dateString
{
    NSDate *date = nil;
    if (dateString)
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:dateFormatWithMillis];
        NSLocale *posix = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        [dateFormatter setLocale:posix];
        date = [dateFormatter dateFromString:dateString];
        // If we couldn't parse the date, it may have no milliseconds on the string.
        if (!date)
        {
            [dateFormatter setDateFormat:dateFormatWithoutMillis];
            date = [dateFormatter dateFromString:dateString];
        }
    }
    return date;
}

@end
*/


@interface UIImage (Orientation)

- (UIImage*)imageByNormalizingOrientation;

@end


@implementation UIImage (Orientation)

- (UIImage*)imageByNormalizingOrientation {
    
    if((self.imageOrientation == UIImageOrientationUp ||
         self.imageOrientation == UIImageOrientationUpMirrored))
        return self;
    CGSize imgsize = self.size;
    UIGraphicsBeginImageContext(imgsize);
    [self drawInRect:CGRectMake(0.0, 0.0, imgsize.width, imgsize.height)];
    UIImage* normalizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return normalizedImage;
}
- (UIImage *)fixrotation{
    if (self.imageOrientation == UIImageOrientationUp) return self;
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (self.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, self.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    
    CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.width, self.size.height,
                                             CGImageGetBitsPerComponent(self.CGImage), 0,
                                             CGImageGetColorSpace(self.CGImage),
                                             CGImageGetBitmapInfo(self.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.height,self.size.width), self.CGImage);
            break;
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.width,self.size.height), self.CGImage);
            break;
    }
    
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}
@end

@implementation UIImage (Color)
+ (UIImage* )setBackgroundImageByColor:(UIColor *)backgroundColor withFrame:(CGRect )rect{

    // tcv - temporary colored view
    UIView *tcv = [[UIView alloc] initWithFrame:rect];
    [tcv setBackgroundColor:backgroundColor];


    // set up a graphics context of button's size
    CGSize gcSize = tcv.frame.size;
    UIGraphicsBeginImageContext(gcSize);
    // add tcv's layer to context
    [tcv.layer renderInContext:UIGraphicsGetCurrentContext()];
    // create background image now
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
     UIGraphicsEndImageContext();

     return image;
//    [tcv release];

}

+ (UIImage*) replaceColor:(UIColor*)color inImage:(UIImage*)image withTolerance:(float)tolerance {
    CGImageRef imageRef = [image CGImage];

    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();

    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    NSUInteger bitmapByteCount = bytesPerRow * height;

    unsigned char *rawData = (unsigned char*) calloc(bitmapByteCount, sizeof(unsigned char));

    CGContextRef context = CGBitmapContextCreate(rawData, width, height,
                                                 bitsPerComponent, bytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);

    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);

    CGColorRef cgColor = [color CGColor];
    const CGFloat *components = CGColorGetComponents(cgColor);
    float r = components[0];
    float g = components[1];
    float b = components[2];
    //float a = components[3]; // not needed

    r = r * 255.0;
    g = g * 255.0;
    b = b * 255.0;

    const float redRange[2] = {
        MAX(r - (tolerance / 2.0), 0.0),
        MIN(r + (tolerance / 2.0), 255.0)
    };

    const float greenRange[2] = {
        MAX(g - (tolerance / 2.0), 0.0),
        MIN(g + (tolerance / 2.0), 255.0)
    };

    const float blueRange[2] = {
        MAX(b - (tolerance / 2.0), 0.0),
        MIN(b + (tolerance / 2.0), 255.0)
    };

    int byteIndex = 0;

    while (byteIndex < bitmapByteCount) {
        unsigned char red   = rawData[byteIndex];
        unsigned char green = rawData[byteIndex + 1];
        unsigned char blue  = rawData[byteIndex + 2];

        if (((red >= redRange[0]) && (red <= redRange[1])) &&
            ((green >= greenRange[0]) && (green <= greenRange[1])) &&
            ((blue >= blueRange[0]) && (blue <= blueRange[1]))) {
            // make the pixel transparent
            //
            rawData[byteIndex] = 0;
            rawData[byteIndex + 1] = 0;
            rawData[byteIndex + 2] = 0;
            rawData[byteIndex + 3] = 0;
        }

        byteIndex += 4;
    }

    UIImage *result = [UIImage imageWithCGImage:CGBitmapContextCreateImage(context)];

    CGContextRelease(context);
    free(rawData);

    return result;
}

+(UIImage *)changeWhiteColorTransparent: (UIImage *)image
{
    CGImageRef rawImageRef=image.CGImage;

    const CGFloat colorMasking[6] = {222.0f, 255.0f, 222.0f, 255.0f, 222.0f, 255.0f};

    UIGraphicsBeginImageContext(image.size);
    CGImageRef maskedImageRef=CGImageCreateWithMaskingColors(rawImageRef, colorMasking);
    {
        //if in iphone
        CGContextTranslateCTM(UIGraphicsGetCurrentContext(), 0.0, image.size.height);
        CGContextScaleCTM(UIGraphicsGetCurrentContext(), 1.0, -1.0);
    }

    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, image.size.width, image.size.height), maskedImageRef);
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    CGImageRelease(maskedImageRef);
    UIGraphicsEndImageContext();
    return result;
}

+(UIImage *)changeColorTo:(NSMutableArray*) array Transparent: (UIImage *)image
{
    CGImageRef rawImageRef=image.CGImage;

//    const float colorMasking[6] = {222, 255, 222, 255, 222, 255};

     const CGFloat colorMasking[6] = {[[array objectAtIndex:0] floatValue], [[array objectAtIndex:1] floatValue], [[array objectAtIndex:2] floatValue], [[array objectAtIndex:3] floatValue], [[array objectAtIndex:4] floatValue], [[array objectAtIndex:5] floatValue]};


    UIGraphicsBeginImageContext(image.size);
    CGImageRef maskedImageRef=CGImageCreateWithMaskingColors(rawImageRef, colorMasking);
    {
        //if in iphone
        CGContextTranslateCTM(UIGraphicsGetCurrentContext(), 0.0, image.size.height);
        CGContextScaleCTM(UIGraphicsGetCurrentContext(), 1.0, -1.0);
    }

    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, image.size.width, image.size.height), maskedImageRef);
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    CGImageRelease(maskedImageRef);
    UIGraphicsEndImageContext();
    return result;
}

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end


// Implementation
@implementation NSDictionary (MutableDeepCopy)
- (NSMutableDictionary *) mutableDeepCopy {
    NSMutableDictionary * returnDict = [[NSMutableDictionary alloc] initWithCapacity:self.count];
    NSArray * keys = [self allKeys];
    for(id key in keys) {
        id aValue = [self objectForKey:key];
        id theCopy = nil;
        if([aValue conformsToProtocol:@protocol(MutableDeepCopying)]) {
            theCopy = [aValue mutableDeepCopy];
        } else if([aValue conformsToProtocol:@protocol(NSMutableCopying)]) {
            theCopy = [aValue mutableCopy];
        } else if([aValue conformsToProtocol:@protocol(NSCopying)]){
            theCopy = [aValue copy];
        } else {
            theCopy = aValue;
        }
        [returnDict setValue:theCopy forKey:key];
    }
    return returnDict;
}
@end

@implementation NSArray (MutableDeepCopy)
-(NSMutableArray *)mutableDeepCopy {
    NSMutableArray *returnArray = [[NSMutableArray alloc] initWithCapacity:self.count];
    for(id aValue in self) {
        id theCopy = nil;
        if([aValue conformsToProtocol:@protocol(MutableDeepCopying)]) {
            theCopy = [aValue mutableDeepCopy];
        } else if([aValue conformsToProtocol:@protocol(NSMutableCopying)]) {
            theCopy = [aValue mutableCopy];
        } else if([aValue conformsToProtocol:@protocol(NSCopying)]){
            theCopy = [aValue copy];
        } else {
            theCopy = aValue;
        }
        [returnArray addObject:theCopy];
    }
    return returnArray;
}
@end




@implementation BaseViewController
int masil=0;NSString *allErrs=@"";bool Errflag=NO;
-(void)FocusErrorSrc:(UIControl *)SRCCtrl {
    CABasicAnimation *shake = [CABasicAnimation animationWithKeyPath:@"position"];
    [shake setDuration:0.1];
    [shake setRepeatCount:2];
    [shake setAutoreverses:YES];
    [shake setFromValue:[NSValue valueWithCGPoint:
                         CGPointMake(SRCCtrl.center.x - 5,SRCCtrl.center.y)]];
    [shake setToValue:[NSValue valueWithCGPoint:
                       CGPointMake(SRCCtrl.center.x + 5, SRCCtrl.center.y)]];
    [SRCCtrl.layer addAnimation:shake forKey:@"position"];
    
    CABasicAnimation *color = [CABasicAnimation animationWithKeyPath:@"borderColor"];
    color.fromValue = (id)[UIColor colorWithRed:1.000 green:0.353 blue:0.329 alpha:1.00].CGColor;
    color.toValue   = (id)[UIColor clearColor].CGColor;
    
    CABasicAnimation *width = [CABasicAnimation animationWithKeyPath:@"borderWidth"];
    width.fromValue = @6;
    width.toValue   = @0;
    
    CAAnimationGroup *both = [CAAnimationGroup animation];
    both.duration   = 1.0;
    both.animations = @[color, width];
    both.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    [SRCCtrl.layer addAnimation:both forKey:@"color and width"];
}
+(void) saveImage:(UIImage *)image withFileName:(NSString *)imageName ofType:(NSString *)extension inDirectory:(NSString *)folder {
    
    NSString *stringPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]stringByAppendingPathComponent:folder];
    // New Folder is your folder name
    NSError *error = nil;
    if (![[NSFileManager defaultManager] fileExistsAtPath:stringPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:stringPath withIntermediateDirectories:NO attributes:nil error:&error];
    
    NSString *fileName = [stringPath stringByAppendingFormat:@"/%@",imageName];
    
    if ([[extension lowercaseString] isEqualToString:@"png"]) {
        NSData *data = UIImagePNGRepresentation(image);
        [data writeToFile:fileName atomically:YES];
    } else if ([[extension lowercaseString] isEqualToString:@"jpg"] || [[extension lowercaseString] isEqualToString:@"jpeg"]) {
        NSData *data = UIImageJPEGRepresentation(image,image.scale);
        [data writeToFile:fileName atomically:YES];
    } else {
        NSLog(@"Image Save Failed\nExtension: (%@) is not recognized, use (PNG/JPG)", extension);
    }
}
-(BOOL) saveImageAsJPG:(UIImage *)image andWithFileName:(NSString *)filname andDirectory:(NSString *)folder
{
    NSString *stringPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]stringByAppendingPathComponent:folder];
    // New Folder is your folder name
    NSError *error = nil;
    if (![[NSFileManager defaultManager] fileExistsAtPath:stringPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:stringPath withIntermediateDirectories:NO attributes:nil error:&error];
    
    NSString *fileName = [stringPath stringByAppendingFormat:@"/%@.jpg",filname];
    NSData *data = UIImageJPEGRepresentation([image fixrotation],image.scale);
    [data writeToFile:fileName atomically:YES];
    return YES;
}
-(UIImage *) getImage:(NSString *)filename{
    UIImage *image=nil;
    NSString *stringPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingPathComponent:filename];
    if ([[NSFileManager defaultManager] fileExistsAtPath:stringPath]){
        image=[UIImage imageWithContentsOfFile:stringPath ] ;
        
    }
    return image;
}

/*- (BOOL)savePngFile:(UIImage *)image toPath:(NSString *)path {
    NSData *data = UIImagePNGRepresentation(image);
    int exifOrientation = [UIImage cc_iOSOrientationToExifOrientation:image.imageOrientation];
    NSDictionary *metadata = @{(__bridge id)kCGImagePropertyOrientation:@(exifOrientation)};
    NSURL *url = [NSURL fileURLWithPath:path];
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    if (!source) {
        return NO;
    }
    CFStringRef UTI = CGImageSourceGetType(source);
    CGImageDestinationRef destination = CGImageDestinationCreateWithURL((__bridge CFURLRef)url, UTI, 1, NULL);
    if (!destination) {
        CFRelease(source);
        return NO;
    }
    CGImageDestinationAddImageFromSource(destination, source, 0, (__bridge CFDictionaryRef)metadata);
    BOOL success = CGImageDestinationFinalize(destination);
    CFRelease(destination);
    CFRelease(source);
    return success;
}
*/
+(void)loadMasterData:(NSString *)DataSF completion:(void (^)())completionBlock
                error:(void (^)(NSString *errorMsg)) errorBlock{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    [SVProgressHUD showWithStatus:NSLocalizedString(@"LoadingMSG", @"Loading Masters...")];
    NSArray* SFsMaster=@[
                [[List alloc] initWithName:[[NSString alloc] initWithFormat:@"TerritoryDetails_%@.SANAPP",DataSF] andApiPath:@"GET/Territory" Parameters:nil],
                [[List alloc] initWithName:[[NSString alloc] initWithFormat:@"DoctorDetails_%@.SANAPP",DataSF] andApiPath:@"GET/Doctors" Parameters:nil],
                [[List alloc] initWithName:[[NSString alloc] initWithFormat:@"ChemistDetails_%@.SANAPP",DataSF] andApiPath:@"GET/Chemist" Parameters:nil],
                [[List alloc] initWithName:[[NSString alloc] initWithFormat:@"StockistDetails_%@.SANAPP",DataSF] andApiPath:@"GET/Stockist" Parameters:nil],
                [[List alloc] initWithName:[[NSString alloc] initWithFormat:@"UnlistedDR_%@.SANAPP",DataSF] andApiPath:@"GET/UnlistedDR" Parameters:nil],
                [[List alloc] initWithName:[[NSString alloc]  initWithFormat:@"Hospital_%@.SANAPP",DataSF] andApiPath:@"GET/Hospitals" Parameters:nil],
                [[List alloc] initWithName:[[NSString alloc] initWithFormat:@"JointWork_%@.SANAPP",DataSF] andApiPath:@"GET/JntWrk" Parameters:nil],
                [[List alloc] initWithName:[[NSString alloc] initWithFormat:@"DRVstDetails_%@.SANAPP",DataSF] andApiPath:@"GET/VstDR" Parameters:nil]
                ];
    
    masil=0;
    Errflag=NO;

    for(List* list in SFsMaster){
        [WBService SendServerRequest:list.apiPath withParameter:list.param withImages:nil DataSF:DataSF completion:^(BOOL success, id respData, NSMutableDictionary *DatawithImage){
            NSMutableDictionary *receivedDta=[NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingAllowFragments error:nil];
            [WBService saveData:receivedDta forKey:list.name];
            masil++;
            if (masil>=[SFsMaster count]) {
                if (Errflag==YES)
                {
                    if(errorBlock) errorBlock(allErrs);
                }
                if (completionBlock) {
                    completionBlock();
                }
                [self hideProgress];
            }
        }
        error:^(NSString *errorMsg, NSMutableDictionary *DatawithImage){
            NSLog(@"%@",errorMsg);
            allErrs=[NSString stringWithFormat:@"%@\n",errorMsg];
            Errflag=YES;
            masil++;
            if (masil>=[SFsMaster count]) {
                if (Errflag==YES)
                {
                    if(errorBlock) errorBlock(allErrs);
                }
                if (completionBlock) {
                    completionBlock();
                }
                [self hideProgress];
            }
        }];
    }
}
+(void) hideProgress{
    [SVProgressHUD dismiss];
}
-(UIImage *) getProfileImage:(NSString *)filename{
    UIImage *image=[self getImage:filename];
    if(!image){
        image=nil;//[UIImage imageNamed:@"profile"];
    }
    return image;
}
+(BOOL) deleteDirectory:(NSString *)Folder{
    BOOL success = [[NSFileManager defaultManager] removeItemAtPath:Folder error:nil];
    return success;
}
+(NSString*) getSlidesDirectory{
    NSArray *containingURLArr = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *containingURL = [containingURLArr objectAtIndex:0];
    NSString *SlidesDirectory = [containingURL stringByAppendingPathComponent:@"Slides"];
    return SlidesDirectory;
}

+ (BOOL) slideFileExists: (NSString*)fileName
{
    NSString *SlidesDirectory = [self getSlidesDirectory];
    NSString* path = [NSString stringWithFormat:@"%@",[SlidesDirectory stringByAppendingPathComponent:fileName]];
    return  [[NSFileManager defaultManager] fileExistsAtPath:path];
}
+ (NSURLRequest*)loadSlideHTML:(NSString *) fileName
{
    
    NSString *SlidesDirectory = [self getSlidesDirectory];
    
    NSString* path = [NSString stringWithFormat:@"%@",[SlidesDirectory stringByAppendingPathComponent:[fileName stringByReplacingOccurrencesOfString:@".zip" withString:@""]]];
    
    //NSArray *dirContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:SlidesDirectory error:nil];
    //NSString* path=[SlidesDirectory stringByAppendingPathComponent:dirContents[0]];
    
    
    NSArray *htmlFiles = [[[NSFileManager defaultManager]
                           contentsOfDirectoryAtPath:path error:nil] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"pathExtension='html'"]];
    
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@",path,htmlFiles[0]]] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:60];
    return urlRequest;
}

+ (UIImage*)loadSlideImage:(NSString *) fileName
{
    
    NSString *SlidesDirectory = [self getSlidesDirectory];
    
    NSString* path = [NSString stringWithFormat:@"%@",[SlidesDirectory stringByAppendingPathComponent:[fileName stringByReplacingOccurrencesOfString:@".zip" withString:@""]]];
    
   // NSArray *dirContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil]; //path
    UIImage* image = nil;
    NSArray *pngFiles = [[[NSFileManager defaultManager]
                           contentsOfDirectoryAtPath:path error:nil] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"pathExtension='png'"]];
    if([pngFiles count]>0){
        image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",path,pngFiles[0]]];
    }
    else{
        pngFiles = [[[NSFileManager defaultManager]
                              contentsOfDirectoryAtPath:path error:nil] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"pathExtension='jpg'"]];
        if([pngFiles count]>0){
            image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",path,pngFiles[0]]];
        }
    }
    return image;
}
+ (void)saveSlideImage: (UIImage*)image withFileName: (NSString*)fileName
{
    if (image != nil)
    {
        NSString *SlidesDirectory = [self getSlidesDirectory];
        
        //NSURL *containingURL = [[NSBundle mainBundle] resourceURL];
        //NSURL *SlidesDirectory = [containingURL URLByAppendingPathComponent:@"Slides" isDirectory:YES];
        
        BOOL isDir;
        NSError *error = nil;
        NSFileManager *fileManager= [NSFileManager defaultManager];
        if(![fileManager fileExistsAtPath:[NSString stringWithFormat:@"%@",SlidesDirectory] isDirectory:&isDir])
        {
            if(![fileManager createDirectoryAtPath:[NSString stringWithFormat:@"%@",SlidesDirectory] withIntermediateDirectories:YES attributes:nil error:&error]){
                NSLog(@"Error: Create folder failed %@", [NSString stringWithFormat:@"%@:%@",SlidesDirectory,error.description]);
            }else{
                NSLog(@"Folder Created %@",[NSString stringWithFormat:@"%@",SlidesDirectory]);
            }
        }
        NSString* path = [NSString stringWithFormat:@"%@",[SlidesDirectory stringByAppendingPathComponent:fileName]];
        
        NSData* data = UIImagePNGRepresentation(image);
        [data writeToFile:path atomically:YES];
    }
}

+ (UIImage *)imageFromPDFWithDocumentRef:(CGPDFDocumentRef)documentRef {
    @autoreleasepool {
    CGPDFPageRef pageRef = CGPDFDocumentGetPage(documentRef, 1);
    CGRect pageRect = CGPDFPageGetBoxRect(pageRef, kCGPDFCropBox);
    
    UIGraphicsBeginImageContext(pageRect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, CGRectGetMinX(pageRect),CGRectGetMaxY(pageRect));
    CGContextScaleCTM(context, 1, -1);
    CGContextTranslateCTM(context, -(pageRect.origin.x), -(pageRect.origin.y));
    CGContextDrawPDFPage(context, pageRef);
    
    UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();\
    UIGraphicsEndImageContext();
        return finalImage  ;
    }
}
+(UIImage *) getVideoThumbnail:(NSURL *) vUrl
{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:vUrl options:nil];
    AVAssetImageGenerator *generateImg = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    NSError *error = NULL;
    CMTime time = CMTimeMake(1, 65);
    CGImageRef refImg = [generateImg copyCGImageAtTime:time actualTime:NULL error:&error];
    NSLog(@"error==%@, Refimage==%@", error, refImg);
    
    return [[UIImage alloc] initWithCGImage:refImg];
    
}

+(BOOL) createFolder:(NSString*)FolderName{
    
    BOOL isDir;
    NSError *error = nil;
    NSFileManager *fileManager= [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:[NSString stringWithFormat:@"%@",FolderName] isDirectory:&isDir])
    {
        if(![fileManager createDirectoryAtPath:[NSString stringWithFormat:@"%@",FolderName] withIntermediateDirectories:YES attributes:nil error:&error]){
            NSLog(@"Error: Create folder failed %@", [NSString stringWithFormat:@"%@:%@",FolderName,error.description]);
            return false;
        }else{
            NSLog(@"Folder Created %@",[NSString stringWithFormat:@"%@",FolderName]);
        }
    }
    return true;
}

+(void)downloadAndUnzip : (NSString *)sURL_p : (NSString *)sFolderName_p
{
    dispatch_queue_t q = dispatch_get_global_queue(0, 0);
    dispatch_queue_t main = dispatch_get_main_queue();
    dispatch_async(q, ^{
        NSURL *url = [NSURL URLWithString:sURL_p];
        NSData *data = [NSData  dataWithContentsOfURL:url];
        NSString *fileName = [[url path] lastPathComponent];
        NSString *filePath = [NSTemporaryDirectory() stringByAppendingPathComponent:fileName];
        [data writeToFile:filePath atomically:YES];
        dispatch_async(main, ^
                       {
                           NSString *SlidesDirectory = [self getSlidesDirectory];
                           NSString *dataPath = [SlidesDirectory stringByAppendingPathComponent:sFolderName_p]; //[sFolderName_p stringByReplacingOccurrencesOfString:@".zip" withString:@""]];
                           [self createFolder:dataPath];
                           NSLog(@"%@",filePath);
                           [SSZipArchive unzipFileAtPath:filePath toDestination:dataPath];
                       });
    });
    
}
+(NSString*) getDateTime{
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateFormat setLocale:[NSLocale currentLocale]];
    return [dateFormat stringFromDate:date];
}
+(NSString*)date2strDisplay:(NSDate*)myNSDateInstance onlyDate:(BOOL)onlyDate{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if (onlyDate) {
        [formatter setDateFormat:@"dd-MM-yyyy"];
    }else{
        [formatter setDateFormat: @"dd-MM-yyyy HH:mm:ss"];
    }
    
    //Optionally for time zone conversions
    //   [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"..."]];
    
    NSString *stringFromDate = [formatter stringFromDate:myNSDateInstance];
    return stringFromDate;
}
+(NSString*)date2str:(NSDate*)myNSDateInstance onlyDate:(BOOL)onlyDate{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if (onlyDate) {
        [formatter setDateFormat:@"yyyy-MM-dd"];
    }else{
        [formatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    }
    
    //Optionally for time zone conversions
    //   [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"..."]];
    
    NSString *stringFromDate = [formatter stringFromDate:myNSDateInstance];
    return stringFromDate;
}
+(NSDate*)str2fulldate:(NSString*)dateStr{
    if ([dateStr isKindOfClass:[NSDate class]]) {
        return (NSDate*)dateStr;
    }
    //if([dateStr isMat])((\(\d{2}\) ?)|(\d{2}/))?\d{2}/\d{4} ([0-2][0-9]\:[0-6][0-9])
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
    NSDate *date = [dateFormat dateFromString:dateStr];
    return date;
}
+(NSDate*)str2date:(NSString*)dateStr{
    if ([dateStr isKindOfClass:[NSDate class]]) {
        return (NSDate*)dateStr;
    }
    //if([dateStr isMat])((\(\d{2}\) ?)|(\d{2}/))?\d{2}/\d{4} ([0-2][0-9]\:[0-6][0-9])
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date;
    if([dateFormat dateFromString:dateStr]){
        date = [dateFormat dateFromString:dateStr];
    }else{
        date = [dateFormat dateFromString:[NSString stringWithFormat:@"%@ 00:00:00",dateStr]];
    }
    return date;
}

+(NSString*)str2Format:(NSString*)dateStr withFormat:(NSString *)format{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormat dateFromString:dateStr];
    [dateFormat setDateFormat:format];
    
    NSString *stringFromDate = [dateFormat stringFromDate:date];
    return stringFromDate;
}
+ (NSDate *) addDate:(NSDate *)fromDate andType:(NSString *) type valueAhead:(NSUInteger) value
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    if([type isEqualToString:@"dd"])
        dateComponents.day = value;
    if([type isEqualToString:@"mm"])
        dateComponents.month = value;
    if([type isEqualToString:@"yyyy"])
        dateComponents.year = value;
    
    if([type isEqualToString:@"hh"])
        dateComponents.hour = value;
    if([type isEqualToString:@"mn"])
        dateComponents.minute = value;
    if([type isEqualToString:@"ss"])
        dateComponents.second = value;
        
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *previousDate = [calendar dateByAddingComponents:dateComponents
                                                     toDate:fromDate
                                                    options:0];
    //[dateComponents release];
    return previousDate;
}
+ (NSString *)convertDuration:(NSTimeInterval)Timevalue
{
    int hh = Timevalue / (60*60);
    double rem = fmod(Timevalue, (60*60));
    int mm = rem / 60;
    rem = fmod(rem, 60);
    int ss = rem;
    
    NSString *str = [NSString stringWithFormat:@"%02d:%02d:%02d",hh,mm,ss];
    return str;
}

+ (NSString *)calculateDuration:(NSDate *)oldTime secondDate:(NSDate *)currentTime
{
    NSDate *date1 = oldTime;
    NSDate *date2 = currentTime;
    
    NSTimeInterval secondsBetween = [date2 timeIntervalSinceDate:date1];
    
    int hh = secondsBetween / (60*60);
    double rem = fmod(secondsBetween, (60*60));
    int mm = rem / 60;
    rem = fmod(rem, 60);
    int ss = rem;
    
    NSString *str = [NSString stringWithFormat:@"%02d:%02d:%02d",hh,mm,ss];
    
    return str;
}


+ (NSData*) encryptString:(NSString*)plaintext withKey:(NSString*)key {
    return [[plaintext dataUsingEncoding:NSUTF8StringEncoding] AES256EncryptWithKey:key];
}

+ (NSString*) decryptData:(NSData*)ciphertext withKey:(NSString*)key {
    return [[NSString alloc] initWithData:[ciphertext AES256DecryptWithKey:key]
                                  encoding:NSUTF8StringEncoding];
}
+(void) Toast:(NSString*) Message
{
    /*AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = Message;
    label.font = [UIFont fontWithName:@"HelveticaNeue" size:17.0];
    label.adjustsFontSizeToFitWidth = true;
    [label sizeToFit];
    label.numberOfLines = 4;
    label.layer.shadowColor = [UIColor grayColor].CGColor;
    label.layer.shadowOffset = CGSizeMake(4, 3);
    label.layer.shadowOpacity = 0.3;
    label.frame = CGRectMake(320, 64, appDelegate.window.frame.size.width, 44);
    label.alpha = 1;
    label.backgroundColor = [UIColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:0.5];
    label.textColor = [UIColor whiteColor];
    
    [appDelegate.window addSubview:label];
    
    CGRect basketTopFrame  = label.frame;
    basketTopFrame.origin.x = 0;
    
    
    [UIView animateWithDuration:2.0 delay:0.0 usingSpringWithDamping:0.5 initialSpringVelocity:0.1 options:UIViewAnimationOptionCurveEaseOut animations: ^(void){
        label.frame = basketTopFrame;
    } completion:^(BOOL finished){
        [label removeFromSuperview];
    }
     ];
    */
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
        UIWindow * keyWindow = [[UIApplication sharedApplication] keyWindow];
        UILabel *toastView = [[UILabel alloc] initWithFrame:CGRectZero];
        toastView.text = NSLocalizedString(Message, Message);
        toastView.font = [SANTheme getToastHeaderFont];
        toastView.textColor = [SANTheme getToastTextColor];
        toastView.backgroundColor = [[SANTheme getToastBackgroundColor] colorWithAlphaComponent:0.5];
        toastView.textAlignment = NSTextAlignmentCenter;
        toastView.adjustsFontSizeToFitWidth = true;
        [toastView sizeToFit];
        toastView.frame = CGRectMake(0.0, 0.0, toastView.frame.size.width+50, toastView.frame.size.height+10.0);
        toastView.layer.cornerRadius = 10;
        toastView.layer.masksToBounds = YES;
        toastView.center = keyWindow.center;
        
        [keyWindow addSubview:toastView];
        
        [UIView animateWithDuration: 3.0f
                              delay: 1.0
                            options: UIViewAnimationOptionCurveEaseOut
                         animations: ^{
                             toastView.alpha = 0.0;
                         }
                         completion: ^(BOOL finished) {
                             [toastView removeFromSuperview];
                         }
         ];
    }];
    
    /*UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                               message:Message
                                                        preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alert animated:YES completion:nil];

    int duration = 1; // duration in seconds

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [alert dismissViewControllerAnimated:YES completion:nil];
    });*/
}
+ (CGFloat)directMetersFromCoordinate:(CLLocationCoordinate2D)from toCoordinate:(CLLocationCoordinate2D)to {
    CGFloat radlat1 = M_PI * from.latitude / 180;
    CGFloat radlat2 = M_PI * to.latitude / 180;
//    CGFloat radlon1 = M_PI * from.longitude / 180;
//    CGFloat radlon2 = M_PI * to.longitude / 180;
    CGFloat theta = from.longitude - to.longitude;
    CGFloat radtheta = M_PI * theta / 180;
    CGFloat dist = sin(radlat1) * sin(radlat2) + cos(radlat1) * cos(radlat2) * cos(radtheta);
    dist = acos(dist);
    dist = dist * 180 / M_PI;
    dist = dist * 60 * 1.1515;
//    if (unit == "K") {
    dist = dist * 1.609344;
//}
//    if (unit == "N") { dist = dist * 0.8684 }
    return dist;
/*    static const double DEG_TO_RAD = 0.017453292519943295769236907684886;
    static const double EARTH_RADIUS_IN_METERS = 6372797.560856;
    
    double latitudeArc  = (from.latitude - to.latitude) * DEG_TO_RAD;
    double longitudeArc = (from.longitude - to.longitude) * DEG_TO_RAD;
    double latitudeH = sin(latitudeArc * 0.5);
    latitudeH *= latitudeH;
    double lontitudeH = sin(longitudeArc * 0.5);
    lontitudeH *= lontitudeH;
    double tmp = cos(from.latitude*DEG_TO_RAD) * cos(to.latitude*DEG_TO_RAD);
    return EARTH_RADIUS_IN_METERS * 2.0 * asin(sqrt(latitudeH + tmp*lontitudeH));*/
}

@end

