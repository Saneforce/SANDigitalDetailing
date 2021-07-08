//
//  TdayPlDetail.h
//  SANDigitalDetailing
//
//  Created by SANeForce.com on 16/07/16.
//  Copyright © 2016 SANeForce.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
@interface TdayPlDetail : NSObject


@property (nonatomic,retain) NSString* SFCode;
@property (nonatomic,retain) NSString* TPDt;
@property (nonatomic,retain) NSString* WT;
@property (nonatomic,retain) NSString* WTNm;

@property (nonatomic,retain) NSString* FWFlg;

@property (nonatomic,retain) NSString* SFMem;
@property (nonatomic,retain) NSString* HQNm;
@property (nonatomic,retain) NSString* Pl;
@property (nonatomic,retain) NSString* PlNm;
@property (nonatomic,retain) NSString* Rem;
@property (nonatomic,retain) NSString* location;


+(TdayPlDetail *) sharedTdayPlDetail;
- (NSMutableDictionary *)toNSDictionary;
@end
