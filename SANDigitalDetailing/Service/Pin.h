//
//  Pin.h
//  SANDigitalDetailing
//
//  Created by SANeForce.com on 04/01/20.
//  Copyright © 2020 SANeForce.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
NS_ASSUME_NONNULL_BEGIN

 
@interface Pin : NSObject <MKAnnotation>
 
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
 
- (id)initWithCoordinate:(CLLocationCoordinate2D)newCoordinate;
- (id)initWithCoordinate:(CLLocationCoordinate2D)newCoordinate andTitle:(NSString *) title;
- (id)initWithCoordinate:(CLLocationCoordinate2D)newCoordinate andTitle:(NSString *) title andSubtitle:(NSString *) subtitle;
@end

NS_ASSUME_NONNULL_END
