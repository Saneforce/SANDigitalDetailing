//
//  LocationTracker.h
//  SANDigitalDetailing
//
//  Created by SANeForce.com on 10/05/17.
//  Copyright © 2017 SANeForce.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "BaseViewController.h"
@interface LocationTracker : UIViewController<CLLocationManagerDelegate>

@property (nonatomic, strong) AppSetupData* SetupData;
@property (strong, nonatomic) CLLocationManager *locationManager;

-(void) checkLocationServicesAndStartUpdates;
@end
