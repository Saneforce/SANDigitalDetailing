//
//  Pin.m
//  SANDigitalDetailing
//
//  Created by SANeForce.com on 04/01/20.
//  Copyright © 2020 SANeForce.com. All rights reserved.
//

#import "Pin.h"

@implementation Pin
- (id)initWithCoordinate:(CLLocationCoordinate2D)newCoordinate {
    
    self = [super init];
    if (self) {
        _coordinate = newCoordinate;
        _title = @"No Detail";
        _subtitle = @"";
    }
    return self;
}
- (id)initWithCoordinate:(CLLocationCoordinate2D)newCoordinate andTitle:(NSString *) title{
    
    self = [super init];
    if (self) {
        _coordinate = newCoordinate;
        _title = title;
        _subtitle = @"";
    }
    return self;
}
- (id)initWithCoordinate:(CLLocationCoordinate2D)newCoordinate andTitle:(NSString *) title andSubtitle:(NSString *) subtitle {
    
    self = [super init];
    if (self) {
        _coordinate = newCoordinate;
        _title = title;
        _subtitle = subtitle;
    }
    return self;
}
@end
