//
//  DrPolicyData.h
//  SANDigitalDetailing
//
//  Created by SANeForce.com on 14/10/18.
//  Copyright © 2018 SANeForce.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

NS_ASSUME_NONNULL_BEGIN

@interface DrPolicyData : NSObject
@property (nonatomic,weak) NSString* CustCode;
@property (nonatomic,weak) NSString* CustName;
@property (nonatomic,weak) NSString* Entry_location;
@property (nonatomic,weak) NSString* Email;
@property (nonatomic,weak) NSString* vstTime;
@property (nonatomic,weak) NSString* signName;

@property (nonatomic,assign) BOOL PolicyAccept;
@property (nonatomic,assign) BOOL PlcyCntMngt;
@property (nonatomic,assign) BOOL PlcyProf;
@property (nonatomic,assign) BOOL PlcySemInv;


+(DrPolicyData *)sharedDatas;
-(void)clearDrPolicy;
- (NSMutableDictionary *)toNSDictionary;
@end

NS_ASSUME_NONNULL_END
