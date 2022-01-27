//
//  LocationDetail.h
//  SANDigitalDetailing
//
//  Created by SANeForce.com on 11/05/17.
//  Copyright © 2017 SANeForce.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LocationDetail : UIViewController
@property (nonatomic) NSString* latitude;
@property (nonatomic) NSString* longitude;
@property (nonatomic) NSString* lastUpdateTime;
@property (nonatomic) BOOL userSignedIn;
@property (nonatomic) NSMutableArray* TrackedLocationList;
+(LocationDetail *)sharedLocationData;
@end
