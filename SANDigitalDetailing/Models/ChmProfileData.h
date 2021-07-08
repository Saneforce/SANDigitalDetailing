//
//  ChmProfileData.h
//  SANDigitalDetailing
//
//  Created by SANeForce.com on 20/01/19.
//  Copyright © 2019 SANeForce.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChmProfileData : NSObject
@property (nonatomic,weak) NSString* CustCode;
@property (nonatomic,weak) NSString* CustName;
@property (nonatomic,weak) NSString* Entry_location;

@property (nonatomic,assign) NSString* CnctPNm;
@property (nonatomic,assign) NSString* ChmTerr;
@property (nonatomic,assign) NSString* ChmCat;

@property (nonatomic,assign) NSString* ChmAdd1;
@property (nonatomic,assign) NSString* ChmCity;

@property (nonatomic,assign) NSString* ChmMob;
@property (nonatomic,assign) NSString* ChmPhone;
@property (nonatomic,assign) NSString* ChmEmail;


+(ChmProfileData *)sharedDatas;
-(void)clearChmProfile;
- (NSMutableDictionary *)toNSDictionary;

@end

NS_ASSUME_NONNULL_END
