//
//  MapGEOViewController.m
//  SANDigitalDetailing
//
//  Created by SANeForce.com on 03/01/20.
//  Copyright © 2020 SANeForce.com. All rights reserved.
//

#import "MapGEOViewController.h"
#import "mCustomerCell.h"

@interface MapGEOViewController ()
@property (strong, nonatomic) CLLocationManager *mlocationManager;
@property (assign, nonatomic) bool MapCenter;
@property (nonatomic, strong) NSMutableArray* SHPlaces;
@property (nonatomic, strong) NSMutableArray* eModeList;
@property (nonatomic, strong) NSArray* ObjCustomerList;

@property (nonatomic, strong) NSArray* CustomerList;
@property (nonatomic,assign) NSString* eMode;
@property (nonatomic,assign) NSString* eModeNm;
@property (nonatomic,assign) NSString* CustCd;
@property (nonatomic,assign) NSString* CustNm;

@end

@implementation MapGEOViewController
@synthesize mlocationManager;
MKPlacemark *marker;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tvSHPlace.delegate = self;
    self.tvSHPlace.dataSource = self;
    self.tvEMode.delegate = self;
    self.tvEMode.dataSource = self;
    self.tbHQ.delegate = self;
    self.tbHQ.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.UserDet=[UserDetails sharedUserDetails];
    mlocationManager = [[CLLocationManager alloc] init];
    mlocationManager.delegate = self;
    self.MapView.delegate = self;
    mlocationManager.desiredAccuracy = kCLLocationAccuracyBest;
    mlocationManager.distanceFilter = kCLLocationAccuracyBestForNavigation;//constant update of device location
    
    if ([mlocationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
    {
        [mlocationManager requestAlwaysAuthorization];
    }
    [mlocationManager requestWhenInUseAuthorization];
    [mlocationManager startUpdatingLocation];
    self.MapView.showsUserLocation = YES;
    self.eModeList=[[NSMutableArray alloc] init];
    NSMutableDictionary* item=[[NSMutableDictionary alloc] init];
    [item setValue:@"D" forKey:@"Code"];
    [item setValue:@"Doctor" forKey:@"Name"];
    [self.eModeList addObject:item];
    item=[[NSMutableDictionary alloc] init];
    [item setValue:@"C" forKey:@"Code"];
    [item setValue:@"Chemist" forKey:@"Name"];
    [self.eModeList addObject:item];
    item=[[NSMutableDictionary alloc] init];
    [item setValue:@"S" forKey:@"Code"];
    [item setValue:@"Stockist" forKey:@"Name"];
    [self.eModeList addObject:item];
    item=[[NSMutableDictionary alloc] init];
    [item setValue:@"U" forKey:@"Code"];
    [item setValue:@"Unlisted Doctor" forKey:@"Name"];
    [self.eModeList addObject:item];
    self.objHQList= [[[NSUserDefaults standardUserDefaults] objectForKey:@"HQDetails.SANAPP"] mutableCopy];
    NSString *DataKey=[[NSString alloc] initWithFormat:@"DoctorDetails_%@.SANAPP",self.UserDet.SF];
    self.CustomerList =[[[NSUserDefaults standardUserDefaults] objectForKey:DataKey] mutableCopy];
    self.ObjCustomerList=[[[NSUserDefaults standardUserDefaults] objectForKey:DataKey] mutableCopy];
    self.CustomerList=[[self.ObjCustomerList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"uRwID=='1'"]] mutableCopy];
    self.ObjCustomerList=[[self.ObjCustomerList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"uRwID=='1'"]] mutableCopy];
    self.txtHQ.hidden=YES;
    self.lblHQ.hidden=YES;
    if(![_UserDet.Desig isEqualToString:@"MR"])
    {
        self.lblHQ.hidden=NO;
        self.txtHQ.hidden=NO;
    }
    if ([_objHQList count]>0 && ![_UserDet.Desig isEqualToString:@"MR"])
    {
        NSDictionary *HQ = self.objHQList[0];
        self.txtHQ.text = [HQ objectForKey:@"name"];
        self.DataSF = [HQ objectForKey:@"id"];
    }else{
        self.DataSF=_UserDet.SF;
    }

    [self RefreshDatas:self.DataSF];
    self.eMode=@"D";self.eModeNm=@"Doctor";
    self.tvEMode.alpha=0;
    self.vwNewCustDet.hidden=YES;
    _MapCenter=NO;
    [self getTaggedList];
    [self closeTableViews];
}
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    CLLocation * location = [locations lastObject];
    
    if(_MapCenter==NO){
        [self setMapCenterRegion:location];
    }
    //[mlocationManager stopUpdatingLocation];
}
-(void) setMapCenterRegion:(CLLocation *) location {
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake( location.coordinate.latitude,  location.coordinate.longitude);
   MKCoordinateSpan span = MKCoordinateSpanMake(0.01, 0.01);
   MKCoordinateRegion region = MKCoordinateRegionMake(center, span);
   [self.MapView setRegion:region animated:YES];
    
    // and add it to our view
//    Pin *newPin = [[Pin alloc] initWithCoordinate:center];
 //   [self.MapView addAnnotation:newPin];
    /*
     // remove previous marker
        MKPlacemark *previousMarker = [self.MapView.annotations lastObject];
        [self.MapView removeAnnotation:previousMarker];
    */
    // create a new marker in the middle
  /*  marker = [[MKPlacemark alloc] initWithCoordinate:location.coordinate addressDictionary:nil];
    [self.MapView addAnnotation:marker];*/
    // create an address from our coordinates
    
    
    
    _MapCenter=YES;
}
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    CLLocation *center = [[CLLocation alloc] initWithLatitude:_MapView.centerCoordinate.latitude longitude:_MapView.centerCoordinate.longitude];
    self.lblLatLong.text=[NSString stringWithFormat:@"( %f,%f )",_MapView.centerCoordinate.latitude,_MapView.centerCoordinate.longitude];
    [geocoder reverseGeocodeLocation:center completionHandler:^(NSArray *placemarks, NSError *error) {
        
        CLPlacemark *placemark = [placemarks lastObject];
        //NSString *address = [NSString stringWithFormat:@"%@, %@, %@, %@", placemark.thoroughfare, placemark.locality, placemark.administrativeArea, placemark.postalCode];
        NSArray *addr=[placemark.addressDictionary valueForKey:@"FormattedAddressLines"];
        NSString *address=@"";
        for(int ai=0;ai<[addr count];ai++){
            address=[NSString stringWithFormat:@"%@ %@",address, addr[ai]];
            if( ai<[addr count]-1) address=[NSString stringWithFormat:@"%@,",address];
        }
        //if (placemark.thoroughfare != NULL) {
            self.lblCurrAddress.text = address;
            self.tAddress.text = address;
        /*} else {
            self.lblCurrAddress.text = @"";
            self.tAddress.text = @"";
        }*/

    }];
}
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    // If it's the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    // Handle any custom annotations.
//    if ([annotation isKindOfClass:[MKPointAnnotation class]])
//    {
        // Try to dequeue an existing pin view first.
        MKAnnotationView *pinView = (MKAnnotationView*)[self.MapView dequeueReusableAnnotationViewWithIdentifier:@"CustomPinAnnotationView"];
        if (!pinView)
        {
            // If an existing pin view was not available, create one.
            pinView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"CustomPinAnnotationView"];
            ////pinView.animatesDrop = YES;
            pinView.canShowCallout = YES;
            pinView.image = [UIImage imageNamed:@"marker30"];
           // pinView.calloutOffset = CGPointMake(0, 32);
        } else {
            pinView.image = [UIImage imageNamed:@"marker30"];
            pinView.annotation = annotation;
        }
        return pinView;
