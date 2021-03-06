//
//  AuthenticationManager.m
//  SANDigitalDetailing
//
//  Created by SANeForce.com on 09/12/20.
//  Copyright © 2020 SANeForce.com. All rights reserved.
//

#import "AuthenticationManager.h"

@interface AuthenticationManager()

@property NSString* appId;
@property NSArray<NSString*>* graphScopes;
@property MSALPublicClientApplication* publicClient;

@end

@implementation AuthenticationManager

+ (id) instance {
    static AuthenticationManager *singleInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^ {
        singleInstance = [[self alloc] init];
    });

    return singleInstance;
}

- (id) init {
    if (self = [super init]) {
        // Get app ID and scopes from AuthSettings.plist
        NSString* authConfigPath =
        [NSBundle.mainBundle pathForResource:@"Info" ofType:@"plist"];
        NSDictionary* authConfig = [NSDictionary dictionaryWithContentsOfFile:authConfigPath];

        self.appId = authConfig[@"AppId"];
        self.graphScopes = authConfig[@"GraphScopes"];

        // Create the MSAL client
        self.publicClient = [[MSALPublicClientApplication alloc] initWithClientId:self.appId error:nil];
    }

    return self;
}

- (void) getAccessTokenForProviderOptions:(id<MSAuthenticationProviderOptions>)authProviderOptions andCompletion:(void (^)(NSString * _Nonnull, NSError * _Nonnull))completion {
    [self getTokenSilentlyWithCompletionBlock:completion];
}

- (void) getTokenInteractivelyWithParentView:(UIViewController *)parentView andCompletionBlock:(GetTokenCompletionBlock)completionBlock {
    MSALWebviewParameters* webParameters = [[MSALWebviewParameters alloc] initWithParentViewController:parentView];
    MSALInteractiveTokenParameters* interactiveParameters =
    [[MSALInteractiveTokenParameters alloc]initWithScopes:self.graphScopes webviewParameters:webParameters];

    // Call acquireToken to open a browser so the user can sign in
    [self.publicClient
     acquireTokenWithParameters:interactiveParameters
     completionBlock:^(MSALResult * _Nullable result, NSError * _Nullable error) {

        // Check error
        if (error) {
            completionBlock(nil, error);
            return;
        }

        // Check result
        if (!result) {
            NSMutableDictionary* details = [NSMutableDictionary dictionary];
            [details setValue:@"No result was returned" forKey:NSDebugDescriptionErrorKey];
            completionBlock(nil, [NSError errorWithDomain:@"AuthenticationManager" code:0 userInfo:details]);
            return;
        }

        NSLog(@"Got token interactively: %@", result.accessToken);
        completionBlock(result.accessToken, nil);
    }];
}

- (void) getTokenSilentlyWithCompletionBlock:(GetTokenCompletionBlock)completionBlock {
    // Check if there is an account in the cache
    NSError* msalError;
    MSALAccount* account = [self.publicClient allAccounts:&msalError].firstObject;

    if (msalError || !account) {
        NSMutableDictionary* details = [NSMutableDictionary dictionary];
        [details setValue:@"Could not retrieve account from cache" forKey:NSDebugDescriptionErrorKey];
        completionBlock(nil, [NSError errorWithDomain:@"AuthenticationManager" code:0 userInfo:details]);
        return;
    }

    MSALSilentTokenParameters* silentParameters = [[MSALSilentTokenParameters alloc] initWithScopes:self.graphScopes
                                                                                            account:account];

    // Attempt to get token silently
    [self.publicClient
     acquireTokenSilentWithParameters:silentParameters
     completionBlock:^(MSALResult * _Nullable result, NSError * _Nullable error) {
         // Check error
         if (error) {
             completionBlock(nil, error);
             return;
         }

         // Check result
         if (!result) {
             NSMutableDictionary* details = [NSMutableDictionary dictionary];
             [details setValue:@"No result was returned" forKey:NSDebugDescriptionErrorKey];
             completionBlock(nil, [NSError errorWithDomain:@"AuthenticationManager" code:0 userInfo:details]);
             return;
         }

         NSLog(@"Got token silently: %@", result.accessToken);
         completionBlock(result.accessToken, nil);
     }];
}

- (void) signOut {
    NSError* msalError;
    NSArray* accounts = [self.publicClient allAccounts:&msalError];

    if (msalError) {
        NSLog(@"Error getting accounts from cache: %@", msalError.debugDescription);
        return;
    }
    for (id account in accounts) {
        NSLog(@"%@ Removed",account);
        [self.publicClient removeAccount:account error:nil];
        
    }
}


@end
