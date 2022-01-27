//
//  AppDelegate.m
//  SANDigitalDetailing
//
//  Created by SANeForce.com on 01/07/16.
//  Copyright © 2016 SANeForce.com. All rights reserved.
//

#import "AppDelegate.h"
#import "AppSettings.h"
#import "ViewController.h"
#import "UITextViewWorkaround.h"
#import <MSAL/MSAL.h>
#import <AppTrackingTransparency/AppTrackingTransparency.h>
#import <AdSupport/AdSupport.h>
@implementation NSURLRequest(DataController)
+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString *)host
{
    return YES;
}
@end
@interface AppDelegate ()
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [UITextViewWorkaround executeWorkaround];
    self.config=[Config sharedConfig];
    _iPadDevice=YES;
    _StoryboardID=@"Main";
   /* if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        _iPadDevice=NO;
        _StoryboardID=@"iPhoneMain";
        
    }*/
    self.config.iPadDevice=_iPadDevice;
    
    if (@available(iOS 14.0, *))
    {
        [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
        // Tracking authorization completed. Start loading ads here.
        // [self loadAd];
      }];
    }
    NSMutableDictionary *ServDet = [[[NSUserDefaults standardUserDefaults] objectForKey:@"ServerDet.SANConfigAPP"] mutableCopy];
    //[Config SaveConfig];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:_StoryboardID bundle:nil];
    if(ServDet==nil){
        AppSettings *currentViewController = [storyboard instantiateViewControllerWithIdentifier:@"AppSetting"];
        self.window.rootViewController = currentViewController;
    }else{
        ViewController *currentViewController = [storyboard instantiateViewControllerWithIdentifier:@"vcLogin"];
        self.window.rootViewController = currentViewController;
    }
    [self.window makeKeyAndVisible];
    return YES;
}
-(void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier completionHandler:(void (^)())completionHandler{
    
    self.backgroundTransferCompletionHandler = completionHandler;
    
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (BOOL)application:(UIApplication *) app openURL:(nonnull NSURL *)url options:(nonnull NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options{
    return [MSALPublicClientApplication handleMSALResponse:url
                                             sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]];
}
@end

