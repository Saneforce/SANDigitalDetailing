//
//  AppDelegate.h
//  SANDigitalDetailing
//
//  Created by SANeForce.com on 01/07/16.
//  Copyright © 2016 SANeForce.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Config.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, copy) void(^backgroundTransferCompletionHandler)();

@property  Boolean iPadDevice;
@property (strong, nonatomic) NSString *StoryboardID;

@property (nonatomic,strong) Config* config;
@end

