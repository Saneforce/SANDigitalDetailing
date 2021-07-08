//
//  Config.m
//  SANDigitalDetailing
//
//  Created by SANeForce.com on 05/09/16.
//  Copyright © 2016 SANeForce.com. All rights reserved.
//

#import "Config.h"

@implementation Config

static Config *config = NULL;
+(Config *)sharedConfig{
    @synchronized (config) {
        if (!config || config==NULL) {
            config=[[Config alloc] init];
            
            
        }
        
        NSMutableDictionary *ServDet = [[[NSUserDefaults standardUserDefaults] objectForKey:@"ServerDet.SANConfigAPP"] mutableCopy];
        config.WebUrl=[ServDet objectForKey:@"WebUrl"];
        config.BaseUrl=[ServDet objectForKey:@"baseUrl"];
        config.SlideUrl=[ServDet objectForKey:@"slideUrl"];
        config.ReportUrl=[ServDet objectForKey:@"reportUrl"];
        config.CmpLogo=[ServDet objectForKey:@"Cmplogo"];
        config.iPadDevice=[[ServDet objectForKey:@"DeviceType"] boolValue];
        return config;
    }
}
+(void) SaveConfig{
    NSMutableDictionary *ServDet=[[NSMutableDictionary alloc] init];
    [ServDet setValue:config.WebUrl forKey:@"WebUrl"];
    [ServDet setValue:config.BaseUrl forKey:@"baseUrl"];
    [ServDet setValue:config.SlideUrl forKey:@"slideUrl"];
    [ServDet setValue:config.ReportUrl forKey:@"reportUrl"];
    [ServDet setValue:config.CmpLogo forKey:@"Cmplogo"];
    [ServDet setValue:[NSNumber numberWithBool:config.iPadDevice]  forKey:@"DeviceType"];
    
    [[NSUserDefaults standardUserDefaults] setObject:ServDet forKey:@"ServerDet.SANConfigAPP"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
