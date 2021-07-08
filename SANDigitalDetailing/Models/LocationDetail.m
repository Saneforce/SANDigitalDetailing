//
//  LocationDetail.m
//  SANDigitalDetailing
//
//  Created by SANeForce.com on 11/05/17.
//  Copyright © 2017 SANeForce.com. All rights reserved.
//

#import "LocationDetail.h"

@implementation LocationDetail
static LocationDetail *locationData = NULL;
+(LocationDetail *)sharedLocationData{
    @synchronized (locationData) {
        if (!locationData || locationData==NULL) {
            locationData=[[LocationDetail alloc] init];
            locationData.TrackedLocationList=[[NSMutableArray alloc] init];
        }
        return locationData;
    }
}
@end
