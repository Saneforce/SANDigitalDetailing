//
//  DrPolicyData.m
//  SANDigitalDetailing
//
//  Created by SANeForce.com on 14/10/18.
//  Copyright © 2018 SANeForce.com. All rights reserved.
//

#import "DrPolicyData.h"

@implementation DrPolicyData
static DrPolicyData *DrPolicy = NULL;

+(DrPolicyData *)sharedDatas{
    @synchronized (DrPolicy) {
        if (!DrPolicy || DrPolicy==NULL) {
            DrPolicy=[[DrPolicyData alloc] init];
        }
        return DrPolicy;
    }
}
-(void)clearDrPolicy{
    @synchronized(self) {
        if (DrPolicy != nil) {
            DrPolicy = nil;
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
