//
//  TPEntryData.h
//  SANDigitalDetailing
//
//  Created by SANeForce.com on 17/12/17.
//  Copyright © 2017 SANeForce.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface TPEntryData : NSObject
@property (nonatomic,strong) NSString* SF;
@property (nonatomic,strong) NSString* SFName;
@property (nonatomic,assign) int Month;
@property (nonatomic,assign) int Year;
@property (nonatomic,assign) int Flag;
@property (nonatomic,strong) NSMutableArray* TPDates;

+(TPEntryData *)sharedDatas;
-(void)clearTPData;
-(NSMutableDictionary *) getDataASDictionary;
- (NSMutableDictionary *)toNSDictionary;
@end
