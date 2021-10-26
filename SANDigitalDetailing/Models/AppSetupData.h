//
//  AppSetupData.h
//  SANDigitalDetailing
//
//  Created by SANeForce.com on 24/10/18.
//  Copyright © 2018 SANeForce.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

NS_ASSUME_NONNULL_BEGIN

@interface AppSetupData : NSObject
    @property (nonatomic,assign) int DrPolicy;
    @property (nonatomic,assign) int AddNewDrNeed;
    @property (nonatomic,assign) int inputMandate;
    @property (nonatomic,assign) int RCPAMandate;
    @property (nonatomic,assign) int GeoNeed;
    @property (nonatomic,assign) int GeoFencing;
    @property (nonatomic,assign) int DrNextVisit;
    @property (nonatomic,assign) int DrNextVisitMandate;

    @property (nonatomic,assign) int DrCallType;
    @property (nonatomic,assign) int DrCallTypeMandate;

    @property (nonatomic,assign) int SkipSlideDemo;

    @property (nonatomic,assign) int SmplQtyMnd;
    @property (nonatomic,assign) int RatingBasedSlide;
    @property (nonatomic,assign) int OnlyBRtFeed;
    @property (nonatomic,assign) int SampRating;
    @property (nonatomic,assign) int MaxStarRate;
    @property (nonatomic,assign) int GPSSegNeed;
    @property (nonatomic,assign) int MissedEntry;
    @property (nonatomic,assign) int ActivityNeed;
    @property (nonatomic,assign) int NActivityNeed;
    @property (nonatomic,assign) int DrActivityNeed;
    @property (nonatomic,assign) int ChmActivityNeed;
    @property (nonatomic,assign) int StkActivityNeed;
    @property (nonatomic,assign) int NdrActivityNeed;

    @property (nonatomic,assign) int DrSurveyNeed;
    @property (nonatomic,assign) int ChmSurveyNeed;
    @property (nonatomic,assign) int StkSurveyNeed;
    @property (nonatomic,assign) int NdrSurveyNeed;
    @property (nonatomic,assign) int showSurvey;

    @property (nonatomic,assign) int MeetEventNeed;
    @property (nonatomic,assign) int HospBased;
    
    @property (nonatomic,assign) NSString* CapCate;
    @property (nonatomic,assign) NSString* CapSpec;
    @property (nonatomic,assign) NSString* CapTerr;
    @property (nonatomic,assign) NSString* CapQua;
    @property (nonatomic,assign) NSString* CapSDP;
    @property (nonatomic,assign) NSString* CapDr;
    @property (nonatomic,assign) NSString* CapChm;
    @property (nonatomic,assign) NSString* CapStk;
    @property (nonatomic,assign) NSString* CapUdr;
    @property (nonatomic,assign) NSString* CapHos;

    +(AppSetupData *)sharedDatas;
@end

NS_ASSUME_NONNULL_END
