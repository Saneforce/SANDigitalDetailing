//
//  Config.h
//  SANDigitalDetailing
//
//  Created by SANeForce.com on 05/09/16.
//  Copyright © 2016 SANeForce.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Config : NSObject
@property (nonatomic,weak) NSString* WebUrl;
@property (nonatomic,weak) NSString* BaseUrl;
@property (nonatomic,weak) NSString* SlideUrl;
@property (nonatomic,weak) NSString* ReportUrl;
@property (nonatomic,weak) NSString* CmpLogo;
@property Boolean iPadDevice;

+(Config *) sharedConfig;
+(void) SaveConfig;
@end
