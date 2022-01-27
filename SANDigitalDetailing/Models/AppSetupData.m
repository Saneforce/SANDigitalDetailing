//
//  AppSetupData.m
//  SANDigitalDetailing
//
//  Created by SANeForce.com on 24/10/18.
//  Copyright © 2018 SANeForce.com. All rights reserved.
//

#import "AppSetupData.h"

@implementation AppSetupData
static AppSetupData *setupData = NULL;

+(AppSetupData *)sharedDatas{
    @synchronized (setupData) {
        if (!setupData || setupData==NULL) {
            setupData=[[AppSetupData alloc] init];
        }

        NSMutableArray* AppSetups=[[[NSUserDefaults standardUserDefaults] objectForKey:@"Settings.SANAPP"] mutableCopy];
        if([AppSetups count]>0){
            setupData.DrPolicy=[[AppSetups[0] valueForKey:@"DrPolicy"] intValue];
            setupData.inputMandate=[[AppSetups[0] valueForKey:@"DrInpMd"] intValue];
            setupData.RCPAMandate=[[AppSetups[0] valueForKey:@"RcpaNd"] intValue];
            setupData.GeoNeed=[[AppSetups[0] valueForKey:@"GeoNeed"] intValue];
            setupData.GeoFencing=[[AppSetups[0] valueForKey:@"GEOTagNeed"] intValue];
            setupData.DrNextVisit=[[AppSetups[0] valueForKey:@"DrNxtVst"] intValue];
            setupData.DrNextVisitMandate=[[AppSetups[0] valueForKey:@"DrNxtVstMd"] intValue];
            setupData.DrCallType=[[AppSetups[0] valueForKey:@"DrCallTyp"] intValue];
            setupData.DrCallTypeMandate=[[AppSetups[0] valueForKey:@"DrCallTypMd"] intValue];
            setupData.SkipSlideDemo=[[AppSetups[0] valueForKey:@"SkipSlideDemo"] intValue];
            setupData.OnlyBRtFeed=[[AppSetups[0] valueForKey:@"OnlyBRtFeed"] intValue];
            setupData.SampRating=[[AppSetups[0] valueForKey:@"SampRating"] intValue];
            setupData.MaxStarRate=[[AppSetups[0] valueForKey:@"MaxStarRate"] intValue];
            setupData.AddNewDrNeed=[[AppSetups[0] valueForKey:@"AddNewDrNeed"] intValue];
            setupData.GPSSegNeed=[[AppSetups[0] valueForKey:@"GPSSegNeed"] intValue];
            setupData.MissedEntry=[[AppSetups[0] valueForKey:@"MissedEntry"] intValue];
            setupData.SmplQtyMnd=[[AppSetups[0] valueForKey:@"SmplQtyMnd"] intValue];
            setupData.RatingBasedSlide=[[AppSetups[0] valueForKey:@"RatingBasedSlide"] intValue];
            setupData.MeetEventNeed=[[AppSetups[0] valueForKey:@"MeetEventNeed"] intValue];
            setupData.ActivityNeed=[[AppSetups[0] valueForKey:@"ActivityNeed"] intValue];
            setupData.NActivityNeed=[[AppSetups[0] valueForKey:@"NActivityNeed"] intValue];
            
            setupData.DrActivityNeed=[[AppSetups[0] valueForKey:@"DrActivityNeed"] intValue];
            setupData.ChmActivityNeed=[[AppSetups[0] valueForKey:@"ChmActivityNeed"] intValue];
            setupData.StkActivityNeed=[[AppSetups[0] valueForKey:@"StkActivityNeed"] intValue];
            setupData.NdrActivityNeed=[[AppSetups[0] valueForKey:@"NdrActivityNeed"] intValue];
            
            
            setupData.DrSurveyNeed=[[AppSetups[0] valueForKey:@"DrSurveyNeed"] intValue];
            setupData.ChmSurveyNeed=[[AppSetups[0] valueForKey:@"ChmSurveyNeed"] intValue];
            setupData.StkSurveyNeed=[[AppSetups[0] valueForKey:@"StkSurveyNeed"] intValue];
            setupData.NdrSurveyNeed=[[AppSetups[0] valueForKey:@"NdrSurveyNeed"] intValue];
            
            setupData.HospBased=[[AppSetups[0] valueForKey:@"HospBased"] intValue];
            
            setupData.CapCate=[AppSetups[0] valueForKey:@"CateName"];
            setupData.CapSpec=[AppSetups[0] valueForKey:@"SpecName"];
            setupData.CapTerr=[AppSetups[0] valueForKey:@"TerrName"];
            setupData.CapQua=[AppSetups[0] valueForKey:@"CapQua"];
            setupData.CapSDP=[AppSetups[0] valueForKey:@"CapChm"];
            setupData.CapDr=[AppSetups[0] valueForKey:@"DrCap"];
            setupData.CapChm=[AppSetups[0] valueForKey:@"ChmCap"];
            setupData.CapStk=[AppSetups[0] valueForKey:@"StkCap"];
            setupData.CapUdr=[AppSetups[0] valueForKey:@"NLCap"];
            setupData.CapHos=[AppSetups[0] valueForKey:@"HosCap"];
        }
        return setupData;
    }
}
- (NSMutableDictionary *)toNSDictionary
{
    unsigned int count = 0;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithCapacity:count];
    for (int i = 0; i < count; i++) {
        NSString *key = [NSString stringWithUTF8String:property_getName(properties[i])];
        
        NSString *value = [self valueForKey:key];//NSLog(@"%@ : %@",key,value);
        if (value)
            [dictionary setObject:value forKey:key];
    }
    free(properties);
    return dictionary;
}

@end
