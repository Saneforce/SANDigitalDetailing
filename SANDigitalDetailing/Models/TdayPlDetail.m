//
//  TdayPlDetail.m
//  SANDigitalDetailing
//
//  Created by SANeForce.com on 16/07/16.
//  Copyright © 2016 SANeForce.com. All rights reserved.
//

#import "TdayPlDetail.h"

@implementation TdayPlDetail
static TdayPlDetail *TPlDet= NULL;

+(TdayPlDetail *)sharedTdayPlDetail{
    @synchronized (TPlDet) {
        if (!TPlDet || TPlDet==NULL) {
            TPlDet=[[TdayPlDetail alloc] init];
        }
        
        NSMutableDictionary* TPData= [[[NSUserDefaults standardUserDefaults] objectForKey:@"MyTodayplan.SANAPP"] mutableCopy];
        if(TPData!=nil){
            TPlDet.SFCode=[TPData valueForKey:@"SFCode"];
            TPlDet.TPDt=[TPData valueForKey:@"TPDt"];
            TPlDet.FWFlg=[TPData valueForKey:@"FWFlg"];
            TPlDet.SFMem=[TPData valueForKey:@"SFMem"];
            TPlDet.HQNm=[TPData valueForKey:@"HQNm"];
            TPlDet.WT=[TPData valueForKey:@"WT"];
            TPlDet.WTNm=[TPData valueForKey:@"WTNm"];
            TPlDet.Pl=[TPData valueForKey:@"Pl"];
            TPlDet.PlNm=[TPData valueForKey:@"PlNm"];
            TPlDet.Rem=[TPData valueForKey:@"Rem"];
            TPlDet.location=[TPData valueForKey:@"location"];
        }
        return TPlDet;
    }
}
- (NSMutableDictionary *)toNSDictionary
{
    unsigned int count = 0;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithCapacity:count];
    for (int i = 0; i < count; i++) {
        NSString *key = [NSString stringWithUTF8String:property_getName(properties[i])];
        NSString *value = [self valueForKey:key];
        if (value)
            [dictionary setObject:value forKey:key];
    }
    free(properties);
    return dictionary;
}

@end
