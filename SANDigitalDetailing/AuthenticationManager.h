//
//  AuthenticationManager.h
//  SANDigitalDetailing
//
//  Created by SANeForce.com on 09/12/20.
//  Copyright © 2020 SANeForce.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MSAL/MSAL.h>
#import <MSGraphClientSDK/MSGraphClientSDK.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^GetTokenCompletionBlock)(NSString* _Nullable accessToken, NSError* _Nullable error);

@interface AuthenticationManager : NSObject<MSAuthenticationProvider>

+ (id) instance;
- (void) getTokenInteractivelyWithParentView: (UIViewController*) parentView andCompletionBlock: (GetTokenCompletionBlock)completionBlock;
- (void) getTokenSilentlyWithCompletionBlock: (GetTokenCompletionBlock)completionBlock;
- (void) signOut;
- (void) getAccessTokenForProviderOptions:(id<MSAuthenticationProviderOptions>)authProviderOptions andCompletion:(void (^)(NSString *, NSError *))completion;
@end

NS_ASSUME_NONNULL_END
