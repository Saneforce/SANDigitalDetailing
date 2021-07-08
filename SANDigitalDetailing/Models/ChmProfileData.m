//
//  ChmProfileData.m
//  SANDigitalDetailing
//
//  Created by SANeForce.com on 20/01/19.
//  Copyright © 2019 SANeForce.com. All rights reserved.
//

#import "ChmProfileData.h"

@implementation ChmProfileData
static ChmProfileData *ChmProfData = NULL;

+(ChmProfileData *)sharedDatas{
    @synchronized (ChmProfData) {
        if (!ChmProfData || ChmProfData==NULL) {
            ChmProfData=[[ChmProfileData alloc] init];
        }
        return ChmProfData;
    }
}
-(void)clearChmProfile{
    @synchronized(self) {
        if (ChmProfData != nil) {
            ChmProfData = nil;
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
