//
//  DrProfileData.m
//  SANDigitalDetailing
//
//  Created by SANeForce.com on 19/10/18.
//  Copyright © 2018 SANeForce.com. All rights reserved.
//

#import "DrProfileData.h"

@implementation DrProfileData
static DrProfileData *DrProfData = NULL;

+(DrProfileData *)sharedDatas{
    @synchronized (DrProfData) {
        if (!DrProfData || DrProfData==NULL) {
            DrProfData=[[DrProfileData alloc] init];
        }
        return DrProfData;
    }
}
-(void)clearDrProfile{
    @synchronized(self) {
        if (DrProfData != nil) {
            DrProfData = nil;
        }
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
