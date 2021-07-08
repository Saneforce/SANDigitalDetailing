//
//  CallMeetData.h
//  SANAPP
//
//  Created by SANeForce.com on 27/06/16.
//  Copyright © 2016 SANeForce.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface CallMeetData : NSObject
@property (nonatomic,strong) NSString* SF;
@property (nonatomic,strong) NSString* amc;
@property (nonatomic,retain) NSString* DataSF;
@property (nonatomic,retain) NSString* DataSFHQ;
@property (nonatomic,strong) NSString* SFName;
@property (nonatomic,retain) NSString* ARCode;
@property (nonatomic,retain) NSString* DivCode;
@property (nonatomic,retain) NSString* RMeetEndTime;
@property (nonatomic,retain) NSString* CustCode;
@property (nonatomic,retain) NSString* CustName;
@property (nonatomic,retain) NSString* Entry_location;
@property (nonatomic,retain) NSString* CusType;
@property (nonatomic,retain) NSString* Pl;
@property (nonatomic,retain) NSString* PlNm;
@property (nonatomic,retain) NSString* WT;
@property (nonatomic,retain) NSString* WTNm;
@property (nonatomic,retain) NSString* Remks;
@property (nonatomic,strong) NSString* EDate;
@property (nonatomic,strong) NSString* vstTime;
@property (nonatomic,strong) NSString* ModTime;
@property (nonatomic,retain) NSString* SpecCode;
@property (nonatomic,retain) NSString* CateCode;
@property (nonatomic,strong) NSString* signName;
@property (nonatomic,strong) NSString* CallType;
@property (nonatomic,strong) NSString* NxtVstDt;
@property (nonatomic,retain) NSString* mode;
@property (nonatomic,retain) NSString* RatingSlideIds;
@property (nonatomic,assign) BOOL MissedEntry;

@property (nonatomic,weak) NSString* mappedProds;
@property (nonatomic, strong) NSMutableArray* RatingSlide;
@property (nonatomic, strong) NSMutableArray* Products;
@property (nonatomic, strong) NSMutableArray* Inputs;
@property (nonatomic, strong) NSMutableArray* JWWrk;
@property (nonatomic, strong) NSMutableArray* AdCuss;
@property (nonatomic, strong) NSMutableArray* SubSlides;

@property (nonatomic, strong) NSMutableArray* RCPAEntry;
@property (nonatomic, strong) NSMutableArray* ActivityEntrys;
@property (nonatomic, strong) NSData* SignImg;


+(CallMeetData *)sharedDatas;
-(void) clearCallMeet;
-(NSMutableDictionary *) getDataASDictionary;
- (NSMutableDictionary *)toNSDictionary;
@end
