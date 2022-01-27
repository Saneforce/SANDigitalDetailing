//
//  UserDetails.h
//  SANAPP
//
//  Created by SANeForce.com on 25/06/16.
//  Copyright © 2016 SANeForce.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDetails : NSObject

@property (nonatomic,retain) NSString* SF;
@property (nonatomic,retain) NSString* SFName;
@property (nonatomic,retain) NSString* Desig;
@property (nonatomic,retain) NSString* HQName;
@property (nonatomic,retain) NSString* DivCode;

#pragma Mark - Settings Variables
@property (nonatomic,assign) int GEOTagNeed;
@property (nonatomic,assign) float DistRadius;
@property (nonatomic,assign) BOOL RateEditable;
@property (nonatomic,assign) BOOL CPRateEditable;

- (instancetype)initWithAttributes:(NSDictionary *)UserDet;
+(UserDetails *) sharedUserDetails;
+(UserDetails *) sharedUserDetails:(NSDictionary *)UserDet;

@end
