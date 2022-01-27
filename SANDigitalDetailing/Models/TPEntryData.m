//
//  TPEntryData.m
//  SANDigitalDetailing
//
//  Created by SANeForce.com on 17/12/17.
//  Copyright © 2017 SANeForce.com. All rights reserved.
//

#import "TPEntryData.h"

@implementation TPEntryData
static TPEntryData *TPData = NULL;
@synthesize SF,SFName,Month,Year,Flag,TPDates;

+(TPEntryData *)sharedDatas{
    @synchronized (TPData) {
        if (!TPData || TPData==NULL) {
            TPData=[[TPEntryData alloc] init];
        }
        return TPData;
    }
}
-(void)clearTPData{
    @synchronized(self) {
        if (TPData != nil) {
            TPData = nil;
        }
    }
}
-(NSMutableDictionary *) getDataASDictionary
{
    NSMutableDictionary *data=[[NSMutableDictionary alloc]init];
    
    [data setValue:TPData.SF forKey:@"SF"];
    [data setValue:[NSString stringWithFormat:@"%i", TPData.Month] forKey:@"Month"];
    [data setValue:[NSString stringWithFormat:@"%i", TPData.Year] forKey:@"Year"];
    [data setValue:[NSString stringWithFormat:@"%i", TPData.Flag] forKey:@"Flag"];
    
    return data;
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
