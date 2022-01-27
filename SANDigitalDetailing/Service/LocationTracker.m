//
//  LocationTracker.m
//  SANDigitalDetailing
//
//  Created by SANeForce.com on 10/05/17.
//  Copyright © 2017 SANeForce.com. All rights reserved.
//

#import "LocationTracker.h"

@implementation LocationTracker
@synthesize locationManager;
-(void) checkLocationServicesAndStartUpdates
{
    self.SetupData=[AppSetupData sharedDatas];
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = kCLLocationAccuracyBestForNavigation;//constant update of device location
    
    if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
    {
        [locationManager requestAlwaysAuthorization];
    }
    
    //Checking authorization status
    if (self.SetupData.GeoNeed==0 &&  ([CLLocationManager locationServicesEnabled]==NO || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied))
    {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Location Services Disabled!"
                                                            message:@"Please enable Location Based Services for better results! We promise to keep your location private"
                                                           delegate:self
                                                  cancelButtonTitle:@"Settings"
                                                  otherButtonTitles:@"Cancel", nil];
        
        //TODO if user has not given permission to device
       /* if (![CLLocationManager locationServicesEnabled])
        {
            alertView.tag = 100;
        }
        //TODO if user has not given permission to particular app
        else
        {*/
            alertView.tag = 200;
        //}
        
       // [alertView show];
        
        return;
    }
    else
    {
        //Location Services Enabled, let's start location updates
        [locationManager startUpdatingLocation];
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if(buttonIndex == 0) //Settings button pressed
    {
        /*if (alertView.tag == 100)
        {
            //This will open ios devices location settings
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=LOCATION_SERVICES"]];
        }
        else*/ if (alertView.tag == 200)
        {
            //This will open particular app location settings
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }
    }
    else if(buttonIndex == 1)//Cancel button pressed.
    {
        //TODO for cancel
    }
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"Location Failed : %@", error.debugDescription);
    //UIAlertView *errorAlert = [[UIAlertView alloc]
    //                           initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    //[errorAlert show];
}
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    for(int i=0;i<locations.count;i++){
        CLLocation * newLocation = [locations objectAtIndex:i];
        CLLocationCoordinate2D theLocation = newLocation.coordinate;
        CLLocationAccuracy theAccuracy = newLocation.horizontalAccuracy;
        
        NSTimeInterval locationAge = -[newLocation.timestamp timeIntervalSinceNow];
        NSLog(@"New Location: %f , %f", theLocation.latitude,theLocation.longitude);
        if (locationAge > 30.0)
        {
            continue;
        }
        
        //Select only valid location and also location with good accuracy
        if(newLocation!=nil&&theAccuracy>0
           &&theAccuracy<2000
           &&(!(theLocation.latitude==0.0&&theLocation.longitude==0.0))){
            
            //self.myLastLocation = theLocation;
            //self.myLastLocationAccuracy= theAccuracy;
            
            NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
            [dict setObject:[NSNumber numberWithFloat:theLocation.latitude] forKey:@"latitude"];
            [dict setObject:[NSNumber numberWithFloat:theLocation.longitude] forKey:@"longitude"];
            [dict setObject:[NSNumber numberWithFloat:theAccuracy] forKey:@"theAccuracy"];
            
            //longitudeLabel.text = [NSString stringWithFormat:@"%.8f", theLocation.longitude];
            //latitudeLabel.text = [NSString stringWithFormat:@"%.8f", theLocation.latitude];
            
            //Add the vallid location with good accuracy into an array
            //Every 1 minute, I will select the best location based on accuracy and send to server
            ////[self.shareModel.myLocationArray addObject:dict];
        }
    }
    
}
/*- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
 {
 CLLocation *currentLocation = newLocation;
 
 if (currentLocation != nil) {
 longitudeLabel.text = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
 latitudeLabel.text = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
 }
 }*/

@end