//    }
//    return nil;
}
- (MKOverlayRenderer *)mapView:(MKMapView *)map viewForOverlay:(id <MKOverlay>)overlay
{
    MKCircleRenderer *circleView = [[MKCircleRenderer alloc] initWithOverlay:overlay];
    circleView.strokeColor = [UIColor redColor];
    circleView.fillColor = [[UIColor redColor] colorWithAlphaComponent:0.4];
    return circleView;
}

-(IBAction)ShowEMode:(id)sender{
    self.tvEMode.frame=CGRectMake(_btnMode.frame.origin.x-1 , _btnMode.frame.origin.y,0, 40);
    self.tvEMode.alpha=0;
    [self.view layoutIfNeeded];
    
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options: 0
                     animations:^{
                                        self.tvEMode.frame=CGRectMake(_btnMode.frame.origin.x-200 , _btnMode.frame.origin.y,200, 40);
        self.tvEMode.alpha=1;
    }
    completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5
                             delay:0.2
                           options: 0
                         animations:^{
                            self.tvEMode.frame=CGRectMake(_btnMode.frame.origin.x-200 , _btnMode.frame.origin.y,200, 150);
                            
                            }completion:^(BOOL finished) {    }];
                         }];
}
-(IBAction)ShowSearch:(id)sender{
    self.tSearchAddress.frame=CGRectMake(UIScreen.mainScreen.bounds.size.width-8, 10,0 , 30);
    self.tSearchAddress.alpha=0;
    self.btnSearch.alpha=1;
    self.btnCloseSearch.alpha=0;
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options: 0
                     animations:^{
        self.tSearchAddress.frame=CGRectMake(47 , 10,UIScreen.mainScreen.bounds.size.width-55, 30);
                          self.tSearchAddress.alpha=1;
                          self.btnSearch.alpha=0;
                     }
                     completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5
             delay:0.2
           options: 0
                         animations:^{
                            self.tSearchAddress.frame=CGRectMake(47 , 10,UIScreen.mainScreen.bounds.size.width-155, 30);
                            self.btnCloseSearch.alpha=1;
                            self.btnCloseSearch.frame=CGRectMake(UIScreen.mainScreen.bounds.size.width-108 , 10,100, 30);
        }completion:^(BOOL finished) {    }];
     }];
    
}
-(IBAction)HideSearch:(id)sender{
    self.tSearchAddress.frame=CGRectMake(47 , 10,UIScreen.mainScreen.bounds.size.width-155, 30);
    self.btnCloseSearch.alpha=1;
    self.btnCloseSearch.frame=CGRectMake(UIScreen.mainScreen.bounds.size.width-108 , 10,100, 30);
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options: 0
                     animations:^{
        self.tSearchAddress.frame=CGRectMake(47 , 10,UIScreen.mainScreen.bounds.size.width-55, 30);
                          self.tSearchAddress.alpha=1;
                          self.btnSearch.alpha=0;
                          self.btnCloseSearch.alpha=0;
                     }
                     completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5
             delay:0.2
           options: 0
                         animations:^{
            self.tSearchAddress.frame=CGRectMake(UIScreen.mainScreen.bounds.size.width-8, 10,0 , 30);
            self.tSearchAddress.alpha=0;
            self.btnSearch.alpha=1;
            self.btnCloseSearch.alpha=0;
            
        }completion:^(BOOL finished) {    }];
     }];
    
}
-(IBAction)searchPlaces:(id)sender{
    self.tvSHPlace.alpha=0;
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
     request.naturalLanguageQuery = self.tSearchAddress.text;
    //[request setRegion:self.MapView.region];
    MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:request];
    
    [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error){
        self.SHPlaces= [response.mapItems mutableCopy];
        [self.tvSHPlace reloadData];
        if([self.SHPlaces count]>0){
            [UIView animateWithDuration:0.5
                                  delay:0.0
                                options: 0
                             animations:^{
                self.tvSHPlace.alpha=1;
            }completion:^(BOOL finished) {    }];
                
        }
       /* for (MKMapItem *item in response.mapItems) {
            NSLog(@"%@", item.name);
            
        }*/
    }];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView==self.tvSHPlace) return 58;
    if(tableView==self.tvEMode) return 40;
    return 40;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView==self.tvSHPlace)
    {
        return self.SHPlaces.count;
    }
    if(tableView==self.tvEMode)
    {
        return self.eModeList.count;
    }
    if(tableView==self.tbHQ) return self.objHQList.count;
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TBSelectionBxCell* cell;
    if(tableView==self.tbHQ) {
        cell =[tableView dequeueReusableCellWithIdentifier:@"CellHQ" forIndexPath:indexPath];
        NSDictionary *HQ = self.objHQList[indexPath.row];
        cell.lOptText.text = [HQ objectForKey:@"name"];
    }
    else{
        cell=[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    }
    if(tableView==self.tvSHPlace) {
        MKMapItem *optLst = self.SHPlaces[indexPath.row] ;
        cell.lOptText.text=optLst.name;
        //NSArray *addr=[optLst.placemark.addressDictionary valueForKey:@"FormattedAddressLines"];
        //NSString *address=[NSString stringWithFormat:@"%@, %@, %@, %@",addr[0],addr[1],addr[2],addr[3]];
        NSString *address = [NSString stringWithFormat:@"%@, %@, %@, %@", optLst.placemark.thoroughfare, optLst.placemark.locality, optLst.placemark.administrativeArea, optLst.placemark.postalCode];
        cell.lOptVal.text=address; //"placemark"];
    }
    if(tableView==self.tvEMode) {
        NSMutableDictionary *optLst = self.eModeList[indexPath.row] ;
        cell.lOptText.text=[optLst valueForKey:@"Name"];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if(tableView==self.tvSHPlace) {
       //TBSelectionBxCell* cell =[tableView cellForRowAtIndexPath:indexPath];
       MKMapItem *item=[self.SHPlaces objectAtIndex:indexPath.row];
        [self setMapCenterRegion:item.placemark.location];
        self.tvSHPlace.alpha=0;
        [self HideSearch:nil];
        
    }
    if(tableView==self.tbHQ) {
        NSDictionary *HQ = self.objHQList[indexPath.row];
        self.txtHQ.text = [HQ objectForKey:@"name"];
        self.DataSF = [HQ objectForKey:@"id"];
        
        [self RefreshDatas:self.DataSF];
    }
    if(tableView==self.tvEMode) {
        NSMutableDictionary *optLst = self.eModeList[indexPath.row] ;
        self.eMode =[optLst valueForKey:@"Code"];
        self.eModeNm=[optLst valueForKey:@"Name"];
        
        [self RefreshDatas:_DataSF];
        
        if(self.segTypeMode.selectedSegmentIndex == 0) [self getTaggedList];
        if(self.segTypeMode.selectedSegmentIndex == 1) [self getFencingCust];
        if(self.segTypeMode.selectedSegmentIndex == 2) [self getExploreDet];
        [UIView animateWithDuration:0.5
                                 delay:0.0
                               options: 0
                            animations:^{
                                self.tvEMode.frame=CGRectMake(_btnMode.frame.origin.x-200 , _btnMode.frame.origin.y,200, 40);
                self.tvEMode.alpha=1;
           }
           completion:^(BOOL finished) {
               [UIView animateWithDuration:0.5
                                    delay:0.2
                                  options: 0
                                animations:^{
                                    self.tvEMode.frame=CGRectMake(_btnMode.frame.origin.x-1 , _btnMode.frame.origin.y,0, 40);
                    self.tvEMode.alpha=0;
                   
                   }completion:^(BOOL finished) {    }];
                }];
    }
    
}
-(void) RefreshDatas:(NSString*) DSF
{
    NSString *DataKey=[[NSString alloc] initWithFormat:@"DoctorDetails_%@.SANAPP",DSF];
    NSString *ApiPath=@"GET/Doctors";
    if([self.eMode isEqualToString:@"C"]){
        DataKey=[NSString stringWithFormat:@"ChemistDetails_%@.SANAPP",DSF];
        ApiPath=@"GET/Chemist";
    }
    if([self.eMode isEqualToString:@"S"]){
        DataKey=[NSString stringWithFormat:@"StockistDetails_%@.SANAPP",DSF];
        ApiPath=@"GET/Stockist";
    }
    if([self.eMode isEqualToString:@"N"]){
        DataKey=[NSString stringWithFormat:@"UnlistedDR_%@.SANAPP",DSF];
        ApiPath=@"GET/UnlistedDR";
    }
    
    [self LoadData:[[List alloc] initWithName:DataKey andLabel:@"" andApiPath:ApiPath Parameters:nil] andDataFor:DSF andIndexPath:nil];
}
-(void) ReloadCustData:(NSString*) DSF
{
    NSString *DataKey=[[NSString alloc] initWithFormat:@"DoctorDetails_%@.SANAPP",DSF];
    if([self.eMode isEqualToString:@"C"]) DataKey=[NSString stringWithFormat:@"ChemistDetails_%@.SANAPP",DSF];
    if([self.eMode isEqualToString:@"S"]) DataKey=[NSString stringWithFormat:@"StockistDetails_%@.SANAPP",DSF];
    if([self.eMode isEqualToString:@"N"]) DataKey=[NSString stringWithFormat:@"UnlistedDR_%@.SANAPP",DSF];
    self.CustomerList =[[[NSUserDefaults standardUserDefaults] objectForKey:DataKey] mutableCopy];
    self.ObjCustomerList=[[[NSUserDefaults standardUserDefaults] objectForKey:DataKey] mutableCopy];
    self.CustomerList=[[self.ObjCustomerList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"uRwID=='1'"]] mutableCopy];
    self.ObjCustomerList=[[self.ObjCustomerList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"uRwID=='1'"]] mutableCopy];
    [self.collectionView reloadData];
    [self closeTableViews];
    
}
-(IBAction)SegmentChangeViewValueChanged:(UISegmentedControl *)SControl{
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options: 0
                     animations:^{
         _btnNewTag.hidden=YES;
         _btnNewTag.alpha=0;
         _btnLocPin.hidden=YES;
         _btnLocPin.alpha=0;
         self.vwNewCustDet.hidden=YES;
         [self.MapView removeAnnotations:self.MapView.annotations];
         [self.MapView removeOverlays:self.MapView.overlays];
        if(SControl.selectedSegmentIndex == 0) {
            _btnNewTag.hidden=NO;
            _btnNewTag.alpha=1;
            _btnLocPin.hidden=NO;
            _btnLocPin.alpha=1;
            [self getTaggedList];
        }
        if(SControl.selectedSegmentIndex == 1){
            [self getFencingCust];
        }
        if(SControl.selectedSegmentIndex == 2){
            [self getExploreDet];self.vwNewCustDet.hidden=NO;
        }
        //self.vwScrbleWin.alpha=1;
        [self.view layoutIfNeeded];
    }
    completion:^(BOOL finished) {   }];
}
-(void) getTaggedList{
    [WBService SendServerRequest:@"GET/GEOTag" withParameter:[@{@"cust":self.eMode} mutableCopy] withImages:nil DataSF:nil
                     completion:^(BOOL success, id respData, NSMutableDictionary *DatawithImage){

                        NSMutableArray *receivedDta=[NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingAllowFragments error:nil];

                        [self.MapView removeAnnotations:self.MapView.annotations];
                        for(int il=0;il<[receivedDta count];il++){
                            CLLocationCoordinate2D center = CLLocationCoordinate2DMake( [[receivedDta[il] valueForKey:@"lat"] doubleValue],  [[receivedDta[il] valueForKey:@"long"] doubleValue]);
                           // MKCoordinateSpan span = MKCoordinateSpanMake(0.01, 0.01);
                            //MKCoordinateRegion region = MKCoordinateRegionMake(center, span);
                           // [self.MapView setRegion:region animated:YES];
                             // and add it to our view
                            Pin *newPin = [[Pin alloc] initWithCoordinate:center andTitle:[NSString stringWithFormat:@"%@ - [ %@ ]",[receivedDta[il] valueForKey:@"name"],self.eModeNm] andSubtitle:[NSString stringWithFormat:@"( %@,%@ )",[receivedDta[il] valueForKey:@"lat"],[receivedDta[il] valueForKey:@"long"]]  ];
                            
                            [self.MapView addAnnotation:newPin];
                        }
                     }
                          error:^(NSString *errorMsg, NSMutableDictionary *DatawithImage){
                              NSLog(@"%@",errorMsg);
                          }
    ];
    
}

