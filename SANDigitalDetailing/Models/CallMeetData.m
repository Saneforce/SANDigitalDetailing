//
//  CallMeetData.m
//  SANAPP
//
//  Created by SANeForce.com on 27/06/16.
//  Copyright © 2016 SANeForce.com. All rights reserved.
//

#import "CallMeetData.h"

@implementation CallMeetData
static CallMeetData *CallMeet = NULL;
@synthesize Products,vstTime,ModTime,SF,SFName,signName;

+(CallMeetData *)sharedDatas{
    @synchronized (CallMeet) {
        if (!CallMeet || CallMeet==NULL) {
            CallMeet=[[CallMeetData alloc] init];
        }
        return CallMeet;
    }
}
-(void) clearCallMeet{
    @synchronized(CallMeet) {
        if (CallMeet != nil) {
            CallMeet = nil;
        }
    }
}
-(NSMutableDictionary *) getDataASDictionary
{
    NSMutableDictionary *data=[[NSMutableDictionary alloc]init];
    
    [data setValue:CallMeet.SF forKey:@"SF"];
    [data setValue:CallMeet.DataSF forKey:@"DataSF"];
    [data setValue:CallMeet.SFName forKey:@"SFName"];
    [data setValue:CallMeet.CustCode forKey:@"CustCode"];
    [data setValue:CallMeet.CustName forKey:@"CustName"];
    
    return data;
}
- (NSMutableDictionary *)toNSDictionary
{
    unsigned int count = 0;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithCapacity:count];
    for (int i = 0; i < count; i++) {
        NSString *key = [NSString stringWithUTF8String:property_getName(properties[i])];
        if (![key isEqualToString:@"SignImg"])
        {
        NSString *value = [self valueForKey:key];//NSLog(@"%@ : %@",key,value);
        if (value)
            [dictionary setObject:value forKey:key];
            
        }
    }
    free(properties);
    return dictionary;
}
@end
