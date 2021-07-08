//
//  BaseViewController.h
//  DigtalDetail
//
//  Created by SANeForce.com on 30/06/16.
//  Copyright © 2016 SANeForce.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import <CoreLocation/CoreLocation.h>
#import <AVFoundation/AVFoundation.h>
#import <QuartzCore/QuartzCore.h>
#import <AVKit/AVKit.h>
#import "UserDetails.h"
#import "AppSetupData.h"
#import "TdayPlDetail.h"
#import "CallMeetData.h"
#import "MissedEntryData.h"
#import "TPEntryData.h"
#import "List.h"
#import "CVColor.h"
#import "TBSelectionBxCell.h"
#import "SANTheme.h"
#import "Config.h"
#import "Slide.h"
#import "SSZipArchive.h"
#import "WBService.h"
#import "KeyboardView.h"
#import "LocationDetail.h"
#import "DropdownTheme.h"
#import "UIBorderLabel.h"

// Header
@protocol MutableDeepCopying <NSObject>
-(id) mutableDeepCopy;
@end
@interface NSDictionary (MutableDeepCopy) <MutableDeepCopying>
@end
@interface NSArray (MutableDeepCopy) <MutableDeepCopying>
@end

@interface UIResponder (FirstResponder)
    +(id)currentFirstResponder;
@end
/*
@interface NSDate (Serialization)
- (NSString *)ms_toString;
+ (instancetype)ms_dateFromString:(NSString *)dateString;

@end
*/
@interface UIImage (Color)

+ (UIImage*)setBackgroundImageByColor:(UIColor *)backgroundColor withFrame:(CGRect )rect;


+ (UIImage*) replaceColor:(UIColor*)color inImage:(UIImage*)image withTolerance:(float)tolerance;

+(UIImage *)changeWhiteColorTransparent: (UIImage *)image;

+(UIImage *)changeColorTo:(NSMutableArray*) array Transparent: (UIImage *)image;

//resizing Stuff...
+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;

@end

@interface BaseViewController : NSObject
-(void)FocusErrorSrc:(UIControl *)SRCCtrl;
-(BOOL) saveImageAsJPG:(UIImage *)image andWithFileName:(NSString *)filname andDirectory:(NSString *)folder;
-(UIImage *) getImage:(NSString *)filename;
-(UIImage *) getProfileImage:(NSString *)filename;
+ (BOOL) slideFileExists: (NSString*)fileName;
+ (UIImage*)loadSlideImage:(NSString *) fileName;
+ (NSURLRequest*)loadSlideHTML:(NSString *) fileName;
+(BOOL) deleteDirectory:(NSString *)Folder;
+ (void)saveSlideImage: (UIImage*)image withFileName: (NSString*)fileName;
+(void) saveImage:(UIImage *)image withFileName:(NSString *)imageName ofType:(NSString *)extension inDirectory:(NSString *)folder;
+(UIImage *)imageFromPDFWithDocumentRef:(CGPDFDocumentRef)documentRef;
+(UIImage *) getVideoThumbnail:(NSURL *) vUrl;
+(NSString*) getSlidesDirectory;
+(void)downloadAndUnzip : (NSString *)sURL_p : (NSString *)sFolderName_p;
+(BOOL) createFolder:(NSString*)FolderName;
+ (NSDate *) addDate:(NSDate *)fromDate andType:(NSString *) type valueAhead:(NSUInteger) value;
+(NSString*)date2str:(NSDate*)myNSDateInstance onlyDate:(BOOL)onlyDate;
+(NSDate*)str2fulldate:(NSString*)dateStr;
+(NSDate*)str2date:(NSString*)dateStr;
+(NSString*)date2strDisplay:(NSDate*)myNSDateInstance onlyDate:(BOOL)onlyDate;
+(NSString*)str2Format:(NSString*)dateStr withFormat:(NSString *)format;
+(NSString*) getDateTime;
+(NSString *)convertDuration:(NSTimeInterval)Timevalue;
+(NSString *)calculateDuration:(NSDate *)oldTime secondDate:(NSDate *)currentTime;
+(NSData*) encryptString:(NSString*)plaintext withKey:(NSString*)key;
+(NSString*) decryptData:(NSData*)ciphertext withKey:(NSString*)key;
+(void)loadMasterData:(NSString *)DataSF completion:(void (^)())completionBlock
                error:(void (^)(NSString *errorMsg)) errorBlock;
+(void) hideProgress;
+(void) Toast:(NSString*) Message;
+ (CGFloat)directMetersFromCoordinate:(CLLocationCoordinate2D)from toCoordinate:(CLLocationCoordinate2D)to;
@end