-(IBAction)ShowDrSelection:(id) sender
{
    self.vwCustSelect.hidden=YES;
    self.vwCustSelect.alpha=0;
    [UIView animateWithDuration:0.5
         delay:0.2
       options: 0
                     animations:^{
        self.tSearchAddress.frame=CGRectMake(UIScreen.mainScreen.bounds.size.width-8, 10,0 , 30);
        self.vwCustSelect.hidden=NO;
        self.vwCustSelect.alpha=1;
    }completion:^(BOOL finished) {    }];
}
-(void) getFencingCust{
    
    CGFloat dis=_UserDet.DistRadius;

    MKCircle *circle = [MKCircle circleWithCenterCoordinate:self.MapView.userLocation.coordinate radius:(1000*dis)];
    [_MapView addOverlay:circle];
    NSPredicate *findDistance = [NSPredicate predicateWithBlock: ^BOOL(id obj, NSDictionary *bind){
        CLLocationCoordinate2D CusLoc=CLLocationCoordinate2DMake([[obj valueForKey:@"lat"] doubleValue], [[obj valueForKey:@"long"] doubleValue]);
        CGFloat cDis=[BaseViewController directMetersFromCoordinate:_MapView.userLocation.location.coordinate toCoordinate:CusLoc];
        if([[obj valueForKey:@"Long"] doubleValue]>0){
            NSLog(@"%@",[obj valueForKey:@"ong"]);
        }
        NSLog(@"%f %d",cDis,(cDis>0 && cDis <= dis));
        return cDis>0 && cDis <= dis;
    }];
    [WBService SendServerRequest:@"GET/GEOTag" withParameter:[@{@"cust":self.eMode} mutableCopy] withImages:nil DataSF:nil
    completion:^(BOOL success, id respData, NSMutableDictionary *DatawithImage){
           NSMutableArray *receivedDta=[NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingAllowFragments error:nil];
           [self.MapView removeAnnotations:self.MapView.annotations];
           receivedDta=[[receivedDta filteredArrayUsingPredicate:findDistance] mutableCopy];
           for(int il=0;il<[receivedDta count];il++){
               CLLocationCoordinate2D center = CLLocationCoordinate2DMake( [[receivedDta[il] valueForKey:@"lat"] doubleValue],  [[receivedDta[il] valueForKey:@"long"] doubleValue]);
               
               // MKCoordinateSpan span = MKCoordinateSpanMake(0.01, 0.01);
                //MKCoordinateRegion region = MKCoordinateRegionMake(center, span);
               // [self.MapView setRegion:region animated:YES];
                 // and add it to our view
                Pin *newPin = [[Pin alloc] initWithCoordinate:center andTitle:[NSString stringWithFormat:@"%@ - [ %@ ]",[receivedDta[il] valueForKey:@"name"],self.eModeNm] andSubtitle:[NSString stringWithFormat:@"( %@,%@ )",[receivedDta[il] valueForKey:@"lat"],[receivedDta[il] valueForKey:@"long"]]  ];
                
                [self.MapView addAnnotation:newPin];
           }
    }
     error:^(NSString *errorMsg, NSMutableDictionary *DatawithImage){
         NSLog(@"%@",errorMsg);
     }];
}
-(void) getExploreDet{
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
     request.naturalLanguageQuery = self.eModeNm;
    //[request setRegion:self.MapView.region];
    MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:request];
    
    [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error){
        [self.MapView removeAnnotations:self.MapView.annotations];
       for (MKMapItem *item in response.mapItems) {
                                    //   MKCoordinateSpan span = MKCoordinateSpanMake(0.01, 0.01);
                                    //   MKCoordinateRegion region = MKCoordinateRegionMake(item.placemark.location.coordinate, span);
                                       //[self.MapView setRegion:region animated:YES];
                                        // and add it to our view
                                       Pin *newPin = [[Pin alloc] initWithCoordinate:item.placemark.location.coordinate andTitle:[NSString stringWithFormat:@"%@ - [ %@ ]",item.name,self.eModeNm] andSubtitle:[NSString stringWithFormat:@"%@ \n( %f,%f )",item.placemark.thoroughfare,item.placemark.location.coordinate.latitude ,item.placemark.location.coordinate.longitude]  ];
            
            
            [self.MapView addAnnotation:newPin];
                                   
            
        }
    }];
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.CustomerList.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    mCustomerCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath] ;
    
    
    cell.layer.cornerRadius=4.0f;
    cell.lCustName.text = [self.CustomerList[indexPath.row] objectForKey:@"Name"];
    cell.lTagDet.text = [NSString stringWithFormat:@"[ %@ / %@ ]",[self.CustomerList[indexPath.row] objectForKey:@"GEOTagCnt"],[self.CustomerList[indexPath.row] objectForKey:@"MaxGeoMap"]];
    
    cell.lCustName.textColor=[UIColor whiteColor];
    cell.lTownName.text = [self.CustomerList[indexPath.row] objectForKey:@"Town_Name"];
    cell.lCategory.text = [self.CustomerList[indexPath.row] objectForKey:@"Category"];
    cell.lSpeciality.text = [self.CustomerList[indexPath.row] objectForKey:@"Specialty"];
    cell.selImgID.image=[UIImage imageNamed:@"locationW"];
    if([[self.CustomerList[indexPath.row] objectForKey:@"GEOTagCnt"] integerValue]>0){
        cell.selImgID.image=[UIImage imageNamed:@"locationB"];
    }
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if([[self.CustomerList[indexPath.row] objectForKey:@"GEOTagCnt"] integerValue]>=[[self.CustomerList[indexPath.row] objectForKey:@"MaxGeoMap"] integerValue]){
        [BaseViewController Toast:@"Can't Select Maximum Tagging Reached..."];
    }else{
        self.CustCd=[self.CustomerList[indexPath.row] objectForKey:@"Code"];
        self.CustNm=[self.CustomerList[indexPath.row] objectForKey:@"Name"];
        
        self.lblDrName.text=self.CustNm;
        self.vwCustSelect.hidden=YES;
        self.vwCustDet.hidden=NO;
        [self.view endEditing:YES];
    }
}
-(IBAction) SaveCustTag:(id) sender{
    NSMutableDictionary* parm=[[NSMutableDictionary alloc] init];
    [parm setValue:self.CustCd forKey:@"cuscode"];
    [parm setValue:[NSString stringWithFormat:@"%f",_MapView.centerCoordinate.latitude] forKey:@"lat"];
    [parm setValue:[NSString stringWithFormat:@"%f",_MapView.centerCoordinate.longitude]  forKey:@"long"];
    [parm setValue:self.eMode forKey:@"cust"];
    
    //$div=(string) $data['divcode'];
    [WBService SendServerRequest:@"SAVE/GEOTag" withParameter:parm withImages:nil DataSF:nil
         completion:^(BOOL success, id respData, NSMutableDictionary *DatawithImage){
            NSMutableArray *receivedDta=[NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingAllowFragments error:nil];
        [BaseViewController Toast:[receivedDta valueForKey:@"Msg"]];_CustomerList=[[NSArray alloc] init];_ObjCustomerList=[[NSArray alloc] init];[self.collectionView reloadData];
            [self RefreshDatas:self.DataSF];
            [self getTaggedList ];
            self.vwCustDet.hidden=YES;
          }
          error:^(NSString *errorMsg, NSMutableDictionary *DatawithImage){
              NSLog(@"%@",errorMsg);
          }
    ];
}
-(IBAction) hideCust:(id) sender{
    self.vwCustDet.hidden=YES;
}

