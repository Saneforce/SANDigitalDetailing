//
//  UserDetails.m
//  SANAPP
//
//  Created by SANeForce.com on 25/06/16.
//  Copyright © 2016 SANeForce.com. All rights reserved.
//

#import "UserDetails.h"

@implementation UserDetails
static UserDetails *UserDetail = NULL;
- (instancetype)initWithAttributes:(NSDictionary *)UserDet
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.SF = [UserDet objectForKey:@"SF_Code"];
    self.SFName = [UserDet objectForKey:@"SF_Name"];
    self.Desig  = [UserDet objectForKey:@"desig_Code"];
    self.HQName = [UserDet objectForKey:@"HQName"];
    self.DivCode = [UserDet objectForKey:@"Division_Code"];
    self.GEOTagNeed=[[UserDet objectForKey:@"GEOTagNeed"] intValue];
    self.DistRadius=[[UserDet objectForKey:@"DisRad"] floatValue];
    self.RateEditable=[[UserDet objectForKey:@"OurPRateEdit"] boolValue];
    self.CPRateEditable=[[UserDet objectForKey:@"CPRateEdit"] boolValue];
    //self.SF
    return self;
}
+(UserDetails *)sharedUserDetails{
    @synchronized (UserDetail) {
        if (!UserDetail || UserDetail==NULL) {
            UserDetail=[[UserDetails alloc] init];
        }
        return UserDetail;
    }
}
+(UserDetails *)sharedUserDetails:(NSDictionary *)UserDet{
    @synchronized (UserDetail) {
        if (!UserDetail || UserDetail==NULL) {
            UserDetail=[[UserDetails alloc] init];
        }
        UserDetail=[UserDetail initWithAttributes:UserDet];
        return UserDetail;
    }
}
@end