-(IBAction) hideCustSel:(id) sender{
    self.vwCustSelect.hidden=YES;
}
-(IBAction) searchCustList:(id)sender{
    NSMutableArray *MkList = [[self.ObjCustomerList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Name contains[c] %@", self.searchBox.text]] mutableCopy];
    NSSortDescriptor *NameField = [NSSortDescriptor sortDescriptorWithKey:@"Name" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:NameField, nil];
    self.CustomerList = [[MkList sortedArrayUsingDescriptors:sortDescriptors] mutableCopy];
    [self.collectionView reloadData];
    
}
-(IBAction) openSelHQ:(id)sender{
    BOOL upState=!self.tbHQ.hidden;
    [self closeTableViews];
    self.tbHQ.hidden=upState;
}
-(void) closeTableViews{
    self.tbHQ.hidden=YES;
}
-(IBAction)GotoBack:(id)sender{
    
    NSArray *viewControllers = [self.navigationController viewControllers];
    [self.navigationController popToViewController:[viewControllers objectAtIndex:0] animated:NO];
}


-(void) LoadData:(List *) list andDataFor:(NSString *)dataSF andIndexPath:(NSIndexPath *)indexPath{
    [WBService SendServerRequest:list.apiPath withParameter:list.param withImages:nil DataSF:dataSF completion:^(BOOL success, id respData, NSMutableDictionary *DatawithImage){
            NSMutableDictionary *receivedDta=[NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingAllowFragments error:nil];
            [WBService saveData:receivedDta forKey:list.name];
            [self ReloadCustData:dataSF];
            NSLog(@"%@ Reloaded Successfully...",list.name);
        }
        error:^(NSString *errorMsg, NSMutableDictionary *DatawithImage){
           NSLog(@"%@",errorMsg);
        }
     ];
}
/*

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    NSLog(@"Latitude: %f" , userLocation.coordinate.latitude);
    NSLog(@"Longitude: %f" , userLocation.coordinate.latitude);
}
- (MKAnnotationView *)mapView:(MKMapView *)map viewForAnnotation:(id <MKAnnotation>)annotation
{
    static NSString *AnnotationViewID = @"annotationView";

    MKAnnotationView *annotationView = (MKAnnotationView *)[_MapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];

    if (annotationView == nil){
        annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
    }

    annotationView.image = [UIImage imageNamed:@"GEOtag"];
    annotationView.annotation = annotation;

    return annotationView;
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
